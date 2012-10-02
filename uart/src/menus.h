#ifndef _menus_h_
#define _menus_h_

#include "driver_config.h"
#include "target_config.h"

#include "uart.h"

void send_arm_peripheral_control_menu() {
	char* menu = "Arm Peripheral Control Menu\r\n1.  Control LED\r\n2.  Control ADC";
	uint32_t stringLength = 61;
	UARTSend( (uint8_t*)menu, stringLength );
}

void send_LED_control_menu() {
	char* menu = "LED Control Menu\n1.  Blink ON\n2.  Blink OFF\n3.  Set Frequency\n4.  Set Duty Cycle\n5.  Go Back";
	uint32_t stringLength = 92;
	UARTSend( (uint8_t*)menu, stringLength );
}

void send_LED_frequency_menu() {
	char* menu = "LED Frequency Menu\n1.  Slow\n2.  Medium\n3.  Fast\n4.  Very Fast\n5.  Go Back";
	uint32_t stringLength = 73;
	UARTSend( (uint8_t*)menu, stringLength );
}

void send_LED_duty_cycle_menu() {
	char* menu = "LED Duty Cycle Menu\n1.  10%\n2.  25%\n3.  50%\n4.  75%\n5.  90%\n6.  Go Back";
	uint32_t stringLength = 71;
	UARTSend( (uint8_t*)menu, stringLength );
}

void send_ADC_control_menu() {
	char* menu = "ADC Control Menu\n1.  ADC Reporting ON\n2.  ADC Reporting OFF\n3.  Set Reporting Frequency\n4.  Go Back";
	uint32_t stringLength = 9;
	UARTSend( (uint8_t*)menu, stringLength );
}

void send_ADC_Reporting_Frequency_menu() {
	char* menu = "ADC Reporting Frequency Menu\n1.  Slow\2.  Medium\n3.  Fast\n4.  Very Fast\n5.  Go Back";
	uint32_t stringLength = 82;
	UARTSend( (uint8_t*)menu, stringLength );
}
#endif
