/*****************************************************************************
 *   config.h:  config file for blinky example for NXP LPC11xx Family
 *   Microprocessors
 *
 *   Copyright(C) 2008, NXP Semiconductor
 *   All rights reserved.
 *
 *   History
 *   2009.12.07  ver 1.00    Preliminary version, first Release
 *
******************************************************************************/

//#define ADC_DEBUG				1	// For the demo code, we run in debug mode
#define SEMIHOSTED_ADC_OUTPUT	1	// Generate printf output in the debugger
#define OUTPUT_ONLY_CH0			1	// We only output channel 0- this channel has
									// a potentiometer on it on the LPCXpresso
									// baseboard.
#define LED_PORT				0	//led port
#define LED_BIT					7	//led bit
#define LED_OFF					0	//value for led off
#define LED_ON					1	//VALUE FOR LEAD ON
#define ADC_COUNT_MAX			1023 //max adc output
#define SUPPLY_VOLTAGE			3.30 //adc supply volatage

/*********************************************************************************
**                            End Of File
*********************************************************************************/
