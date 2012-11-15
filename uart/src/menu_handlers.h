#ifndef _menu_handlers_h_
#define _menu_handlers_h_

#include "menus.h"
#include "string.h"

#define LPC_GPIO0_DATA ((volatile uint16_t * const)0x50000000)
#define SetBitsPort0(bits) (*(LPC_GPIO0_DATA+(2*bits)) = bits)
#define ClrBitsPort0(bits) (*(LPC_GPIO0_DATA+(2*bits)) = 0)

extern uint32_t current_menu;
extern uint8_t report_adc;
extern uint32_t adc_report_speed;
uint32_t en_b=0;
uint32_t enable_blink = 100;
uint32_t blink_counter = 0;
uint32_t blink_duty = 50;

/*
void GPIOSetValue( uint32_t portNum, uint32_t bitPosi, uint32_t bitVal ){
  LPC_GPIO[portNum]->MASKED_ACCESS[(1<<bitPosi)] = (bitVal<<bitPosi);
}

void GPIOSetDir( uint32_t portNum, uint32_t bitPosi, uint32_t dir ){
  if(dir)
	LPC_GPIO[portNum]->DIR |= 1<<bitPosi;
  else
	LPC_GPIO[portNum]->DIR &= ~(1<<bitPosi);
}
*/
uint32_t GIPOGetValue( uint32_t portNum, uint32_t bitPosi ){
	return LPC_GPIO[portNum]->MASKED_ACCESS[(1<<bitPosi)];
}




uint32_t MastP=3;uint32_t Mast=0;
uint32_t SlavP=3;uint32_t Slav=1;
uint32_t StrtP=3;uint32_t Strt=3;
uint32_t DataP=0;uint32_t Data=6;
uint32_t KeeyP=1;uint32_t Keey=8;

uint8_t data_to_send[8];
uint8_t keyy_to_send[8];
uint8_t data_size=0;
uint8_t keyy_size=0;
void DES_menu_handler(uint8_t input){
	data_to_send[data_size] = input;
	data_size++;
	if(data_size >= 8){
		sendEnc(data_to_send,keyy_to_send);
		data_size=0;
		current_menu = 0;
		send_arm_peripheral_control_menu();
	}
}
int counter=0;
void DES_menu_handlerK(uint8_t input){
	counter++;
	keyy_to_send[keyy_size] = input;
	keyy_size++;
	if(keyy_size >= 8){
		sendEnc(data_to_send,keyy_to_send);
		keyy_size=0;
		current_menu = 0;
		send_arm_peripheral_control_menu();
	}
}

void sendBit(int data,int key){
	while(LPC_GPIO[SlavP]->MASKED_ACCESS[(1<<Slav)]!=0){}//wait for slave to set low
	volatile int delay=0;for(delay=0;delay<10;delay++);
	GPIOSetValue(DataP, Data, data);
	GPIOSetValue(KeeyP, Keey, key);
	GPIOSetValue(MastP, Mast, 1);
	GPIOSetValue(0,7,key);
	while(LPC_GPIO[SlavP]->MASKED_ACCESS[(1<<Slav)]==0){}//wait for slave to set high
	GPIOSetValue(MastP, Mast, 0);
	for(delay=0;delay<10;delay++);

	//continue.
}
void sendEnc(uint8_t* data,uint8_t* keyA){
	GPIOSetDir(MastP,Mast,1);//output
	GPIOSetDir(SlavP,Slav,0);//input
	GPIOSetDir(DataP,Data,1);//output
	GPIOSetDir(StrtP,Strt,1);//output
	GPIOSetDir(KeeyP,Keey,1);//output
	GPIOSetDir(0,7,1);//output
	GPIOSetValue(0,7, 1);
	GPIOSetValue(StrtP,Strt, 0);
	GPIOSetValue(MastP,Mast, 0);

	volatile int delay=0;for(delay=0;delay<10;delay++);

	GPIOSetValue(StrtP,Strt, 1);
	for(delay=0;delay<10;delay++);
	GPIOSetValue(MastP,Mast, 1);
	for(delay=0;delay<10;delay++);
	GPIOSetValue(MastP,Mast, 0);
	for(delay=0;delay<10;delay++);
	GPIOSetValue(StrtP,Strt, 0);
	for(delay=0;delay<10;delay++);

	//char data[8];
	//char keyA[8];
	if(counter==0){
		//data[0]=0x87;data[1]=0x87;data[2]=0x87;data[3]=0x87;data[4]=0x87;data[5]=0x87;data[6]=0x87;data[7]=0x87;
		keyA[0]=0x0E;keyA[1]=0x32;keyA[2]=0x92;keyA[3]=0x32;keyA[4]=0xEA;keyA[5]=0x6D;keyA[6]=0x0D;keyA[7]=0x73;
		counter++;
		//counter=0;
	}else{
		//data[0]=0x01;data[1]=0x23;data[2]=0x45;data[3]=0x67;data[4]=0x89;data[5]=0xAB;data[6]=0xCD;data[7]=0xEF;
		//keyA[0]=0x13;keyA[1]=0x34;keyA[2]=0x57;keyA[3]=0x79;keyA[4]=0x9B;keyA[5]=0xBC;keyA[6]=0xDF;keyA[7]=0xF1;
		//counter=0;
	}
	int i=0;int ii=0;
	for(i=0;i<8;i++){
		for(ii=0;ii<8;ii++){
			sendBit((data[i]>>(7-ii))&0x1,(keyA[i]>>(7-ii))&0x1);
		}
	}
	//GPIOSetValue(3, Strt, 0);
}

void peripheral_control_menu_handler(uint8_t input) {



	//UARTSend( &input, 1 );
	if(input == '1') { //led control
		send_LED_control_menu();
		current_menu = 1;
	}else if(input=='2'){
		send_ADC_control_menu();
		current_menu = 4;
	}else if(input=='3'){
		current_menu = 6;
	}else if(input=='4'){
		current_menu = 7;
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
	enable_blink=(5-mode)*(5-mode)*25;//*(enable_blink<0?-1:1);
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

void ADC_control_menu_handler(uint8_t input) {
	switch(input){
	case '1':
		//adc reporting on
		report_adc = 1;
		break;
	case '2':
		//adc reporting off
		report_adc = 0;
		send_ADC_control_menu();
		current_menu = 4;
		break;
	case '3':
		//set reporting freqency
		send_ADC_Reporting_Frequency_menu();
		current_menu = 5;
		break;
	case'4':
		send_arm_peripheral_control_menu();
		current_menu = 0;
		break;
	}
}

void ADC_reporting_frequency_menu_handler(uint8_t input) {
	switch(input){
	case '1':
		//slow
		adc_report_speed = 4;
		send_ADC_Reporting_Frequency_menu();
		current_menu = 5;
		break;
	case '2':
		//medium
		adc_report_speed = 3;
		send_ADC_Reporting_Frequency_menu();
		current_menu = 5;
		break;
	case '3':
		//fast
		adc_report_speed = 2;
		send_ADC_Reporting_Frequency_menu();
		current_menu = 5;
		break;
	case '4':
		//very fast
		adc_report_speed = 1;
		send_ADC_Reporting_Frequency_menu();
		current_menu = 5;
		break;
	case '5':
		//go back
		send_ADC_control_menu();
		current_menu = 4;
		break;
	}
}

#endif
