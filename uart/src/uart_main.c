/****************************************************************************
 *   $Id:: uart_main.c 4824 2010-09-07 18:47:51Z nxp21346                   $
 *   Project: NXP LPC11xx UART example
 *
 *   Description:
 *     This file contains UART test modules, main entry, to test UART APIs.
 *
 ****************************************************************************
 * Software that is described herein is for illustrative purposes only
 * which provides customers with programming information regarding the
 * products. This software is supplied "AS IS" without any warranties.
 * NXP Semiconductors assumes no responsibility or liability for the
 * use of the software, conveys no license or title under any patent,
 * copyright, or mask work right to the product. NXP Semiconductors
 * reserves the right to make changes in the software without
 * notification. NXP Semiconductors also make no representation or
 * warranty that such application will be suitable for the specified
 * use without further testing or modification.
****************************************************************************/
#include "driver_config.h"
#include "target_config.h"

#include "uart.h"
#include "timer32.h"
#include "gpio.h"
#include "adc.h"

#include "menus.h"
#include "menu_handlers.h"

#define LED_PORT 0		// Port for led
#define LED_BIT 7		// Bit on port for led

extern volatile uint32_t UARTCount;
extern volatile uint8_t UARTBuffer[BUFSIZE];

extern volatile uint32_t UARTStatus;
extern volatile uint8_t  UARTTxEmpty;

extern volatile uint32_t timer32_0_counter;
extern volatile uint32_t timer32_0_capture;

extern volatile uint32_t OverRunCounter;
volatile uint32_t ADCIntDone = 0;

uint32_t current_menu = 0;
//0 = Arm Peripheral Control Menu
//1 = LED Control Menu
//2 = LED Frequency Menu
//3 = LED Duty Cycle Menu
//4 = ADC Control Menu
//5 = ADC Reporting Frequency Menu

void menu_handler(uint8_t input){
	switch(current_menu){
		case 0:
			peripheral_control_menu_handler(input);
			break;
		case 1:
			led_control_menu_handler(input);
			break;
		case 2:
			LED_frequency_menu_handler(input);
			break;
		case 3:
			LED_duty_cycle_menu_handler(input);
			break;
	}
}

void initLED(){
	GPIOInit();
	GPIOSetDir( LED_PORT, LED_BIT, 1 );
}

void ConvertDigital ( uint32_t digital32, uint8_t* ascii_char)
{
  //uint8_t* ascii_char[8];

  ascii_char[0] = digital32 & 0xF<<0;
  ascii_char[1] = digital32 & 0xF<<4;
  ascii_char[2] = digital32 & 0xF<<8;
  ascii_char[3] = digital32 & 0xF<<12;
  ascii_char[4] = digital32 & 0xF<<16;
  ascii_char[5] = digital32 & 0xF<<20;
  ascii_char[6] = digital32 & 0xF<<24;
  ascii_char[7] = digital32 & 0xF<<28;

  int i;
  for(i=0; i<4; i++){
	  if ( (ascii_char[i] >= 0) && (ascii_char[i] <= 9) )
	  {
		  ascii_char[i] = ascii_char[i] + 0x30;	/* 0~9 */
	  }
	  else
	  {
		  ascii_char[i] = ascii_char[i] - 0x0A;
		  ascii_char[i] += 0x41;				/* A~F */
	  }
  }
  //return ( ascii_char );
}

#if CONFIG_TIMER32_DEFAULT_TIMER32_0_IRQHANDLER==0
/******************************************************************************
** Function name:		TIMER32_0_IRQHandler
**
** Descriptions:		Timer/Counter 0 interrupt handler
**						executes each 10ms @ 60 MHz CPU Clock
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void TIMER32_0_IRQHandler(void)
{
	blinkCaller();
  if ( LPC_TMR32B0->IR & 0x01 )
  {
	LPC_TMR32B0->IR = 1;				/* clear interrupt flag */
	timer32_0_counter++;
  }
  if ( LPC_TMR32B0->IR & (0x1<<4) )
  {
	LPC_TMR32B0->IR = 0x1<<4;			/* clear interrupt flag */
	timer32_0_capture++;
  }
/*
  if(timer32_0_counter%10==0){
	  char* value="Hello World!";
	  uint32_t stringLength = 12;
	  UARTSend( (uint8_t*)value, stringLength );
  }
*/
  return;
}
#endif //CONFIG_TIMER32_DEFAULT_TIMER32_0_IRQHANDLER

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
      menu_handler(UARTBuffer[UARTCount-1]);
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
    menu_handler(UARTBuffer[UARTCount-1]);
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

#if CONFIG_ADC_DEFAULT_ADC_IRQHANDLER==0
/******************************************************************************
** Function name:		ADC_IRQHandler
**
** Descriptions:		ADC interrupt handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
void ADC_IRQHandler (void)
{
  uint32_t regVal, i;

  uint8_t test[1];
  test[0] = 1;
  UARTSend(test , 1 );

  regVal = LPC_ADC->STAT;		/* Read ADC will clear the interrupt */
  if ( regVal & 0x0000FF00 )	/* check OVERRUN error first */
  {
	OverRunCounter++;
	for ( i = 0; i < ADC_NUM; i++ )
	{
	  regVal = (regVal & 0x0000FF00) >> 0x08;
	  /* if overrun, just read ADDR to clear */
	  /* regVal variable has been reused. */
	  if ( regVal & (0x1 << i) )
	  {
		regVal = LPC_ADC->DR[i];
	  }
	}
	LPC_ADC->CR &= 0xF8FFFFFF;	/* stop ADC now */
	ADCIntDone = 1;
	return;
  }

  if ( regVal & ADC_ADINT )
  {
	for ( i = 0; i < ADC_NUM; i++ )
	{
	  if ( (regVal&0xFF) & (0x1 << i) )
	  {
		ADCValue[i] = ( LPC_ADC->DR[i] >> 6 ) & 0x3FF;
		uint8_t ascii_char[8];
		ConvertDigital(ADCValue[i],ascii_char);
		UARTSend(ascii_char , 8 );
	  }
	}
#if CONFIG_ADC_ENABLE_BURST_MODE==1
	channel_flag |= (regVal & 0xFF);
	if ( (channel_flag & 0xFF) == 0xFF )
	{
	  /* All the bits in have been set, it indicates all the ADC
	  channels have been converted. */
	  LPC_ADC->CR &= 0xF8FFFFFF;	/* stop ADC now */
	  channel_flag = 0;
	  ADCIntDone = 1;
	}
#else
	LPC_ADC->CR &= 0xF8FFFFFF;	/* stop ADC now */
	ADCIntDone = 1;
#endif
  }
  return;
}
#endif


int main (void) {
	  /* Basic chip initialization is taken care of in SystemInit() called
	   * from the startup code. SystemInit() and chip settings are defined
	   * in the CMSIS system_<part family>.c file.
	   */

	//enable timer
	init_timer32(0, TIME_INTERVAL);
	enable_timer32(0);
	NVIC_EnableIRQ(TIMER_32_0_IRQn);

	initLED();

	/* NVIC is installed inside UARTInit file. */
	UARTInit(UART_BAUD);

	/* Initialize ADC  */
	ADCInit( ADC_CLK );

	#if MODEM_TEST
		ModemInit();
	#endif

		send_arm_peripheral_control_menu();
		  while(1){
			    __WFI();
		  }
}
