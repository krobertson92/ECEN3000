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

#include "timer32.h"
#include "gpio.h"

extern int fibonacci(int index, int a, int b);

int translateFib(int fibNum) {

}

void morse_pulse(uint8_t long_pulse){
	if(long_pulse == 1){
		init_timer32(0, LONG_PULSE_TIME);
	}else{
		init_timer32(0, SHORT_PULSE_TIME);
	}
	enable_timer32(0);
	GPIOSetValue( LED_PORT, LED_BIT, LED_ON );
	__WFI();
	init_timer32(0, DELAY_TIME);
	enable_timer32(0);
	GPIOSetValue( LED_PORT, LED_BIT, LED_OFF );
	__WFI();
}

int main(void) {
	GPIOInit();//setup the gpio
	GPIOSetDir( LED_PORT, LED_BIT, 1 );//setup the led pin as an output
	fibonacci(20, 0, 1);
	while(1){
		morse_pulse(1);
		morse_pulse(0);
	}
	return 0 ;
}
