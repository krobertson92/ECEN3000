#ifndef _menu_handlers_h_
#define _menu_handlers_h_

#include "menus.h"

extern uint32_t current_menu;

void peripheral_control_menu_handler(uint8_t input) {
	//UARTSend( &input, 1 );
	if(input == '1') { //led control
		send_LED_control_menu();
		current_menu = 1;
	}else{
		send_ADC_control_menu();
		current_menu = 4;
	}
}

void set_blink(uint32_t param){

}

void led_control_menu_handler(uint8_t input){
	switch(input){
		case 1:
			set_blink(1);
			break;
		case 2:
			set_blink(0);
			break;
		case 3:
			send_LED_frequency_menu();
			current_menu = 2;
			break;
		case 4:
			send_LED_duty_cycle_menu();
			current_menu = 3;
			break;
		case 5:
			send_arm_peripheral_control_menu();
			current_menu = 0;
			break;
		}
}

void slf(uint32_t freq){

}

void LED_frequency_menu_handler(uint8_t input){
	switch(input){
		case 1:
			slf(1);
			break;
		case 2:
			slf(2);
			break;
		case 3:
			slf(3);
			break;
		case 4:
			slf(4);
			break;
		case 5:
			send_LED_control_menu();
			current_menu = 1;
			break;
	}
}

void lsdc(uint32_t dc){

}

void LED_duty_cycle_menu_handler(uint8_t input){
	switch(input){
		case 1:
			lsdc(10);
			break;
		case 2:
			lsdc(25);
			break;
		case 3:
			lsdc(50);
			break;
		case 4:
			lsdc(75);
			break;
		case 5:
			lsdc(90);
			break;
		case 6:
			send_LED_control_menu();
			current_menu = 1;
			break;
	}
}

#endif
