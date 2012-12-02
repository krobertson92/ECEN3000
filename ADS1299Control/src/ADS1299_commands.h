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

//#define ADS_

void send_ads_command(uint8_t command) {
	uint8_t comm[1];
	comm[0] = command;
	SSP_Send( SSP_NUM, comm, 1 );
}

#define SAMPLE_250 0b10010110
#define SAMPLE_500 0b10010101
#define SAMPLE_1000 0b10010100
#define SAMPLE_2000 0b10010011
#define SAMPLE_4000 0b10010010

void set_sample_rate(uint8_t reg_val){
	uint8_t first_byte[1];
	uint8_t second_byte[1];
	uint8_t set_to[1];
	first_byte[0] = 0b01000001;
	second_byte[0] = 0b00000001;
	set_to[0] = reg_val;

	SSP_Send( SSP_NUM, first_byte, 1 );
	int i;for(i=0;i<1000;i++);
	SSP_Send( SSP_NUM, second_byte, 1 );
	for(i=0;i<1000;i++);
	SSP_Send( SSP_NUM, set_to, 1 );
	for(i=0;i<1000;i++);
}
