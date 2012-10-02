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

#include "menus.h"

extern volatile uint32_t UARTCount;
extern volatile uint8_t UARTBuffer[BUFSIZE];

extern volatile uint32_t timer32_0_counter;
extern volatile uint32_t timer32_0_capture;

uint32_t current_menu = 0;
//0 = Arm Peripheral Control Menu
//1 = LED Control Menu
//2 = LED Frequency Menu
//3 = LED Duty Cycle Menu
//4 = ADC Control Menu
//5 = ADC Reporting Frequency Menu

void peripheral_control_menu_handler(uint8_t input) {
	if(input == 1) { //led control
		send_LED_control_menu();
		current_menu = 1;
	}else{
		send_ADC_control_menu();
		current_menu = 4;
	}
}

void led_control_menu_handler(uint8_t input){
	switch(input){
	case 1:

	}
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

  if(timer32_0_counter > 10){
	  char* value="Hello World!";
	  uint32_t stringLength = 12;
	  UARTSend( (uint8_t*)value, stringLength );
  }

  return;
}
#endif //CONFIG_TIMER32_DEFAULT_TIMER32_0_IRQHANDLER


int main (void) {
	  /* Basic chip initialization is taken care of in SystemInit() called
	   * from the startup code. SystemInit() and chip settings are defined
	   * in the CMSIS system_<part family>.c file.
	   */

	//enable timer
	init_timer32(0, TIME_INTERVAL);
	enable_timer32(0);

  /* NVIC is installed inside UARTInit file. */
  UARTInit(UART_BAUD);

#if MODEM_TEST
  ModemInit();
#endif

  while (1) 
  {				/* Loop forever */
	if ( UARTCount != 0 )
	{
	  LPC_UART->IER = IER_THRE | IER_RLS;			/* Disable RBR */
	  UARTSend( (uint8_t *)UARTBuffer, UARTCount );
	  UARTCount = 0;
	  LPC_UART->IER = IER_THRE | IER_RLS | IER_RBR;	/* Re-enable RBR */
	}
  }
}
