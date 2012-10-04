#ifndef _menu_handlers_h_
#define _menu_handlers_h_

#include "menus.h"
#include "string.h"

#define LPC_GPIO0_DATA ((volatile uint16_t * const)0x50000000)
#define SetBitsPort0(bits) (*(LPC_GPIO0_DATA+(2*bits)) = bits)
#define ClrBitsPort0(bits) (*(LPC_GPIO0_DATA+(2*bits)) = 0)

extern uint32_t current_menu;
uint32_t en_b=0;
uint32_t enable_blink = 100;
uint32_t blink_counter = 0;
uint32_t blink_duty = 50;

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

// \brief: Stop Blink
void start_blink(){
	//char* menu = new char[256];
	//sprintf(menu,"Start BC %d \n",(int)TIME_INTERVAL);
	char* menu = "Start Blink Caller\n";
	UARTSend( (uint8_t*)menu, strlen(menu) );

	en_b=1;//if(enable_blink<0){enable_blink*=-1;}
	SetBitsPort0(1<<7);
}

// \brief: Stop Blink
void stop_blink(){
	char* menu = "END Blink Caller\n";
	UARTSend( (uint8_t*)menu, strlen(menu) );
	en_b=0;//if(en_b=0){enable_blink*=-1;}
	SetBitsPort0(0<<7);
}

void blinkCaller(){
	//char* menu = "Blink Caller: 'TIME_INTERVAL'\n";UARTSend( (uint8_t*)menu, strlen(menu) );

	if(en_b==0){return;}
	//char* menu = ".";UARTSend( (uint8_t*)menu, strlen(menu) );
	blink_counter++;
	if(blink_counter%((int)((blink_duty/100.0f)*enable_blink))==0){
		//char* menu = "-";UARTSend( (uint8_t*)menu, strlen(menu) );
		ClrBitsPort0(1<<7);
	}
	if(blink_counter%enable_blink==0){
		//char* menu = "+";UARTSend( (uint8_t*)menu, strlen(menu) );
		SetBitsPort0(1<<7);
		blink_counter=0;
	}
}

void led_control_menu_handler(uint8_t input){
	switch(input){
		case '1':
			start_blink();
			send_LED_control_menu();
			break;
		case '2':
			stop_blink();
			send_LED_control_menu();
			break;
		case '3':
			send_LED_frequency_menu();
			current_menu = 2;
			break;
		case '4':
			send_LED_duty_cycle_menu();
			current_menu = 3;
			break;
		case '5':
			send_arm_peripheral_control_menu();
			current_menu = 0;
			break;
		}
}

// \brief: Set LED Frequency.
void slf(int mode){
	enable_blink=(5-mode)*100;//*(enable_blink<0?-1:1);
}

void LED_frequency_menu_handler(uint8_t input){
	switch(input){
		case '1':
			slf(1);
			send_LED_frequency_menu();
			break;
		case '2':
			slf(2);
			send_LED_frequency_menu();
			break;
		case '3':
			slf(3);
			send_LED_frequency_menu();
			break;
		case '4':
			slf(4);
			send_LED_frequency_menu();
			break;
		case '5':
			send_LED_control_menu();
			current_menu = 1;
			break;
	}
}

void lsdc(uint32_t dc){
	blink_duty=dc;
}

void LED_duty_cycle_menu_handler(uint8_t input){
	switch(input){
		case '1':
			lsdc(10);
			send_LED_duty_cycle_menu();
			break;
		case '2':
			lsdc(25);
			send_LED_duty_cycle_menu();
			break;
		case '3':
			lsdc(50);
			send_LED_duty_cycle_menu();
			break;
		case '4':
			lsdc(75);
			send_LED_duty_cycle_menu();
			break;
		case '5':
			lsdc(90);
			send_LED_duty_cycle_menu();
			break;
		case '6':
			send_LED_control_menu();
			current_menu = 1;
			break;
	}
}

#endif
