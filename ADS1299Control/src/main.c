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

#define PACKET_SIZE 215

uint8_t rec_buffer[PACKET_SIZE];


void PIOINT3_IRQHandler(void){
	send_ads_command(ADS_RDATA);
	SSP_Receive( SSP_NUM, (uint8_t *)rec_buffer, PACKET_SIZE );
	volatile int i=0;for(i=0;i<10000;i++);
	UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );

	//send_ads_command(ADS_RDATA);
	//SSP_Receive( SSP_NUM, (uint8_t *)rec_buffer, PACKET_SIZE );
	//volatile int i=0;for(i=0;i<100000;i++);
	//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
}


int main(void) {

	SystemInit();

	SSP_IOConfig( SSP_NUM );	/* initialize SSP port, share pins with SPI1
									on port2(p2.0-3). */
	SSP_Init( SSP_NUM );

	GPIOInit();

	/* NVIC is installed inside UARTInit file. */
		UARTInit(UART_BAUD);

	//data ready pin
	GPIOSetDir( NDRDY_PORT, NDRDY_BIT, 0 );
	GPIOSetInterrupt( NDRDY_PORT, NDRDY_BIT, 0,	0, 0 );
	GPIOIntEnable( NDRDY_PORT, NDRDY_BIT );
	NVIC_EnableIRQ(EINT3_IRQn);

	//reset pin
	GPIOSetDir( NRST_PORT, NRST_BIT, 1 );
	GPIOSetValue( NRST_PORT, NRST_BIT, 1 );

	GPIOSetValue( NRST_PORT, NRST_BIT, 0 );
	volatile int k=0;for(k=0;k<10000;k++);
	GPIOSetValue( NRST_PORT, NRST_BIT, 1 );
	//send_ads_command(ADS_RDATAC);
	send_ads_command(ADS_RESET);
	send_ads_command(ADS_SDATAC);
	send_ads_command(ADS_START);
	//send_ads_command(ADS_RDATAC);
	//uint8_t test[1];
	//test[0] = 1;
	//UARTSend( (uint8_t *)test, 1 );


	// Enter an infinite loop, just incrementing a counter
	while(1) {
		//send_ads_command(ADS_START);
		//send_ads_command(ADS_STOP);
		//send_ads_command(ADS_RDATA);
		//send_ads_command(0xff);
		//SSP_Receive( SSP_NUM, (uint8_t *)rec_buffer, PACKET_SIZE );
		//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
		//send_ads_command(0xAA);//ADS_START);
		volatile int i=0;for(i=0;i<100000;i++);
		//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
		//volatile int l=0;for(l=0;l<100000;l++);
		//__WFI();
	}
	return 0 ;
}
