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
void GPIOInit() {

    /* Your code here */

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
