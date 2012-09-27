/*
===============================================================================
 Name        : main.c
 Author      : 
 Version     :
 Copyright   : Copyright (C) 
 Description : main definition
===============================================================================
*/

#ifdef __USE_CMSIS
#include "LPC11xx.h"
#endif

#include <cr_section_macros.h>
#include <NXP/crp.h>

// Variable to store CRP value in. Will be placed automatically
// by the linker when "Enable Code Read Protect" selected.
// See crp.h header for more information
__CRP const unsigned int CRP_WORD = CRP_NO_CRP ;

#include "driver_config.h"
#include "target_config.h"

#include "timer16.h"
#include "gpio.h"
#include "debug_printf.h"

#include "wakeupdefs.h"

//extern int fibonacci(int index, int a, int b);




//
// Start Normal Config
//


// Configuration for normal operation
// If other peripherals are used, they need to be added to the _RUN macro
#define BF_PDRUNCFG_RUN    (BF_PDCFG_RESERVEDMSK   \
                            & ~(  BF_PDCFG_IRC     \
                                | BF_PDCFG_FLASH   \
                                | BF_PDCFG_WDTOSC))

// If other peripherals are used, they need to be added to the _RUN macro
#define BF_SYSAHBCLKCTRL_RUN       (BF_SYSAHBCLKCTRL_SLEEP  \
                                  | BF_SYSAHBCLKCTRL_GPIO   \
								  | BF_SYSAHBCLKCTRL_FLASHREG \
                                  | BF_SYSAHBCLKCTRL_ROM    \
                                  | BF_SYSAHBCLKCTRL_IOCON)

#define MainClockFrequency 12000000
#define WDTClockFrequency 9000 /* estimate used during debug mode */

// Approximate go to sleep+wake time in # of clock cycles
#define WUTIME_CLOCKS           60

// When changing any of the values below, check that none of the
// 16-bit timer code overflows
#define PROCDURATION_MS			10000
#define  LEDDURATION_MS         50
#define WAKEDURATION_MS			(PROCDURATION_MS + LEDDURATION_MS)
#define SLEEPDURATION_MS        200
#define WDOMEASUREDURATION_MS   WAKEDURATION_MS

#define GPREG0 0x40038004

unsigned long i=0;

//
// END Normal Config
//





int fibonacci(int n)
{
    int c;

    if (n == 1 || n == 2)
        return 1;

    c = fibonacci(n-2) + fibonacci(n-1);

    return c;
}

void Wait1mS(uint32_t i)
{
    SysTick->VAL = 0; // clear counter

    while(i)
    {
        // Wait for systick counter to count down and reset
        while(!(SysTick->CTRL & BF_SYSTICK_COUNTFLAG))
        	__WFI();

        i--;
    }
}

void SysTick_Handler(void)
{
}

void InitDeepSleep(void)
{
#ifdef ENABLE_CLKOUT
    /* Output the Clk onto the CLKOUT Pin PIO0_1 to monitor the freq on a scope */
    LPC_IOCON->PIO0_1       = 0xC1;
    /* Select the MAIN clock as the clock out selection since it's driving the core */
    LPC_SYSCON->CLKOUTCLKSEL = 3;
    LPC_SYSCON->CLKOUTDIV = 10;
    LPC_SYSCON->CLKOUTUEN = 0;
    LPC_SYSCON->CLKOUTUEN = 1;

#endif /* ENABLE_CLKOUT */

    // Set up Systick timer for 1 mS timeouts
    // Used for general timing when awake and to calibrate the WDT
    SysTick->LOAD = (MainClockFrequency / 1000)-1;
    SysTick->VAL = 0; // reload counter
    SysTick->CTRL = 7; // enable counter, interrupts, select processor clock

    LPC_SYSCON->PDAWAKECFG =       // Configure PDAWAKECFG to restore PDRUNCFG on wake up
            LPC_SYSCON->PDRUNCFG;

    LPC_SYSCON->PDSLEEPCFG = BF_PDSLEEPCFG_WDT; // Configure deep sleep with WDT oscillator

    LPC_TMR16B0->TCR = BF_TIMER_TCR_RESET; // reset timer

    // The following lines initializing PR and MR0 are at risk for overflow
    // if the timing and frequency parameters are changed because they are
    // using a 16-bit timer.
#ifndef DEBUG
    LPC_TMR16B0->PR = 0;
    LPC_TMR16B0->MR0 = (SLEEPDURATION_MS*MeasureWDO()/WDOMEASUREDURATION_MS - WUTIME_CLOCKS - 1);
#else
    LPC_TMR16B0->PR = (MainClockFrequency / WDTClockFrequency) -1;
    LPC_TMR16B0->MR0 = SLEEPDURATION_MS*WDTClockFrequency/1000;
#endif

    LPC_TMR16B0->MCR = BF_TIMER_MCR_MATCHSTOP0 | BF_TIMER_MCR_MATCHRESET0;

    LPC_IOCON->PIO0_8 = (LPC_IOCON->PIO0_8 & ~0x3F) | 0x2; // Set IOCON register on P0.8 to match function

    /* Configure Wakeup I/O */
    /* Specify the start logic to allow the chip to be waken up using PIO0_8 */
    LPC_SYSCON->STARTAPRP0          |=  BF_STARTLOGIC_P0_8; // Rising edge
    LPC_SYSCON->STARTRSRP0CLR       =   BF_STARTLOGIC_P0_8; // Clear pending bit
    LPC_SYSCON->STARTERP0           |=  BF_STARTLOGIC_P0_8; // Enable Start Logic
    NVIC_EnableIRQ(WAKEUP8_IRQn);
}

