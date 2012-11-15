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

uint8_t* rec_buffer_ptr;//[PACKET_SIZE];
uint8_t* send_buffer_ptr;//[PACKET_SIZE];

uint8_t buff1[PACKET_SIZE];
uint8_t buff2[PACKET_SIZE];


void send_data_to_matlab() {
	uint8_t test[PACKET_SIZE-3];
	int j;for(j=0;j<8;j++){
		test[j*3+0] = j;
		test[j*3+1] = j;
		test[j*3+2] = j;
	}
	UARTSend( (uint8_t *)test, PACKET_SIZE-3 );
	/* the real code:
	uint8_t* temp = send_buffer_ptr;
	send_buffer_ptr = rec_buffer_ptr;
	rec_buffer_ptr = temp;
	UARTSend( ((uint8_t *)((send_buffer_ptr)+3*sizeof(uint8_t))), PACKET_SIZE-3 );*/
}

void PIOINT3_IRQHandler(void){
	send_ads_command(ADS_RDATA);
	SSP_Receive( SSP_NUM, (uint8_t *)(rec_buffer_ptr), PACKET_SIZE );
	//send_ads_command(ADS_RDATA);
	//SSP_Receive( SSP_NUM, (uint8_t *)rec_buffer, PACKET_SIZE );
	//volatile int i=0;for(i=0;i<100000;i++);
	//UARTSend( (uint8_t *)rec_buffer, PACKET_SIZE );
}

#if CONFIG_UART_DEFAULT_UART_IRQHANDLER==0
/*****************************************************************************
** Function name:		UART_IRQHandler
**
** Descriptions:		UART interrupt handler
**
** parameters:			None
** Returned value:		None
**
*****************************************************************************/
void UART_IRQHandler(void)
{
  uint8_t IIRValue, LSRValue;
  uint8_t Dummy = Dummy;

  IIRValue = LPC_UART->IIR;

  IIRValue >>= 1;			/* skip pending bit in IIR */
  IIRValue &= 0x07;			/* check bit 1~3, interrupt identification */
  if (IIRValue == IIR_RLS)		/* Receive Line Status */
  {
    LSRValue = LPC_UART->LSR;
    /* Receive Line Status */
    if (LSRValue & (LSR_OE | LSR_PE | LSR_FE | LSR_RXFE | LSR_BI))
    {
      /* There are errors or break interrupt */
      /* Read LSR will clear the interrupt */
      UARTStatus = LSRValue;
      Dummy = LPC_UART->RBR;	/* Dummy read on RX to clear
								interrupt, then bail out */
      return;
    }
    if (LSRValue & LSR_RDR)	/* Receive Data Ready */
    {
      /* If no error on RLS, normal ready, save into the data buffer. */
      /* Note: read RBR will clear the interrupt */
      UARTBuffer[UARTCount++] = LPC_UART->RBR;
      send_data_to_matlab();
      if (UARTCount == BUFSIZE)
      {
        UARTCount = 0;		/* buffer overflow */
      }
    }
  }
  else if (IIRValue == IIR_RDA)	/* Receive Data Available */
  {
    /* Receive Data Available */
    UARTBuffer[UARTCount++] = LPC_UART->RBR;
    send_data_to_matlab();
    if (UARTCount == BUFSIZE)
    {
      UARTCount = 0;		/* buffer overflow */
    }
  }
  else if (IIRValue == IIR_CTI)	/* Character timeout indicator */
  {
    /* Character Time-out indicator */
    UARTStatus |= 0x100;		/* Bit 9 as the CTI error */
  }
  else if (IIRValue == IIR_THRE)	/* THRE, transmit holding register empty */
  {
    /* THRE interrupt */
    LSRValue = LPC_UART->LSR;		/* Check status in the LSR to see if
								valid data in U0THR or not */
    if (LSRValue & LSR_THRE)
    {
      UARTTxEmpty = 1;
    }
    else
    {
      UARTTxEmpty = 0;
    }
  }
  return;
}
#endif


int main(void) {
	rec_buffer_ptr = (uint8_t*)buff1;
	send_buffer_ptr = (uint8_t*)buff2;

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
