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
void GPIOInit() {
	LPC_GPIO2->DIR&=(0xFFFF<<1);//Set Dir
	LPC_GPIO2->IE|=(0x1<<1);	//Set Interrupt Mask
	LPC_GPIO2->IS=0;			//Set Edge Sensitive
	LPC_GPIO2->IEV=0x1;			//Rising Edge

	NVIC_EnableIRQ(EINT2_IRQn);
	NVIC_SetPriority(EINT2_IRQn,1);
	//Enable LED
	//*(*uint32_t)(LPC_AHB_BASE  + LPC_GPIO0_BASE + GPIOnDIR) = 0;//Set Dir
	LPC_GPIO0->DIR|=0x;			//Set Dir
}

/* TIMER32 and TIMER32 Interrupt Initialization */
void TIMERInit() {

    /* Your code here */

}

/* GPIO Interrupt Handler */
void PIOINT2_IRQHandler(void) {

    /* Your code here */

}

/* TIMER32 Interrupt Handler */
void TIMER32_0_IRQHandler(void) {

    /* Your code here */

}

int main(void) {

    /* Initialization code */
    GPIOInit();                   // Initialize GPIO ports for both Interrupts and LED control
    TIMERInit();                // Initialize Timer and Generate a 1ms interrupt

    /* Infinite looping */
    while(1);


    return 0;
}