void InitGPIOForSleep(void)
{
    // Set pins to output and drive low
    // changes need to be made here depending on PCB layout to
    // minimize power consumption
#ifdef DEBUG
    LPC_GPIO0->DIR  = 0xFFE; // Set all GPIO pins as outputs except reset
#else
    LPC_GPIO0->DIR  = 0xFFF; // Set all GPIO pins as outputs
#endif
    LPC_GPIO1->DIR  = 0xFFF; // Set all GPIO pins as outputs
    LPC_GPIO2->DIR  = 0xFFF; // Set all GPIO pins as outputs
    LPC_GPIO3->DIR  = 0xFFF; // Set all GPIO pins as outputs

#ifdef LPCXPRESSO_LPC1343_BOARD
    LPC_GPIO0->DATA = 1;     // Set all GPIO pins low except JTAG reset
#else
    LPC_GPIO0->DATA = 0;     // Set all GPIO pins low
#endif
    LPC_GPIO1->DATA = 0;     // Set all GPIO pins low
#ifdef KEIL_MCB1000_BOARD
    LPC_GPIO2->DATA = 0xFF;  // All pins low except LEDs
#else
    LPC_GPIO2->DATA = 0;     // Set all GPIO pins low
#endif
    LPC_GPIO3->DATA = 0;     // Set all GPIO pins low

    // Configure pins as GPIO without pullup
    LPC_IOCON->PIO2_6 = 0xC0;
    LPC_IOCON->PIO2_0 = 0xC0;
    LPC_IOCON->PIO0_1 = 0xC0;
    LPC_IOCON->PIO1_8 = 0xC0;
    LPC_IOCON->PIO0_2 = 0xC0;
    LPC_IOCON->PIO2_7 = 0xC0;
    LPC_IOCON->PIO2_8 = 0xC0;
    LPC_IOCON->PIO2_1 = 0xC0;
    LPC_IOCON->PIO0_3 = 0xC0;
    LPC_IOCON->PIO0_4 = 0xC0; // I2C pin
    LPC_IOCON->PIO0_5 = 0xC0; // I2C pin
    LPC_IOCON->PIO1_9 = 0xC0;
    LPC_IOCON->PIO3_4 = 0xC0;
    LPC_IOCON->PIO2_4 = 0xC0;
    LPC_IOCON->PIO2_5 = 0xC0;
    LPC_IOCON->PIO3_5 = 0xC0;
    LPC_IOCON->PIO0_6 = 0xC0;
    LPC_IOCON->PIO0_7 = 0xC0;
    LPC_IOCON->PIO2_9 = 0xC0;
    LPC_IOCON->PIO2_10 =0xC0;
    LPC_IOCON->PIO2_2 = 0xC0;
    LPC_IOCON->PIO0_8 = 0xC0;
    LPC_IOCON->PIO0_9 = 0xC0;

    LPC_IOCON->PIO1_10 = 0xC0; // ADC pin
    LPC_IOCON->PIO2_11 = 0xC0;

    LPC_IOCON->PIO3_0 = 0xC0;
    LPC_IOCON->PIO3_1 = 0xC0;
    LPC_IOCON->PIO2_3 = 0xC0;

    LPC_IOCON->PIO1_4 = 0xC0; // ADC pin
    LPC_IOCON->PIO1_11 = 0xC0; // ADC pin
    LPC_IOCON->PIO3_2 = 0xC0;
    LPC_IOCON->PIO1_5 = 0xC0;
    LPC_IOCON->PIO1_6 = 0xC0;
    LPC_IOCON->PIO1_7 = 0xC0;
    LPC_IOCON->PIO3_3 = 0xC0;

    LPC_IOCON->R_PIO0_11 = 0xC1; // ADC pin
    LPC_IOCON->R_PIO1_0  = 0xC1; // ADC pin
    LPC_IOCON->R_PIO1_1  = 0xC1; // ADC pin
    LPC_IOCON->R_PIO1_2 = 0xC1; // ADC pin
#ifndef DEBUG
    LPC_IOCON->RESET_PIO0_0     = 0xC1; // disables reset
    LPC_IOCON->SWCLK_PIO0_10 = 0xC1; // disables SWCLK
    LPC_IOCON->SWDIO_PIO1_3 = 0xC1; // ADC pin, disables SWDIO
#endif
}

