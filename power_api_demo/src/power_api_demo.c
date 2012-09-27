/*****************************************************************************
 *   blinky.c:  LED blinky C file for NXP LPC11xx Family Microprocessors
 *
 *   Copyright(C) 2008, NXP Semiconductor
 *   All rights reserved.
 *
 *   History
 *   2009.12.07  ver 1.00    Preliminary version, first Release
 *
******************************************************************************/

#include "driver_config.h"
#include "target_config.h"

#include "rom_drivers.h"

#include "wakeupdefs.h"

#define GPREG0 0x40038004

#define BF_SYSAHBCLKCTRL_SYSCLK   (1<<0)

// If other peripherals are used, they need to be added to the _RUN macro
#define BF_SYSAHBCLKCTRL_RUN       (BF_SYSAHBCLKCTRL_SLEEP  \
                                  | BF_SYSAHBCLKCTRL_GPIO   \
								  | BF_SYSAHBCLKCTRL_FLASHREG \
                                  | BF_SYSAHBCLKCTRL_ROM    \
                                  | BF_SYSAHBCLKCTRL_IOCON)

#define LPC_GPIO0_DATA ((volatile uint16_t * const)0x50000000)
#define SetBitsPort0(bits) (*(LPC_GPIO0_DATA+(2*bits)) = bits)
#define ClrBitsPort0(bits) (*(LPC_GPIO0_DATA+(2*bits)) = 0)

#define MainClockFrequency 12000000
#define WDTClockFrequency 9000 /* estimate used during debug mode */
#define SLEEPDURATION_MS 50

unsigned int command[5], result[5];             //command and result arrays
const ROM ** rom = (const ROM **) 0x1FFF1FF8;

volatile unsigned long int i;                   //counter variable

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

int fib(int n)
{
    int c;

    if (n == 1 || n == 2)
        return 1;

    c = fib(n-2) + fib(n-1);

    return c;
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

void InitSleep(){
	if((*rom)->pPWRD == (void *)0xFFFFFFFF)
	    {
	    	// This LPC does not have the power API
	    	while(1);
	    }

	    LPC_SYSCON->SYSAHBCLKCTRL = (0xFFFFFFFF & (~(1<<15))); //enable all clocks except the WDT

	    // user must select correct PLL input source before calling power/pll routines
	    LPC_SYSCON->PDRUNCFG &= ~(1<<5);            //power-up the system oscillator
	    for (i = 0; i != 24000; i++);               //wait for it to stabilize
	    LPC_SYSCON->SYSPLLCLKSEL = 0x01;            //system PLL source is the system oscillator
	    LPC_SYSCON->SYSPLLCLKUEN = 0x00;            //update the system PLL source...
	    LPC_SYSCON->SYSPLLCLKUEN = 0x01;            //...
	    LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
	    LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
	    LPC_SYSCON->MAINCLKUEN = 0x01;              //...

	    LPC_SYSCON->CLKOUTCLKSEL = 0x03;            //CLKOUT = main clock
	    LPC_SYSCON->CLKOUTUEN = 0x01;               //update CLKOUT selection...
	    LPC_SYSCON->CLKOUTUEN = 0x00;               //...
	    LPC_SYSCON->CLKOUTUEN = 0x01;               //...
	    LPC_SYSCON->CLKOUTDIV = 10;                 //generate ouptut @ 1/10 rate

	    LPC_IOCON->PIO0_1 &= ~0x07;                 //select CLKOUT @ PIO0_1...
	    LPC_IOCON->PIO0_1 |= 1;                     //...

		//configure CT16B1_MAT0 as a system/10 clock out (P0_21)
	//	LPC_IOCON->PIO0_21 = (LPC_IOCON->PIO0_21 & ~0x7) | 1;	//select CT16B1_MAT0 @ P0_21
	    LPC_SYSCON->SYSAHBCLKCTRL |= (1<<8);           	//enable CT16B1 clock
		LPC_TMR16B1->TCR	= 0x00;						//stop the timer
		LPC_TMR16B1->TCR	= 0x02;						//reset the timer
		LPC_TMR16B1->TCR	= 0x00;						//release the reset
		LPC_TMR16B1->CTCR	= 0x00;						//count on peripheral clock rising edges only
	  	LPC_TMR16B1->PR		= 0;						//max rate (no prescaler)
		LPC_TMR16B1->MR0 	= 10/2-1;					//match output = 1/10 timer's clock
	  	LPC_TMR16B1->MCR	= 1<<1;						//reset on MR0
	  	LPC_TMR16B1->EMR	= 3<<4;						//toggle MAT0
		LPC_TMR16B1->TCR	= 0x01;						//let the timer run

	    // user must select the correct operating frequency before setting up the PLL   * /
	    // or the voltage regulator and the flash interface setup might not be able     * /
	    // to support application running at higher frequencies                         * /
	    command[0] = 48;                            //system freq 48 MHz
	//    command[1] = PARAM_DEFAULT;                 //specify system power to default
	//    command[1] = PARAM_CPU_EXEC;                //specify system power for cpu performance run
	//    command[1] = PARAM_EFFICIENCY;              //specify system power for efficiency
	    command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
	    (*rom)->pPWRD->set_power(command,result);   //set system power
	    if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
	        while(1);                               //... stay in the loop
	    }

	    // * the pll setup routine is searching for a setup based on the specified input  * /
	    // * and output frequency and after setting up the main PLL switches main clock   * /
	    // * source from PLL in to PLL out                                                * /
	    command[0] = 12000;                         //PLL's input freq 12000
	    command[1] = 48000;                         //CPU's freq 48000
	    command[2] = CPU_FREQ_EQU;                  //specify exact frequency
	    command[3] = 0;                             //infinitely wait for the PLL to lock
	    (*rom)->pPWRD->set_pll(command,result);     //set the PLL
	    if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
	        while(1);                               //... stay in the loop
	    }
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

