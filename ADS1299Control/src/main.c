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

#include "gpio.h"
#include "timer32.h"
#include "ssp.h"
#include "uart.h"

#include "ADS1299_commands.h"

#define PACKET_SIZE 27
#define HEADER_SIZE 0
#define MAX_BUFFER_SIZE 28

extern volatile uint32_t UARTCount;
extern volatile uint8_t UARTBuffer[BUFSIZE];

extern volatile uint32_t UARTStatus;
extern volatile uint8_t  UARTTxEmpty;

uint8_t* rec_buffer_ptr;//[PACKET_SIZE];
uint8_t* send_buffer_ptr;//[PACKET_SIZE];

uint8_t buff1[MAX_BUFFER_SIZE];
uint8_t buff2[MAX_BUFFER_SIZE];
uint8_t temp_buffer[PACKET_SIZE];
uint8_t unused_buffer[PACKET_SIZE];

uint32_t num_packets;
uint32_t max_num_packets;


void send_data_to_matlab() {
	//NVIC_DisableIRQ(EINT3_IRQn);
	/*uint8_t test[PACKET_SIZE-3];
	int j;for(j=0;j<8;j++){
		test[j*3+0] = j;
		test[j*3+1] = j;
		test[j*3+2] = j;
	}
	UARTSend( (uint8_t *)test, PACKET_SIZE-3 );*/
	// the real code:
	uint8_t* temp = send_buffer_ptr;
	send_buffer_ptr = rec_buffer_ptr;
	rec_buffer_ptr = temp;
	//UARTSend( ((uint8_t *)((send_buffer_ptr)+3*sizeof(uint8_t))), PACKET_SIZE-3 );
	UARTSend( (uint8_t *)send_buffer_ptr, (num_packets)*(PACKET_SIZE-HEADER_SIZE+1) );
	num_packets = 0;
	//NVIC_EnableIRQ(EINT3_IRQn);
}

uint32_t counter=0;
uint8_t in_progress=0;

void PIOINT3_IRQHandler(void){
	//NVIC_DisableIRQ(EINT3_IRQn);
	//int i;for(i=0;i<PACKET_SIZE-1;i++){
	//	rec_buffer_ptr[i] = (rec_buffer_ptr[i] << 1) + (rec_buffer_ptr[i+1] >> 7);
	//}
	GPIOIntClear(NDRDY_PORT,NDRDY_BIT);
	send_ads_command(ADS_RDATA);
	//clock pulse

	if(1){
		SSP_Receive( SSP_NUM, (uint8_t *)temp_buffer, PACKET_SIZE );
		num_packets++;

		if(num_packets>0){
			rec_buffer_ptr[(num_packets-1)*(PACKET_SIZE-HEADER_SIZE+1)] = 119;
			int i;for(i=HEADER_SIZE;i<PACKET_SIZE;i++){
				/*if(i<PACKET_SIZE-1){
					temp_buffer[i] = (temp_buffer[i] << 1) + (temp_buffer[i+1] >> 7);
				}else{
					temp_buffer[i] = (temp_buffer[i] << 1);
				}*/
				if(temp_buffer[i]==119 || temp_buffer[i]==121)temp_buffer[i]++;

					rec_buffer_ptr[(i-HEADER_SIZE+1) + (num_packets-1)*(PACKET_SIZE-HEADER_SIZE+1)] = temp_buffer[i];
				//rec_buffer_ptr[(i-HEADER_SIZE+1) + (num_packets-1)*(PACKET_SIZE-HEADER_SIZE+1)] = i-HEADER_SIZE;
			}
		}
	}
	counter++;
	if(num_packets>=max_num_packets){
		if(in_progress==0){
			in_progress=1;
			send_data_to_matlab();
			in_progress = 0;
		}else{
			uint8_t zeros[100];
			int u;for(u=0;u<100;u++){zeros[u]=0;}
			UARTSend( (uint8_t *)zeros, 100 );
		}
	}
	//NVIC_EnableIRQ(EINT3_IRQn);
	//send_ads_command(ADS_RDATA);
	//SSP_Receive( SSP_NUM, (uint8_t *)rec_buffer, PACKET_SIZE );
	//volatile int i=0;for(i=0;i<100000;i++);
	//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
}

int main(void) {
	rec_buffer_ptr = (uint8_t*)buff1;
	send_buffer_ptr = (uint8_t*)buff2;
	num_packets = 0;
	max_num_packets = MAX_BUFFER_SIZE/(PACKET_SIZE-HEADER_SIZE+1);

	SystemInit();

	SSP_IOConfig( SSP_NUM );	/* initialize SSP port, share pins with SPI1
									on port2(p2.0-3). */
	SSP_Init( SSP_NUM );

	GPIOInit();

	/* NVIC is installed inside UARTInit file. */
		UARTInit(UART_BAUD);
		//NVIC_SetPriority(UART_IRQn,2);

	//data ready pin
	GPIOSetDir( NDRDY_PORT, NDRDY_BIT, 0 );
	GPIOSetInterrupt( NDRDY_PORT, NDRDY_BIT, 0,	0, 0 );
	GPIOIntEnable( NDRDY_PORT, NDRDY_BIT );
	//NVIC_SetPriority(EINT3_IRQn,10);

	//reset pin
	GPIOSetDir( NRST_PORT, NRST_BIT, 1 );
	GPIOSetValue( NRST_PORT, NRST_BIT, 1 );

	GPIOSetValue( NRST_PORT, NRST_BIT, 0 );
	volatile int k=0;for(k=0;k<10000;k++);
	GPIOSetValue( NRST_PORT, NRST_BIT, 1 );
	for(k=0;k<10000;k++);
	//send_ads_command(ADS_RESET);

	send_ads_command(ADS_SDATAC);
	for(k=0;k<1000;k++);
	set_sample_rate(SAMPLE_500);
	for(k=0;k<1000;k++);
	//set_srb();
	for(k=0;k<1000;k++);
	send_ads_command(ADS_RDATAC);
	for(k=0;k<1000;k++);
	NVIC_EnableIRQ(EINT3_IRQn);
	send_ads_command(ADS_START);
	//send_ads_command(ADS_RDATA);
	//send_ads_command(ADS_RDATAC);
	//uint8_t test[1];
	//test[0] = 1;
	//UARTSend( (uint8_t *)test, 1 );


	// Enter an infinite loop, just incrementing a counter
	//uint8_t test[8];
	while(1) {
		/*volatile int j;for(j=0;j<8;j++){
			test[j] = j+119;//0;
		}
		UARTSend( (uint8_t *)test, 8 );*/
		//send_ads_command(ADS_START);
		//send_ads_command(ADS_STOP);
		//send_ads_command(ADS_RDATA);
		//send_ads_command(0xff);
		//SSP_Receive( SSP_NUM, (uint8_t *)rec_buffer, PACKET_SIZE );
		//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
		//send_ads_command(0xAA);//ADS_START);

		//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
		//volatile int l=0;for(l=0;l<100000;l++);
		//__WFI();
		volatile int i=0;for(i=0;i<1000;i++);
	}
	//return 0 ;
}