void WAKEUP_IRQHandler(void)
{
    LPC_SYSCON->MAINCLKUEN = 1;         // Restore main clock to IRC 12 MHz
    LPC_TMR16B0->EMR = 0;					// Clear match bit on timer
    LPC_SYSCON->STARTRSRP0CLR       =   BF_STARTLOGIC_P0_8; // Clear pending bit on start logic
    SCB->SCR &= ~BF_SCR_SLEEPDEEP; // Clear SLEEPDEEP bit so MCU will enter Sleep mode on __WFI();

    // Restore clocks to chip modules
    LPC_SYSCON->SYSAHBCLKCTRL = BF_SYSAHBCLKCTRL_RUN;

#ifdef DEBUG
    // We disable systick to sleep, must re-enable it (in debug mode only)
    SysTick->CTRL = 7; // enable counter, interrupts, select processor clock
#endif
}

void EnterDeepSleep(void)
{
    LPC_TMR16B0->EMR = BF_TIMER_EMR_SETOUT0; // set timer to drive P0_8 high at match

#ifndef DEBUG
    // Shut down clocks to almost everything
    LPC_SYSCON->SYSAHBCLKCTRL = BF_SYSAHBCLKCTRL_SLEEP;

    SCB->SCR |= BF_SCR_SLEEPDEEP; // Set SLEEPDEEP bit so MCU will enter DeepSleep mode on __WFI();

    // Switch main clock to low-speed WDO
    LPC_SYSCON->MAINCLKSEL = MAINCLKSEL_SEL_WDOSC;
    LPC_SYSCON->MAINCLKUEN = 0;
    LPC_SYSCON->MAINCLKUEN = 1; // toggle to enable
    LPC_SYSCON->MAINCLKUEN = 0;
#else
    // In debug mode, we are only going to sleep mode, not deep sleep
    // We must disable the SysTick interrupt because it will wake us from
    // Sleep mode
    SysTick->CTRL = 0; // enable counter, interrupts, select processor clock
#endif

    // Preload clock selection for quick switch back to IRC on wakeup
    LPC_SYSCON->MAINCLKSEL = MAINCLKSEL_SEL_IRCOSC;

    LPC_TMR16B0->TCR = BF_TIMER_TCR_RUN; // start sleep timer

    __WFI();                            // Enter deep sleep mode (sleep mode in DEBUG)
}

int runFib(int mhzA){
	//mhzA MHz setup begin
	LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
	/*
	LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
	LPC_SYSCON->MAINCLKUEN = 0x01;              //...
	for (i = 0; i != 10000; i++);               //wait for a while
	command[0] = mhzA;                            //system freq 48 MHz
	command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
	(*rom)->pPWRD->set_power(command,result);   //set system power
	if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
		while(1);                               //... stay in the loop
	}
	command[0] = 12000;                         //PLL's input freq 12000
	command[1] = 1000*mhzA;                         //CPU's freq 48000
	command[2] = CPU_FREQ_EQU;                  //specify exact frequency
	command[3] = 0;                             //infinitely wait for the PLL to lock
	(*rom)->pPWRD->set_pll(command,result);     //set the PLL
	if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
		while(1);                               //... stay in the loop
	}*/
	fibonacci(30);
	//mhzA MHz setup end
}

int initSleep(){
	LPC_SYSCON->PDRUNCFG      = BF_PDRUNCFG_RUN; // Initialize power to chip modules
    LPC_SYSCON->SYSAHBCLKCTRL = BF_SYSAHBCLKCTRL_RUN; // Initialize clocks
    InitGPIOForSleep(); // Set all GPIO as outputs driving low
    InitDeepSleep();
}

int main(void) {
	initSleep();
	*((int*)GPREG0)=0;
	while(1){
		runFib(48);
		runFib(24);
		runFib(12);
		runFib(3);
		//fibonacci(30);
		EnterDeepSleep();
		(*(int*)GPREG0)++;
		int wakeTemp=*((int*)GPREG0);
		for(i=0;i<wakeTemp;i++){
			SetBitsPort0(1<<7);
			Wait1mS(100);
			ClrBitsPort0(1<<7);
			Wait1mS(100);
		}
	}
}