int main (void)
{
	InitSleep();
	InitDeepSleep();
	*((int *)GPREG0)=0;

	while(1){
		 //48 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 48;                            //system freq 48 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 48000;                         //CPU's freq 48000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        fib(30);
        //48 MHz setup end

        //24 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 24;                            //system freq 24 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 24000;                         //CPU's freq 24000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        fib(30);
        //24 MHz setup end

        //18 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 18;                            //system freq 18 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 18000;                         //CPU's freq 18000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        fib(30);
        //18 MHz setup end

        //3 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 3;                             //system freq 3 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 3000;                          //CPU's freq 3000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        fib(30);
        //3 MHz setup end

		EnterDeepSleep();
/*
		(*((int*)GPREG0))++;
		int wakeTemp=*((int*)GPREG0);
		for(i=0;i<wakeTemp;i++){
			SetBitsPort0(1<<7);
			Wait1mS(100);
			ClrBitsPort0(1<<7);
			Wait1mS(100);
		}
		Wait1mS(2000);*/
	}
}


/*
int main (void)
{
    if((*rom)->pPWRD == (void *)0xFFFFFFFF)
    {
    	// This LPC does not have the power API
    	while(1);
    }

    LPC_SYSCON->SYSAHBCLKCTRL = (0xFFFFFFFF & (~(1<<15))); //enable all clocks except the WDT

    // user must select correct PLL input source before calling power/pll routines
    LPC_SYSCON->PDRUNCFG &= ~(1<<5);            //power-up the system oscillator
    for (i = 0; i != 24000; i++);               //wait for it to stabilize
    LPC_SYSCON->SYSPLLCLKSEL = 0x01;            //system PLL source is the system oscillator
    LPC_SYSCON->SYSPLLCLKUEN = 0x00;            //update the system PLL source...
    LPC_SYSCON->SYSPLLCLKUEN = 0x01;            //...
    LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
    LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
    LPC_SYSCON->MAINCLKUEN = 0x01;              //...

    LPC_SYSCON->CLKOUTCLKSEL = 0x03;            //CLKOUT = main clock
    LPC_SYSCON->CLKOUTUEN = 0x01;               //update CLKOUT selection...
    LPC_SYSCON->CLKOUTUEN = 0x00;               //...
    LPC_SYSCON->CLKOUTUEN = 0x01;               //...
    LPC_SYSCON->CLKOUTDIV = 10;                 //generate ouptut @ 1/10 rate

    LPC_IOCON->PIO0_1 &= ~0x07;                 //select CLKOUT @ PIO0_1...
    LPC_IOCON->PIO0_1 |= 1;                     //...

	//configure CT16B1_MAT0 as a system/10 clock out (P0_21)
//	LPC_IOCON->PIO0_21 = (LPC_IOCON->PIO0_21 & ~0x7) | 1;	//select CT16B1_MAT0 @ P0_21
    LPC_SYSCON->SYSAHBCLKCTRL |= (1<<8);           	//enable CT16B1 clock
	LPC_TMR16B1->TCR	= 0x00;						//stop the timer
	LPC_TMR16B1->TCR	= 0x02;						//reset the timer
	LPC_TMR16B1->TCR	= 0x00;						//release the reset
	LPC_TMR16B1->CTCR	= 0x00;						//count on peripheral clock rising edges only
  	LPC_TMR16B1->PR		= 0;						//max rate (no prescaler)
	LPC_TMR16B1->MR0 	= 10/2-1;					//match output = 1/10 timer's clock
  	LPC_TMR16B1->MCR	= 1<<1;						//reset on MR0
  	LPC_TMR16B1->EMR	= 3<<4;						//toggle MAT0
	LPC_TMR16B1->TCR	= 0x01;						//let the timer run

    // user must select the correct operating frequency before setting up the PLL   * /
    // or the voltage regulator and the flash interface setup might not be able     * /
    // to support application running at higher frequencies                         * /
    command[0] = 48;                            //system freq 48 MHz
//    command[1] = PARAM_DEFAULT;                 //specify system power to default
//    command[1] = PARAM_CPU_EXEC;                //specify system power for cpu performance run
//    command[1] = PARAM_EFFICIENCY;              //specify system power for efficiency
    command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
    (*rom)->pPWRD->set_power(command,result);   //set system power
    if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
        while(1);                               //... stay in the loop
    }

    // * the pll setup routine is searching for a setup based on the specified input  * /
    // * and output frequency and after setting up the main PLL switches main clock   * /
    // * source from PLL in to PLL out                                                * /
    command[0] = 12000;                         //PLL's input freq 12000
    command[1] = 48000;                         //CPU's freq 48000
    command[2] = CPU_FREQ_EQU;                  //specify exact frequency
    command[3] = 0;                             //infinitely wait for the PLL to lock
    (*rom)->pPWRD->set_pll(command,result);     //set the PLL
    if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
        while(1);                               //... stay in the loop
    }

    // * before changing the PLL setup main clock source must be switched from        * /
    // * PLL in to PLL out!!!                                                         * /
    while(1){
        //48 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 48;                            //system freq 48 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 48000;                         //CPU's freq 48000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        for (i = 0; i != 1000000; i++);
        //48 MHz setup end

        //24 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 24;                            //system freq 24 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 24000;                         //CPU's freq 24000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        for (i = 0; i != 5000; i++);

        //24 MHz setup end

        //18 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 18;                            //system freq 18 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 18000;                         //CPU's freq 18000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        for (i = 0; i != 3750; i++);
        while(1);

        //18 MHz setup end

        //3 MHz setup begin
        LPC_SYSCON->MAINCLKSEL = 0x01;              //main clock source is the PLL input
        LPC_SYSCON->MAINCLKUEN = 0x00;              //update the main clock source...
        LPC_SYSCON->MAINCLKUEN = 0x01;              //...
        for (i = 0; i != 10000; i++);               //wait for a while
        command[0] = 3;                             //system freq 3 MHz
        command[1] = PARAM_LOW_CURRENT;             //specify system power for low active current
        (*rom)->pPWRD->set_power(command,result);   //set system power
        if (result[0] != PARAM_CMD_CUCCESS){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        command[0] = 12000;                         //PLL's input freq 12000
        command[1] = 3000;                          //CPU's freq 3000
        command[2] = CPU_FREQ_EQU;                  //specify exact frequency
        command[3] = 0;                             //infinitely wait for the PLL to lock
        (*rom)->pPWRD->set_pll(command,result);     //set the PLL
        if ((result[0] != PLL_CMD_CUCCESS)){        //if a failure is reported...
            while(1);                               //... stay in the loop
        }
        for (i = 0; i != 625; i++);

        //3 MHz setup end
    }
}

*/

