/*
 * ADS1299.c
 *
 *  Created on: Nov 8, 2012
 *      Author: Keith Robertson
 */

// COMMANDS
#define ADS_WAKEUP 	0x02 	//WAKEUP Wake-up from standby mode 0000 0010 (02h)
#define ADS_STANDBY 0x04	// Enter standby mode 0000 0100 (04h)
#define ADS_RESET 	0x06	// Reset the device 0000 0110 (06h)
#define ADS_START 	0x08	//Start and restart (synchronize) conversions 0000 1000 (08h)
#define ADS_STOP 	0x0A	//Stop conversion 0000 1010 (0Ah)
//Data Read Commands
#define ADS_RDATAC 	0x10	//Enable Read Data Continuous mode. 0001 0000 (10h) This mode is the default mode at power-up.(1)
#define ADS_SDATAC 	0x11	//Stop Read Data Continuously mode 0001 0001 (11h)
#define ADS_RDATA	0x12	// Read data by command; supports multiple read back. 0001 0010 (12h)

void send_ads_command(command) {
	uint8_t comm[1];
	comm[0] = command;
	SSP_Send( SSP_NUM, comm, 1 );
}
