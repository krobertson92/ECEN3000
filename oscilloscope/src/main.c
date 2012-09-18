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

// TODO: insert other include files here

// TODO: insert other definitions and declarations here

/* GPIO and GPIO Interrupt Initialization */
//see page 184
//http://www.nxp.com/documents/user_manual/UM10398.pdf

uint8_t is_high;

void GPIOInit() {
	//set up clock
	LPC_SYSCON->SYSAHBCLKCTRL |= (1<<6);

	//input gpio
	LPC_GPIO2->DIR &= ~(1<<1);	//Set Dir to input (0)
	LPC_GPIO2->IE |= (1<<1);	//Set Interrupt Mask
	LPC_GPIO2->IS &= ~(1<<1);	//Set Edge Sensitive
	LPC_GPIO2->IBE |= (1<<1);	//both edges

	NVIC_EnableIRQ(EINT2_IRQn);		//enable port 2 interrupt
	NVIC_SetPriority(EINT2_IRQn,1);	//set port 2 interrupt priority to 1

	//Enable LED
	LPC_GPIO0->DIR |= (1<<7);	//Set Dir
	LPC_GPIO0->MASKED_ACCESS[(1<<7)] = (0<<7); //turn off led
}

/* TIMER32 and TIMER32 Interrupt Initialization */
void TIMERInit() {
	//set up the clock
    LPC_SYSCON->SYSAHBCLKCTRL |= (1<<9);

    //set up 32 bit timer0
    LPC_IOCON->PIO1_5 &= ~0x07;		//disable all functions on PIO1_5 (timer)
    LPC_IOCON->PIO1_5 |= 0x02; 		//Selects function CT32B0_CAP0.
    LPC_IOCON->PIO1_5 &= ~0x07;		//disable all functions on PIO1_6 (timer)
    LPC_IOCON->PIO1_5 |= 0x02; 		//Selects function CT32B0_MAT0.
    LPC_IOCON->PIO1_7 &= ~0x07;		//disable all functions on PIO1_6 (timer)
    LPC_IOCON->PIO1_7 |= 0x02;		//selects function CT32B0_MAT1
    LPC_IOCON->PIO0_1 &= ~0x07;		//disable all functions on PIO1_6 (timer)
    LPC_IOCON->PIO0_1 |= 0x02;		//selects function CT32B0_MAT2

    LPC_TMR32B0->IR |= (1<<0);		//setup interrupt for timer0
    LPC_TMR32B0->TCR |= (1<<0); 	//enable counting for timer0
    LPC_TMR32B0->MCR |= (0b11<<0);		//enable interrupt when counter reaches mr0
    LPC_TMR32B0->MR0 = 15000; 		//interrupt when counter reaches 15000 (1ms)
    LPC_TMR32B0->CCR |= (0b101<<0);

    //enable interrupts
    NVIC_EnableIRQ(TIMER_32_0_IRQn);	//enable timer32_0 interupt
    NVIC_SetPriority(TIMER_32_0_IRQn,1);//set timer32_0 interrupt priority to 1
}

uint8_t newInt;
/* GPIO Interrupt Handler */
void PIOINT2_IRQHandler(void) {
	LPC_GPIO2->IE &= ~(1<<1);	//Set Interrupt Mask
	LPC_GPIO2->IC |= (1<<1); //clear interrupt
		__asm("nop");
		__asm("nop");

	//if(LPC_GPIO2->MASKED_ACCESS[(1<<1)])
	//	is_high=1;
	//else
	//	is_high=0;
	newInt++;
	LPC_GPIO2->IE |= (1<<1);	//Set Interrupt Mask
}

/* TIMER32 Interrupt Handler */
uint8_t intCounterA;
uint8_t intCounterB;
void TIMER32_0_IRQHandler(void) {
	if(newInt>0){is_high=!is_high;}
	intCounterA+=newInt;
	intCounterB++;
	if(intCounterB>=100){debug_printf(">> %f",intCounterA/(1000*100.0));intCounterA=0;intCounterB=0;}
	newInt=0;
	if(is_high)
		LPC_GPIO0->MASKED_ACCESS[(1<<7)] = (1<<7); //turn off led
	else
		LPC_GPIO0->MASKED_ACCESS[(1<<7)] = (0<<7); //turn on led
	LPC_TMR32B0->IR |= (1<<0);
}

int main(void) {
	//debug_printf();
	is_high = 0;

    /* Initialization code */
    GPIOInit();                   // Initialize GPIO ports for both Interrupts and LED control
    TIMERInit();                // Initialize Timer and Generate a 1ms interrupt

    /* Infinite looping */
    while(1);


    return 0;
}
