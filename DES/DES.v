module des(din,key,master,slave,start,hex0,hex1,hex2,hex3,dp0,dp1,dp2,dp3);
	input[1:1] din,key,master,start;
	output slave,dp0,dp1,dp2,dp3;
	output[6:0] hex0,hex1,hex2,hex3;
	wire[1:64] dout;
	//collect all inputs and then call the runner.
	reg[1:64] recon_din;
	reg[1:64] recon_key;
	reg[1:8] state;
	reg[1:1] slaveRegA,slaveRegB,dpreg0,dpreg1,dpreg2,dpreg3;
	assign slave=(slaveRegA^slaveRegB);
	assign dp0=dpreg0;
	assign dp1=dpreg1;
	assign dp2=dpreg2;
	assign dp3=dpreg3;
	
	initial begin
		state<=1;
		slaveRegA<=0;
		slaveRegB<=0;
		dpreg0<=0;
		dpreg1<=0;
		dpreg2<=0;
		dpreg3<=0;
	end
	
	always @(posedge master)
	begin
		if(start==1'b1)
		begin 
			state<=1;
			slaveRegA<=0;
		end else begin
			if(state<=64)
			begin
				recon_din[state]<=din;
				recon_key[state]<=key;
				state<=state+1;
				slaveRegA<=~slaveRegA;
			end
		end
	end
	
	always @(negedge master)
	begin
		if(start==1'b1)
		begin
			slaveRegB<=0;
		end else begin
			slaveRegB<=~slaveRegB;
		end
	end
	
	wire oflag;
	run_des rd(recon_din,recon_key,dout,oflag);
	
	SEG7_LUT	seg0(hex3,dout[49:52]);
	//SEG7_LUT	seg0(hex0,state[1:4]);
	
	SEG7_LUT	seg1(hex2,dout[53:56]);
	//SEG7_LUT	seg1(hex1,state[5:8]);
	
	SEG7_LUT	seg2(hex1,dout[57:60]);
	//SEG7_LUT	seg2(hex2,{3'b000,key});
	
	SEG7_LUT	seg3(hex0,dout[61:64]);
	//SEG7_LUT	seg3(hex3,{3'b000,din});
	
endmodule

module run_des(din,key,dout,oflag);
	input[1:64] din,key;
	output[1:64] dout;
	output oflag;
	wire[1:56] key_plus;
	K_plus_gen kpg(key,key_plus);
	wire[1:56] cd1;
	wire[1:56] cd2;
	wire[1:56] cd3;
	wire[1:56] cd4;
	wire[1:56] cd5;
	wire[1:56] cd6;
	wire[1:56] cd7;
	wire[1:56] cd8;
	wire[1:56] cd9;
	wire[1:56] cd10;
	wire[1:56] cd11;
	wire[1:56] cd12;
	wire[1:56] cd13;
	wire[1:56] cd14;
	wire[1:56] cd15;
	wire[1:56] cd16;
	CnDn_gen cndng(key_plus[1:28],key_plus[29:56],cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9,cd10,cd11,cd12,cd13,cd14,cd15,cd16);
	
	wire[1:48] k1;
	wire[1:48] k2;
	wire[1:48] k3;
	wire[1:48] k4;
	wire[1:48] k5;
	wire[1:48] k6;
	wire[1:48] k7;
	wire[1:48] k8;
	wire[1:48] k9;
	wire[1:48] k10;
	wire[1:48] k11;
	wire[1:48] k12;
	wire[1:48] k13;
	wire[1:48] k14;
	wire[1:48] k15;
	wire[1:48] k16;
	kn_gen kng(
	cd1,k1,
	cd2,k2,
	cd3,k3,
	cd4,k4,
	cd5,k5,
	cd6,k6,
	cd7,k7,
	cd8,k8,
	cd9,k9,
	cd10,k10,
	cd11,k11,
	cd12,k12,
	cd13,k13,
	cd14,k14,
	cd15,k15,
	cd16,k16);
	
	wire[1:64] ip;
	ip_gen ipg(din,ip);
	LnRn_gen lnrn_genA(ip[1:32],ip[33:64],k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,dout);
	
	/*Output to LEDs*/
	
		
endmodule

module K_plus_gen(key,key_plus);
	input[1:64] key;
	output[1:56] key_plus;
	assign key_plus[1] = key[57];
	assign key_plus[2] = key[49];
	assign key_plus[3] = key[41];
	assign key_plus[4] = key[33];
	assign key_plus[5] = key[25];
	assign key_plus[6] = key[17];
	assign key_plus[7] = key[9];
	assign key_plus[8] = key[1];
	
	assign key_plus[9] = key[58];
	assign key_plus[10] = key[50];
	assign key_plus[11] = key[42];
	assign key_plus[12] = key[34];
	assign key_plus[13] = key[26];
	assign key_plus[14] = key[18];
	assign key_plus[15] = key[10];
	assign key_plus[16] = key[2];
	
	assign key_plus[17] = key[59];
	assign key_plus[18] = key[51];
	assign key_plus[19] = key[43];
	assign key_plus[20] = key[35];
	assign key_plus[21] = key[27];
	assign key_plus[22] = key[19];
	assign key_plus[23] = key[11];
	assign key_plus[24] = key[3];
	
	assign key_plus[25] = key[60];
	assign key_plus[26] = key[52];
	assign key_plus[27] = key[44];
	assign key_plus[28] = key[36];
	assign key_plus[29] = key[63];
	assign key_plus[30] = key[55];
	assign key_plus[31] = key[47];
	assign key_plus[32] = key[39];
	
	assign key_plus[33] = key[31];
	assign key_plus[34] = key[23];
	assign key_plus[35] = key[15];
	assign key_plus[36] = key[7];
	assign key_plus[37] = key[62];
	assign key_plus[38] = key[54];
	assign key_plus[39] = key[46];
	assign key_plus[40] = key[38];
	
	assign key_plus[41] = key[30];
	assign key_plus[42] = key[22];
	assign key_plus[43] = key[14];
	assign key_plus[44] = key[6];
	assign key_plus[45] = key[61];
	assign key_plus[46] = key[53];
	assign key_plus[47] = key[45];
	assign key_plus[48] = key[37];
	
	assign key_plus[49] = key[29];
	assign key_plus[50] = key[21];
	assign key_plus[51] = key[13];
	assign key_plus[52] = key[5];
	assign key_plus[53] = key[28];
	assign key_plus[54] = key[20];
	assign key_plus[55] = key[12];
	assign key_plus[56] = key[4];
endmodule

module CnDn_gen(C0, D0,CD1,CD2,CD3,CD4,CD5,CD6,CD7,CD8,CD9,CD10,CD11,CD12,CD13,CD14,CD15,CD16);
	//input[55:0] cn_prev,dn_prev;
	//input num_shift;
	//output[55:0] cn,dn;
	output[55:0] CD1,CD2,CD3,CD4,CD5,CD6,CD7,CD8,CD9,CD10,CD11,CD12,CD13,CD14,CD15,CD16;
	input[28:1] C0,D0;
	/*
	reg [27:0] CVal[15:0];
	reg [27:0] DVal[15:0];
	
	genvar i;
	generate
		for (i=1; i<=16; i=i+1)
			begin: bit
				assign CVal[i][27:0] = {C0[27-i:0],C0[27:27-i+1]};
			end
	endgenerate
	*/
	wire[28:1] C1;
	wire[28:1] D1;
	assign C1={C0[27:1],C0[28]};
	assign D1={D0[27:1],D0[28]};
	assign CD1={C1,D1};
	
	wire[28:1] C2;
	wire[28:1] D2;
	assign C2={C0[26:1],C0[28:27]};
	assign D2={D0[26:1],D0[28:27]};
	assign CD2={C2,D2};
	
	wire[28:1] C3;
	wire[28:1] D3;
	assign C3={C0[24:1],C0[28:25]};
	assign D3={D0[24:1],D0[28:25]};
	assign CD3={C3,D3};
	
	wire[28:1] C4;
	wire[28:1] D4;
	assign C4={C0[22:1],C0[28:23]};
	assign D4={D0[22:1],D0[28:23]};
	assign CD4={C4,D4};
	
	wire[28:1] C5;
	wire[28:1] D5;
	assign C5={C0[20:1],C0[28:21]};
	assign D5={D0[20:1],D0[28:21]};
	assign CD5={C5,D5};
	
	wire[28:1] C6;
	wire[28:1] D6;
	assign C6={C0[18:1],C0[28:19]};
	assign D6={D0[18:1],D0[28:19]};
	assign CD6={C6,D6};
	
	wire[28:1] C7;
	wire[28:1] D7;
	assign C7={C0[16:1],C0[28:17]};
	assign D7={D0[16:1],D0[28:17]};
	assign CD7={C7,D7};
	
	wire[28:1] C8;
	wire[28:1] D8;
	assign C8={C0[14:1],C0[28:15]};
	assign D8={D0[14:1],D0[28:15]};
	assign CD8={C8,D8};
	
	wire[28:1] C9;
	wire[28:1] D9;
	assign C9={C0[13:1],C0[28:14]};
	assign D9={D0[13:1],D0[28:14]};
	assign CD9={C9,D9};
	
	wire[28:1] C10;
	wire[28:1] D10;
	assign C10={C0[11:1],C0[28:12]};
	assign D10={D0[11:1],D0[28:12]};
	assign CD10={C10,D10};
	
	wire[28:1] C11;
	wire[28:1] D11;
	assign C11={C0[9:1],C0[28:10]};
	assign D11={D0[9:1],D0[28:10]};
	assign CD11={C11,D11};
	
	wire[28:1] C12;
	wire[28:1] D12;
	assign C12={C0[7:1],C0[28:8]};
	assign D12={D0[7:1],D0[28:8]};
	assign CD12={C12,D12};
	
	wire[28:1] C13;
	wire[28:1] D13;
	assign C13={C0[5:1],C0[28:6]};
	assign D13={D0[5:1],D0[28:6]};
	assign CD13={C13,D13};
	
	wire[28:1] C14;
	wire[28:1] D14;
	assign C14={C0[3:1],C0[28:4]};
	assign D14={D0[3:1],D0[28:4]};
	assign CD14={C14,D14};
	
	wire[28:1] C15;
	wire[28:1] D15;
	assign C15={C0[1:1],C0[28:2]};
	assign D15={D0[1:1],D0[28:2]};
	assign CD15={C15,D15};
	
	wire[28:1] C16;
	wire[28:1] D16;
	assign C16=C0[28:1];
	assign D16=D0[28:1];
	assign CD16={C16,D16};
endmodule

module kn_gen(
	cd1,k1,
	cd2,k2,
	cd3,k3,
	cd4,k4,
	cd5,k5,
	cd6,k6,
	cd7,k7,
	cd8,k8,
	cd9,k9,
	cd10,k10,
	cd11,k11,
	cd12,k12,
	cd13,k13,
	cd14,k14,
	cd15,k15,
	cd16,k16);
	input[1:56] cd1,cd2,cd3,cd4,cd5,cd6,cd7,cd8,cd9,cd10,cd11,cd12,cd13,cd14,cd15,cd16;
	output[1:48] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16;
	
	/*k1 generation*/
	assign k1[ 1] = cd1[14];assign k1[ 2] = cd1[17];assign k1[ 3] = cd1[11];assign k1[ 4] = cd1[24];assign k1[ 5] = cd1[ 1];assign k1[ 6] = cd1[ 5];
	assign k1[ 7] = cd1[ 3];assign k1[ 8] = cd1[28];assign k1[ 9] = cd1[15];assign k1[10] = cd1[ 6];assign k1[11] = cd1[21];assign k1[12] = cd1[10];
	assign k1[13] = cd1[23];assign k1[14] = cd1[19];assign k1[15] = cd1[12];assign k1[16] = cd1[ 4];assign k1[17] = cd1[26];assign k1[18] = cd1[ 8];
   assign k1[19] = cd1[16];assign k1[20] = cd1[ 7];assign k1[21] = cd1[27];assign k1[22] = cd1[20];assign k1[23] = cd1[13];assign k1[24] = cd1[ 2];               
   assign k1[25] = cd1[41];assign k1[26] = cd1[52];assign k1[27] = cd1[31];assign k1[28] = cd1[37];assign k1[29] = cd1[47];assign k1[30] = cd1[55];
   assign k1[31] = cd1[30];assign k1[32] = cd1[40];assign k1[33] = cd1[51];assign k1[34] = cd1[45];assign k1[35] = cd1[33];assign k1[36] = cd1[48];
   assign k1[37] = cd1[44];assign k1[38] = cd1[49];assign k1[39] = cd1[39];assign k1[40] = cd1[56];assign k1[41] = cd1[34];assign k1[42] = cd1[53];
   assign k1[43] = cd1[46];assign k1[44] = cd1[42];assign k1[45] = cd1[50];assign k1[46] = cd1[36];assign k1[47] = cd1[29];assign k1[48] = cd1[32];
	
	/*k2 generation*/
	assign k2[ 1] = cd2[14];assign k2[ 2] = cd2[17];assign k2[ 3] = cd2[11];assign k2[ 4] = cd2[24];assign k2[ 5] = cd2[ 1];assign k2[ 6] = cd2[ 5];
	assign k2[ 7] = cd2[ 3];assign k2[ 8] = cd2[28];assign k2[ 9] = cd2[15];assign k2[10] = cd2[ 6];assign k2[11] = cd2[21];assign k2[12] = cd2[10];
	assign k2[13] = cd2[23];assign k2[14] = cd2[19];assign k2[15] = cd2[12];assign k2[16] = cd2[ 4];assign k2[17] = cd2[26];assign k2[18] = cd2[ 8];
   assign k2[19] = cd2[16];assign k2[20] = cd2[ 7];assign k2[21] = cd2[27];assign k2[22] = cd2[20];assign k2[23] = cd2[13];assign k2[24] = cd2[ 2];               
   assign k2[25] = cd2[41];assign k2[26] = cd2[52];assign k2[27] = cd2[31];assign k2[28] = cd2[37];assign k2[29] = cd2[47];assign k2[30] = cd2[55];
   assign k2[31] = cd2[30];assign k2[32] = cd2[40];assign k2[33] = cd2[51];assign k2[34] = cd2[45];assign k2[35] = cd2[33];assign k2[36] = cd2[48];
   assign k2[37] = cd2[44];assign k2[38] = cd2[49];assign k2[39] = cd2[39];assign k2[40] = cd2[56];assign k2[41] = cd2[34];assign k2[42] = cd2[53];
   assign k2[43] = cd2[46];assign k2[44] = cd2[42];assign k2[45] = cd2[50];assign k2[46] = cd2[36];assign k2[47] = cd2[29];assign k2[48] = cd2[32];
	
	/*k3 generation*/
	assign k3[ 1] = cd3[14];assign k3[ 2] = cd3[17];assign k3[ 3] = cd3[11];assign k3[ 4] = cd3[24];assign k3[ 5] = cd3[ 1];assign k3[ 6] = cd3[ 5];
	assign k3[ 7] = cd3[ 3];assign k3[ 8] = cd3[28];assign k3[ 9] = cd3[15];assign k3[10] = cd3[ 6];assign k3[11] = cd3[21];assign k3[12] = cd3[10];
	assign k3[13] = cd3[23];assign k3[14] = cd3[19];assign k3[15] = cd3[12];assign k3[16] = cd3[ 4];assign k3[17] = cd3[26];assign k3[18] = cd3[ 8];
   assign k3[19] = cd3[16];assign k3[20] = cd3[ 7];assign k3[21] = cd3[27];assign k3[22] = cd3[20];assign k3[23] = cd3[13];assign k3[24] = cd3[ 2];               
   assign k3[25] = cd3[41];assign k3[26] = cd3[52];assign k3[27] = cd3[31];assign k3[28] = cd3[37];assign k3[29] = cd3[47];assign k3[30] = cd3[55];
   assign k3[31] = cd3[30];assign k3[32] = cd3[40];assign k3[33] = cd3[51];assign k3[34] = cd3[45];assign k3[35] = cd3[33];assign k3[36] = cd3[48];
   assign k3[37] = cd3[44];assign k3[38] = cd3[49];assign k3[39] = cd3[39];assign k3[40] = cd3[56];assign k3[41] = cd3[34];assign k3[42] = cd3[53];
   assign k3[43] = cd3[46];assign k3[44] = cd3[42];assign k3[45] = cd3[50];assign k3[46] = cd3[36];assign k3[47] = cd3[29];assign k3[48] = cd3[32];
	
	/*k4 generation*/
	assign k4[ 1] = cd4[14];assign k4[ 2] = cd4[17];assign k4[ 3] = cd4[11];assign k4[ 4] = cd4[24];assign k4[ 5] = cd4[ 1];assign k4[ 6] = cd4[ 5];
	assign k4[ 7] = cd4[ 3];assign k4[ 8] = cd4[28];assign k4[ 9] = cd4[15];assign k4[10] = cd4[ 6];assign k4[11] = cd4[21];assign k4[12] = cd4[10];
	assign k4[13] = cd4[23];assign k4[14] = cd4[19];assign k4[15] = cd4[12];assign k4[16] = cd4[ 4];assign k4[17] = cd4[26];assign k4[18] = cd4[ 8];
   assign k4[19] = cd4[16];assign k4[20] = cd4[ 7];assign k4[21] = cd4[27];assign k4[22] = cd4[20];assign k4[23] = cd4[13];assign k4[24] = cd4[ 2];               
   assign k4[25] = cd4[41];assign k4[26] = cd4[52];assign k4[27] = cd4[31];assign k4[28] = cd4[37];assign k4[29] = cd4[47];assign k4[30] = cd4[55];
   assign k4[31] = cd4[30];assign k4[32] = cd4[40];assign k4[33] = cd4[51];assign k4[34] = cd4[45];assign k4[35] = cd4[33];assign k4[36] = cd4[48];
   assign k4[37] = cd4[44];assign k4[38] = cd4[49];assign k4[39] = cd4[39];assign k4[40] = cd4[56];assign k4[41] = cd4[34];assign k4[42] = cd4[53];
   assign k4[43] = cd4[46];assign k4[44] = cd4[42];assign k4[45] = cd4[50];assign k4[46] = cd4[36];assign k4[47] = cd4[29];assign k4[48] = cd4[32];
	
	/*k5 generation*/
	assign k5[ 1] = cd5[14];assign k5[ 2] = cd5[17];assign k5[ 3] = cd5[11];assign k5[ 4] = cd5[24];assign k5[ 5] = cd5[ 1];assign k5[ 6] = cd5[ 5];
	assign k5[ 7] = cd5[ 3];assign k5[ 8] = cd5[28];assign k5[ 9] = cd5[15];assign k5[10] = cd5[ 6];assign k5[11] = cd5[21];assign k5[12] = cd5[10];
	assign k5[13] = cd5[23];assign k5[14] = cd5[19];assign k5[15] = cd5[12];assign k5[16] = cd5[ 4];assign k5[17] = cd5[26];assign k5[18] = cd5[ 8];
   assign k5[19] = cd5[16];assign k5[20] = cd5[ 7];assign k5[21] = cd5[27];assign k5[22] = cd5[20];assign k5[23] = cd5[13];assign k5[24] = cd5[ 2];               
   assign k5[25] = cd5[41];assign k5[26] = cd5[52];assign k5[27] = cd5[31];assign k5[28] = cd5[37];assign k5[29] = cd5[47];assign k5[30] = cd5[55];
   assign k5[31] = cd5[30];assign k5[32] = cd5[40];assign k5[33] = cd5[51];assign k5[34] = cd5[45];assign k5[35] = cd5[33];assign k5[36] = cd5[48];
   assign k5[37] = cd5[44];assign k5[38] = cd5[49];assign k5[39] = cd5[39];assign k5[40] = cd5[56];assign k5[41] = cd5[34];assign k5[42] = cd5[53];
   assign k5[43] = cd5[46];assign k5[44] = cd5[42];assign k5[45] = cd5[50];assign k5[46] = cd5[36];assign k5[47] = cd5[29];assign k5[48] = cd5[32];
	
	/*k6 generation*/
	assign k6[ 1] = cd6[14];assign k6[ 2] = cd6[17];assign k6[ 3] = cd6[11];assign k6[ 4] = cd6[24];assign k6[ 5] = cd6[ 1];assign k6[ 6] = cd6[ 5];
	assign k6[ 7] = cd6[ 3];assign k6[ 8] = cd6[28];assign k6[ 9] = cd6[15];assign k6[10] = cd6[ 6];assign k6[11] = cd6[21];assign k6[12] = cd6[10];
	assign k6[13] = cd6[23];assign k6[14] = cd6[19];assign k6[15] = cd6[12];assign k6[16] = cd6[ 4];assign k6[17] = cd6[26];assign k6[18] = cd6[ 8];
   assign k6[19] = cd6[16];assign k6[20] = cd6[ 7];assign k6[21] = cd6[27];assign k6[22] = cd6[20];assign k6[23] = cd6[13];assign k6[24] = cd6[ 2];               
   assign k6[25] = cd6[41];assign k6[26] = cd6[52];assign k6[27] = cd6[31];assign k6[28] = cd6[37];assign k6[29] = cd6[47];assign k6[30] = cd6[55];
   assign k6[31] = cd6[30];assign k6[32] = cd6[40];assign k6[33] = cd6[51];assign k6[34] = cd6[45];assign k6[35] = cd6[33];assign k6[36] = cd6[48];
   assign k6[37] = cd6[44];assign k6[38] = cd6[49];assign k6[39] = cd6[39];assign k6[40] = cd6[56];assign k6[41] = cd6[34];assign k6[42] = cd6[53];
   assign k6[43] = cd6[46];assign k6[44] = cd6[42];assign k6[45] = cd6[50];assign k6[46] = cd6[36];assign k6[47] = cd6[29];assign k6[48] = cd6[32];
	
	/*k7 generation*/
	assign k7[ 1] = cd7[14];assign k7[ 2] = cd7[17];assign k7[ 3] = cd7[11];assign k7[ 4] = cd7[24];assign k7[ 5] = cd7[ 1];assign k7[ 6] = cd7[ 5];
	assign k7[ 7] = cd7[ 3];assign k7[ 8] = cd7[28];assign k7[ 9] = cd7[15];assign k7[10] = cd7[ 6];assign k7[11] = cd7[21];assign k7[12] = cd7[10];
	assign k7[13] = cd7[23];assign k7[14] = cd7[19];assign k7[15] = cd7[12];assign k7[16] = cd7[ 4];assign k7[17] = cd7[26];assign k7[18] = cd7[ 8];
   assign k7[19] = cd7[16];assign k7[20] = cd7[ 7];assign k7[21] = cd7[27];assign k7[22] = cd7[20];assign k7[23] = cd7[13];assign k7[24] = cd7[ 2];               
   assign k7[25] = cd7[41];assign k7[26] = cd7[52];assign k7[27] = cd7[31];assign k7[28] = cd7[37];assign k7[29] = cd7[47];assign k7[30] = cd7[55];
   assign k7[31] = cd7[30];assign k7[32] = cd7[40];assign k7[33] = cd7[51];assign k7[34] = cd7[45];assign k7[35] = cd7[33];assign k7[36] = cd7[48];
   assign k7[37] = cd7[44];assign k7[38] = cd7[49];assign k7[39] = cd7[39];assign k7[40] = cd7[56];assign k7[41] = cd7[34];assign k7[42] = cd7[53];
   assign k7[43] = cd7[46];assign k7[44] = cd7[42];assign k7[45] = cd7[50];assign k7[46] = cd7[36];assign k7[47] = cd7[29];assign k7[48] = cd7[32];
	
	/*k8 generation*/
	assign k8[ 1] = cd8[14];assign k8[ 2] = cd8[17];assign k8[ 3] = cd8[11];assign k8[ 4] = cd8[24];assign k8[ 5] = cd8[ 1];assign k8[ 6] = cd8[ 5];
	assign k8[ 7] = cd8[ 3];assign k8[ 8] = cd8[28];assign k8[ 9] = cd8[15];assign k8[10] = cd8[ 6];assign k8[11] = cd8[21];assign k8[12] = cd8[10];
	assign k8[13] = cd8[23];assign k8[14] = cd8[19];assign k8[15] = cd8[12];assign k8[16] = cd8[ 4];assign k8[17] = cd8[26];assign k8[18] = cd8[ 8];
   assign k8[19] = cd8[16];assign k8[20] = cd8[ 7];assign k8[21] = cd8[27];assign k8[22] = cd8[20];assign k8[23] = cd8[13];assign k8[24] = cd8[ 2];               
   assign k8[25] = cd8[41];assign k8[26] = cd8[52];assign k8[27] = cd8[31];assign k8[28] = cd8[37];assign k8[29] = cd8[47];assign k8[30] = cd8[55];
   assign k8[31] = cd8[30];assign k8[32] = cd8[40];assign k8[33] = cd8[51];assign k8[34] = cd8[45];assign k8[35] = cd8[33];assign k8[36] = cd8[48];
   assign k8[37] = cd8[44];assign k8[38] = cd8[49];assign k8[39] = cd8[39];assign k8[40] = cd8[56];assign k8[41] = cd8[34];assign k8[42] = cd8[53];
   assign k8[43] = cd8[46];assign k8[44] = cd8[42];assign k8[45] = cd8[50];assign k8[46] = cd8[36];assign k8[47] = cd8[29];assign k8[48] = cd8[32];
	
	/*k9 generation*/
	assign k9[ 1] = cd9[14];assign k9[ 2] = cd9[17];assign k9[ 3] = cd9[11];assign k9[ 4] = cd9[24];assign k9[ 5] = cd9[ 1];assign k9[ 6] = cd9[ 5];
	assign k9[ 7] = cd9[ 3];assign k9[ 8] = cd9[28];assign k9[ 9] = cd9[15];assign k9[10] = cd9[ 6];assign k9[11] = cd9[21];assign k9[12] = cd9[10];
	assign k9[13] = cd9[23];assign k9[14] = cd9[19];assign k9[15] = cd9[12];assign k9[16] = cd9[ 4];assign k9[17] = cd9[26];assign k9[18] = cd9[ 8];
   assign k9[19] = cd9[16];assign k9[20] = cd9[ 7];assign k9[21] = cd9[27];assign k9[22] = cd9[20];assign k9[23] = cd9[13];assign k9[24] = cd9[ 2];               
   assign k9[25] = cd9[41];assign k9[26] = cd9[52];assign k9[27] = cd9[31];assign k9[28] = cd9[37];assign k9[29] = cd9[47];assign k9[30] = cd9[55];
   assign k9[31] = cd9[30];assign k9[32] = cd9[40];assign k9[33] = cd9[51];assign k9[34] = cd9[45];assign k9[35] = cd9[33];assign k9[36] = cd9[48];
   assign k9[37] = cd9[44];assign k9[38] = cd9[49];assign k9[39] = cd9[39];assign k9[40] = cd9[56];assign k9[41] = cd9[34];assign k9[42] = cd9[53];
   assign k9[43] = cd9[46];assign k9[44] = cd9[42];assign k9[45] = cd9[50];assign k9[46] = cd9[36];assign k9[47] = cd9[29];assign k9[48] = cd9[32];
	
	/*k10 generation*/
	assign k10[ 1] = cd10[14];assign k10[ 2] = cd10[17];assign k10[ 3] = cd10[11];assign k10[ 4] = cd10[24];assign k10[ 5] = cd10[ 1];assign k10[ 6] = cd10[ 5];
	assign k10[ 7] = cd10[ 3];assign k10[ 8] = cd10[28];assign k10[ 9] = cd10[15];assign k10[10] = cd10[ 6];assign k10[11] = cd10[21];assign k10[12] = cd10[10];
	assign k10[13] = cd10[23];assign k10[14] = cd10[19];assign k10[15] = cd10[12];assign k10[16] = cd10[ 4];assign k10[17] = cd10[26];assign k10[18] = cd10[ 8];
   assign k10[19] = cd10[16];assign k10[20] = cd10[ 7];assign k10[21] = cd10[27];assign k10[22] = cd10[20];assign k10[23] = cd10[13];assign k10[24] = cd10[ 2];               
   assign k10[25] = cd10[41];assign k10[26] = cd10[52];assign k10[27] = cd10[31];assign k10[28] = cd10[37];assign k10[29] = cd10[47];assign k10[30] = cd10[55];
   assign k10[31] = cd10[30];assign k10[32] = cd10[40];assign k10[33] = cd10[51];assign k10[34] = cd10[45];assign k10[35] = cd10[33];assign k10[36] = cd10[48];
   assign k10[37] = cd10[44];assign k10[38] = cd10[49];assign k10[39] = cd10[39];assign k10[40] = cd10[56];assign k10[41] = cd10[34];assign k10[42] = cd10[53];
   assign k10[43] = cd10[46];assign k10[44] = cd10[42];assign k10[45] = cd10[50];assign k10[46] = cd10[36];assign k10[47] = cd10[29];assign k10[48] = cd10[32];
	
	/*k11 generation*/
	assign k11[ 1] = cd11[14];assign k11[ 2] = cd11[17];assign k11[ 3] = cd11[11];assign k11[ 4] = cd11[24];assign k11[ 5] = cd11[ 1];assign k11[ 6] = cd11[ 5];
	assign k11[ 7] = cd11[ 3];assign k11[ 8] = cd11[28];assign k11[ 9] = cd11[15];assign k11[10] = cd11[ 6];assign k11[11] = cd11[21];assign k11[12] = cd11[10];
	assign k11[13] = cd11[23];assign k11[14] = cd11[19];assign k11[15] = cd11[12];assign k11[16] = cd11[ 4];assign k11[17] = cd11[26];assign k11[18] = cd11[ 8];
   assign k11[19] = cd11[16];assign k11[20] = cd11[ 7];assign k11[21] = cd11[27];assign k11[22] = cd11[20];assign k11[23] = cd11[13];assign k11[24] = cd11[ 2];               
   assign k11[25] = cd11[41];assign k11[26] = cd11[52];assign k11[27] = cd11[31];assign k11[28] = cd11[37];assign k11[29] = cd11[47];assign k11[30] = cd11[55];
   assign k11[31] = cd11[30];assign k11[32] = cd11[40];assign k11[33] = cd11[51];assign k11[34] = cd11[45];assign k11[35] = cd11[33];assign k11[36] = cd11[48];
   assign k11[37] = cd11[44];assign k11[38] = cd11[49];assign k11[39] = cd11[39];assign k11[40] = cd11[56];assign k11[41] = cd11[34];assign k11[42] = cd11[53];
   assign k11[43] = cd11[46];assign k11[44] = cd11[42];assign k11[45] = cd11[50];assign k11[46] = cd11[36];assign k11[47] = cd11[29];assign k11[48] = cd11[32];
	
	/*k12 generation*/
	assign k12[ 1] = cd12[14];assign k12[ 2] = cd12[17];assign k12[ 3] = cd12[11];assign k12[ 4] = cd12[24];assign k12[ 5] = cd12[ 1];assign k12[ 6] = cd12[ 5];
	assign k12[ 7] = cd12[ 3];assign k12[ 8] = cd12[28];assign k12[ 9] = cd12[15];assign k12[10] = cd12[ 6];assign k12[11] = cd12[21];assign k12[12] = cd12[10];
	assign k12[13] = cd12[23];assign k12[14] = cd12[19];assign k12[15] = cd12[12];assign k12[16] = cd12[ 4];assign k12[17] = cd12[26];assign k12[18] = cd12[ 8];
   assign k12[19] = cd12[16];assign k12[20] = cd12[ 7];assign k12[21] = cd12[27];assign k12[22] = cd12[20];assign k12[23] = cd12[13];assign k12[24] = cd12[ 2];               
   assign k12[25] = cd12[41];assign k12[26] = cd12[52];assign k12[27] = cd12[31];assign k12[28] = cd12[37];assign k12[29] = cd12[47];assign k12[30] = cd12[55];
   assign k12[31] = cd12[30];assign k12[32] = cd12[40];assign k12[33] = cd12[51];assign k12[34] = cd12[45];assign k12[35] = cd12[33];assign k12[36] = cd12[48];
   assign k12[37] = cd12[44];assign k12[38] = cd12[49];assign k12[39] = cd12[39];assign k12[40] = cd12[56];assign k12[41] = cd12[34];assign k12[42] = cd12[53];
   assign k12[43] = cd12[46];assign k12[44] = cd12[42];assign k12[45] = cd12[50];assign k12[46] = cd12[36];assign k12[47] = cd12[29];assign k12[48] = cd12[32];
	
	/*k13 generation*/
	assign k13[ 1] = cd13[14];assign k13[ 2] = cd13[17];assign k13[ 3] = cd13[11];assign k13[ 4] = cd13[24];assign k13[ 5] = cd13[ 1];assign k13[ 6] = cd13[ 5];
	assign k13[ 7] = cd13[ 3];assign k13[ 8] = cd13[28];assign k13[ 9] = cd13[15];assign k13[10] = cd13[ 6];assign k13[11] = cd13[21];assign k13[12] = cd13[10];
	assign k13[13] = cd13[23];assign k13[14] = cd13[19];assign k13[15] = cd13[12];assign k13[16] = cd13[ 4];assign k13[17] = cd13[26];assign k13[18] = cd13[ 8];
   assign k13[19] = cd13[16];assign k13[20] = cd13[ 7];assign k13[21] = cd13[27];assign k13[22] = cd13[20];assign k13[23] = cd13[13];assign k13[24] = cd13[ 2];               
   assign k13[25] = cd13[41];assign k13[26] = cd13[52];assign k13[27] = cd13[31];assign k13[28] = cd13[37];assign k13[29] = cd13[47];assign k13[30] = cd13[55];
   assign k13[31] = cd13[30];assign k13[32] = cd13[40];assign k13[33] = cd13[51];assign k13[34] = cd13[45];assign k13[35] = cd13[33];assign k13[36] = cd13[48];
   assign k13[37] = cd13[44];assign k13[38] = cd13[49];assign k13[39] = cd13[39];assign k13[40] = cd13[56];assign k13[41] = cd13[34];assign k13[42] = cd13[53];
   assign k13[43] = cd13[46];assign k13[44] = cd13[42];assign k13[45] = cd13[50];assign k13[46] = cd13[36];assign k13[47] = cd13[29];assign k13[48] = cd13[32];
	
	/*k14 generation*/
	assign k14[ 1] = cd14[14];assign k14[ 2] = cd14[17];assign k14[ 3] = cd14[11];assign k14[ 4] = cd14[24];assign k14[ 5] = cd14[ 1];assign k14[ 6] = cd14[ 5];
	assign k14[ 7] = cd14[ 3];assign k14[ 8] = cd14[28];assign k14[ 9] = cd14[15];assign k14[10] = cd14[ 6];assign k14[11] = cd14[21];assign k14[12] = cd14[10];
	assign k14[13] = cd14[23];assign k14[14] = cd14[19];assign k14[15] = cd14[12];assign k14[16] = cd14[ 4];assign k14[17] = cd14[26];assign k14[18] = cd14[ 8];
   assign k14[19] = cd14[16];assign k14[20] = cd14[ 7];assign k14[21] = cd14[27];assign k14[22] = cd14[20];assign k14[23] = cd14[13];assign k14[24] = cd14[ 2];               
   assign k14[25] = cd14[41];assign k14[26] = cd14[52];assign k14[27] = cd14[31];assign k14[28] = cd14[37];assign k14[29] = cd14[47];assign k14[30] = cd14[55];
   assign k14[31] = cd14[30];assign k14[32] = cd14[40];assign k14[33] = cd14[51];assign k14[34] = cd14[45];assign k14[35] = cd14[33];assign k14[36] = cd14[48];
   assign k14[37] = cd14[44];assign k14[38] = cd14[49];assign k14[39] = cd14[39];assign k14[40] = cd14[56];assign k14[41] = cd14[34];assign k14[42] = cd14[53];
   assign k14[43] = cd14[46];assign k14[44] = cd14[42];assign k14[45] = cd14[50];assign k14[46] = cd14[36];assign k14[47] = cd14[29];assign k14[48] = cd14[32];
	
	/*k15 generation*/
	assign k15[ 1] = cd15[14];assign k15[ 2] = cd15[17];assign k15[ 3] = cd15[11];assign k15[ 4] = cd15[24];assign k15[ 5] = cd15[ 1];assign k15[ 6] = cd15[ 5];
	assign k15[ 7] = cd15[ 3];assign k15[ 8] = cd15[28];assign k15[ 9] = cd15[15];assign k15[10] = cd15[ 6];assign k15[11] = cd15[21];assign k15[12] = cd15[10];
	assign k15[13] = cd15[23];assign k15[14] = cd15[19];assign k15[15] = cd15[12];assign k15[16] = cd15[ 4];assign k15[17] = cd15[26];assign k15[18] = cd15[ 8];
   assign k15[19] = cd15[16];assign k15[20] = cd15[ 7];assign k15[21] = cd15[27];assign k15[22] = cd15[20];assign k15[23] = cd15[13];assign k15[24] = cd15[ 2];               
   assign k15[25] = cd15[41];assign k15[26] = cd15[52];assign k15[27] = cd15[31];assign k15[28] = cd15[37];assign k15[29] = cd15[47];assign k15[30] = cd15[55];
   assign k15[31] = cd15[30];assign k15[32] = cd15[40];assign k15[33] = cd15[51];assign k15[34] = cd15[45];assign k15[35] = cd15[33];assign k15[36] = cd15[48];
   assign k15[37] = cd15[44];assign k15[38] = cd15[49];assign k15[39] = cd15[39];assign k15[40] = cd15[56];assign k15[41] = cd15[34];assign k15[42] = cd15[53];
   assign k15[43] = cd15[46];assign k15[44] = cd15[42];assign k15[45] = cd15[50];assign k15[46] = cd15[36];assign k15[47] = cd15[29];assign k15[48] = cd15[32];
	
	/*k16 generation*/
	assign k16[ 1] = cd16[14];assign k16[ 2] = cd16[17];assign k16[ 3] = cd16[11];assign k16[ 4] = cd16[24];assign k16[ 5] = cd16[ 1];assign k16[ 6] = cd16[ 5];
	assign k16[ 7] = cd16[ 3];assign k16[ 8] = cd16[28];assign k16[ 9] = cd16[15];assign k16[10] = cd16[ 6];assign k16[11] = cd16[21];assign k16[12] = cd16[10];
	assign k16[13] = cd16[23];assign k16[14] = cd16[19];assign k16[15] = cd16[12];assign k16[16] = cd16[ 4];assign k16[17] = cd16[26];assign k16[18] = cd16[ 8];
   assign k16[19] = cd16[16];assign k16[20] = cd16[ 7];assign k16[21] = cd16[27];assign k16[22] = cd16[20];assign k16[23] = cd16[13];assign k16[24] = cd16[ 2];               
   assign k16[25] = cd16[41];assign k16[26] = cd16[52];assign k16[27] = cd16[31];assign k16[28] = cd16[37];assign k16[29] = cd16[47];assign k16[30] = cd16[55];
   assign k16[31] = cd16[30];assign k16[32] = cd16[40];assign k16[33] = cd16[51];assign k16[34] = cd16[45];assign k16[35] = cd16[33];assign k16[36] = cd16[48];
   assign k16[37] = cd16[44];assign k16[38] = cd16[49];assign k16[39] = cd16[39];assign k16[40] = cd16[56];assign k16[41] = cd16[34];assign k16[42] = cd16[53];
   assign k16[43] = cd16[46];assign k16[44] = cd16[42];assign k16[45] = cd16[50];assign k16[46] = cd16[36];assign k16[47] = cd16[29];assign k16[48] = cd16[32];
	          
endmodule

module e_gen(rn_prev, e);
	input[1:32] rn_prev;
	output[1:48] e;
	assign e[1] = rn_prev[32];assign e[2] = rn_prev[1];assign e[3] = rn_prev[2];assign e[4] = rn_prev[3];assign e[5] = rn_prev[4];assign e[6] = rn_prev[5];
	assign e[7] = rn_prev[4];assign e[8] = rn_prev[5];assign e[9] = rn_prev[6];assign e[10] = rn_prev[7];assign e[11] = rn_prev[8];assign e[12] = rn_prev[9];
	assign e[13] = rn_prev[8];assign e[14] = rn_prev[9];assign e[15] = rn_prev[10];assign e[16] = rn_prev[11];assign e[17] = rn_prev[12];assign e[18] = rn_prev[13];
	assign e[19] = rn_prev[12];assign e[20] = rn_prev[13];assign e[21] = rn_prev[14];assign e[22] = rn_prev[15];assign e[23] = rn_prev[16];assign e[24] = rn_prev[17];					
   assign e[25] = rn_prev[16];assign e[26] = rn_prev[17];assign e[27] = rn_prev[18];assign e[28] = rn_prev[19];assign e[29] = rn_prev[20];assign e[30] = rn_prev[21];               
   assign e[31] = rn_prev[20];assign e[32] = rn_prev[21];assign e[33] = rn_prev[22];assign e[34] = rn_prev[23];assign e[35] = rn_prev[24];assign e[36] = rn_prev[25];
	assign e[37] = rn_prev[24];assign e[38] = rn_prev[25];assign e[39] = rn_prev[26];assign e[40] = rn_prev[27];assign e[41] = rn_prev[28];assign e[42] = rn_prev[29];
   assign e[43] = rn_prev[28];assign e[44] = rn_prev[29];assign e[45] = rn_prev[30];assign e[46] = rn_prev[31];assign e[47] = rn_prev[32];assign e[48] = rn_prev[1];
endmodule

module ip_inv(rl,enc);
	input[1:64] rl;
	output[1:64] enc;
	assign enc[1]=rl[40];assign enc[2]=rl[8];assign enc[3]=rl[48];assign enc[4]=rl[16];assign enc[5]=rl[56];assign enc[6]=rl[24];assign enc[7]=rl[64];assign enc[8]=rl[32];
	assign enc[9]=rl[39];assign enc[10]=rl[7];assign enc[11]=rl[47];assign enc[12]=rl[15];assign enc[13]=rl[55];assign enc[14]=rl[23];assign enc[15]=rl[63];assign enc[16]=rl[31];
	assign enc[17]=rl[38];assign enc[18]=rl[6];assign enc[19]=rl[46];assign enc[20]=rl[14];assign enc[21]=rl[54];assign enc[22]=rl[22];assign enc[23]=rl[62];assign enc[24]=rl[30];
	assign enc[25]=rl[37];assign enc[26]=rl[5];assign enc[27]=rl[45];assign enc[28]=rl[13];assign enc[29]=rl[53];assign enc[30]=rl[21];assign enc[31]=rl[61];assign enc[32]=rl[29];
	assign enc[33]=rl[36];assign enc[34]=rl[4];assign enc[35]=rl[44];assign enc[36]=rl[12];assign enc[37]=rl[52];assign enc[38]=rl[20];assign enc[39]=rl[60];assign enc[40]=rl[28];
	assign enc[41]=rl[35];assign enc[42]=rl[3];assign enc[43]=rl[43];assign enc[44]=rl[11];assign enc[45]=rl[51];assign enc[46]=rl[19];assign enc[47]=rl[59];assign enc[48]=rl[27];
	assign enc[49]=rl[34];assign enc[50]=rl[2];assign enc[51]=rl[42];assign enc[52]=rl[10];assign enc[53]=rl[50];assign enc[54]=rl[18];assign enc[55]=rl[58];assign enc[56]=rl[26];
	assign enc[57]=rl[33];assign enc[58]=rl[1];assign enc[59]=rl[41];assign enc[60]=rl[9];assign enc[61]=rl[49];assign enc[62]=rl[17];assign enc[63]=rl[57];assign enc[64]=rl[25];
endmodule

module p_gen(sb,pout);
	input[1:32] sb;
	output[1:32] pout;
	assign pout[1]=sb[16];assign pout[2]=sb[7];assign pout[3]=sb[20];assign pout[4]=sb[21];
	assign pout[5]=sb[29];assign pout[6]=sb[12];assign pout[7]=sb[28];assign pout[8]=sb[17];
	assign pout[9]=sb[1];assign pout[10]=sb[15];assign pout[11]=sb[23];assign pout[12]=sb[26];
	assign pout[13]=sb[5];assign pout[14]=sb[18];assign pout[15]=sb[31];assign pout[16]=sb[10];
	assign pout[17]=sb[2];assign pout[18]=sb[8];assign pout[19]=sb[24];assign pout[20]=sb[14];
	assign pout[21]=sb[32];assign pout[22]=sb[27];assign pout[23]=sb[3];assign pout[24]=sb[9];
	assign pout[25]=sb[19];assign pout[26]=sb[13];assign pout[27]=sb[30];assign pout[28]=sb[6];
	assign pout[29]=sb[22];assign pout[30]=sb[11];assign pout[31]=sb[4];assign pout[32]=sb[25];
endmodule 


module ip_gen(din,ip);
	input[1:64] din;
	output[0:63] ip;
	assign ip[ 0]=din[58];assign ip[ 1]=din[50];assign ip[ 2]=din[42];assign ip[ 3]=din[34];assign ip[ 4]=din[26];assign ip[ 5]=din[18];assign ip[ 6]=din[10];assign ip[ 7]=din[2];
	assign ip[ 8]=din[60];assign ip[ 9]=din[52];assign ip[10]=din[44];assign ip[11]=din[36];assign ip[12]=din[28];assign ip[13]=din[20];assign ip[14]=din[12];assign ip[15]=din[4];
	assign ip[16]=din[62];assign ip[17]=din[54];assign ip[18]=din[46];assign ip[19]=din[38];assign ip[20]=din[30];assign ip[21]=din[22];assign ip[22]=din[14];assign ip[23]=din[6];
	assign ip[24]=din[64];assign ip[25]=din[56];assign ip[26]=din[48];assign ip[27]=din[40];assign ip[28]=din[32];assign ip[29]=din[24];assign ip[30]=din[16];assign ip[31]=din[8];
	assign ip[32]=din[57];assign ip[33]=din[49];assign ip[34]=din[41];assign ip[35]=din[33];assign ip[36]=din[25];assign ip[37]=din[17];assign ip[38]=din[ 9];assign ip[39]=din[1];
	assign ip[40]=din[59];assign ip[41]=din[51];assign ip[42]=din[43];assign ip[43]=din[35];assign ip[44]=din[27];assign ip[45]=din[19];assign ip[46]=din[11];assign ip[47]=din[3];
	assign ip[48]=din[61];assign ip[49]=din[53];assign ip[50]=din[45];assign ip[51]=din[37];assign ip[52]=din[29];assign ip[53]=din[21];assign ip[54]=din[13];assign ip[55]=din[5];
	assign ip[56]=din[63];assign ip[57]=din[55];assign ip[58]=din[47];assign ip[59]=din[39];assign ip[60]=din[31];assign ip[61]=din[23];assign ip[62]=din[15];assign ip[63]=din[7];
endmodule

module LnRn_gen(L0,R0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16,enc);
	output[1:64] enc;
	input[1:48] k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15,k16;
	input[1:32] L0,R0;
	wire[1:32] Lo1,Ro1;
	RL_gen rlg1(R0,L0,k1,Lo1,Ro1);
	wire[1:32] Lo2,Ro2;
	RL_gen rlg2(Ro1,Lo1,k2,Lo2,Ro2);
	wire[1:32] Lo3,Ro3;
	RL_gen rlg3(Ro2,Lo2,k3,Lo3,Ro3);
	wire[1:32] Lo4,Ro4;
	RL_gen rlg4(Ro3,Lo3,k4,Lo4,Ro4);
	wire[1:32] Lo5,Ro5;
	RL_gen rlg5(Ro4,Lo4,k5,Lo5,Ro5);
	wire[1:32] Lo6,Ro6;
	RL_gen rlg6(Ro5,Lo5,k6,Lo6,Ro6);
	wire[1:32] Lo7,Ro7;
	RL_gen rlg7(Ro6,Lo6,k7,Lo7,Ro7);
	wire[1:32] Lo8,Ro8;
	RL_gen rlg8(Ro7,Lo7,k8,Lo8,Ro8);
	wire[1:32] Lo9,Ro9;
	RL_gen rlg9(Ro8,Lo8,k9,Lo9,Ro9);
	wire[1:32] Lo10,Ro10;
	RL_gen rlg10(Ro9,Lo9,k10,Lo10,Ro10);
	wire[1:32] Lo11,Ro11;
	RL_gen rlg11(Ro10,Lo10,k11,Lo11,Ro11);
	wire[1:32] Lo12,Ro12;
	RL_gen rlg12(Ro11,Lo11,k12,Lo12,Ro12);
	wire[1:32] Lo13,Ro13;
	RL_gen rlg13(Ro12,Lo12,k13,Lo13,Ro13);
	wire[1:32] Lo14,Ro14;
	RL_gen rlg14(Ro13,Lo13,k14,Lo14,Ro14);
	wire[1:32] Lo15,Ro15;
	RL_gen rlg15(Ro14,Lo14,k15,Lo15,Ro15);
	wire[1:32] Lo16,Ro16;
	RL_gen rlg16(Ro15,Lo15,k16,Lo16,Ro16);
	
	wire[1:64] RL16={Ro16,Lo16};
	ip_inv ipinv1(RL16,enc);
	
endmodule

module RL_gen(R,L,k,Lo,Ro);
	input[1:48] k;
	input[1:32] R,L;
	output[1:32] Lo,Ro;
	assign Lo=R;
	wire[1:48] e0;
	e_gen G0(R,e0);
	wire[1:48] ke1;
	assign ke1=k^e0;
	wire[1:32] sb1;
	wire[1:4] Vo1,Vo2,Vo3,Vo4,Vo5,Vo6,Vo7,Vo8;
	S1 s1(ke1[ 1: 6],Vo1);
	S2 s2(ke1[ 7:12],Vo2);
	S3 s3(ke1[13:18],Vo3);
	S4 s4(ke1[19:24],Vo4);
	S5 s5(ke1[25:30],Vo5);
	S6 s6(ke1[31:36],Vo6);
	S7 s7(ke1[37:42],Vo7);
	S8 s8(ke1[43:48],Vo8);
	assign sb1={Vo1,Vo2,Vo3,Vo4,Vo5,Vo6,Vo7,Vo8};//{S1(ke1[1:6]),S2(ke1[7:12]),S3(ke1[13:18]),S4(ke1[19:24]),S5(ke1[25:30]),S6(ke1[31:36]),S7(ke1[37:42]),S8(ke1[43:48])};
	wire[1:32] f1;
	p_gen P1(sb1,f1);
	assign Ro=L^f1;
	
endmodule

module sBox(exorin,biout);
	input[1:48] exorin;
	output[1:48] biout;
endmodule

module S1(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?14:0)|(temp==1?4:0)|(temp==2?13:0)|(temp==3?1:0)|(temp==4?2:0)|(temp==5?15:0)|(temp==6?11:0)|(temp==7?8:0)|(temp==8?3:0)|(temp==9?10:0)|(temp==10?6:0)|(temp==11?12:0)|(temp==12?5:0)|(temp==13?9:0)|(temp==14?0:0)|(temp==15?7:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?0:0)|(temp==1?15:0)|(temp==2?7:0)|(temp==3?4:0)|(temp==4?14:0)|(temp==5?2:0)|(temp==6?13:0)|(temp==7?1:0)|(temp==8?10:0)|(temp==9?6:0)|(temp==10?12:0)|(temp==11?11:0)|(temp==12?9:0)|(temp==13?5:0)|(temp==14?3:0)|(temp==15?8:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?4:0)|(temp==1?1:0)|(temp==2?14:0)|(temp==3?8:0)|(temp==4?13:0)|(temp==5?6:0)|(temp==6?2:0)|(temp==7?11:0)|(temp==8?15:0)|(temp==9?12:0)|(temp==10?9:0)|(temp==11?7:0)|(temp==12?3:0)|(temp==13?10:0)|(temp==14?5:0)|(temp==15?0:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?15:0)|(temp==1?12:0)|(temp==2?8:0)|(temp==3?2:0)|(temp==4?4:0)|(temp==5?9:0)|(temp==6?1:0)|(temp==7?7:0)|(temp==8?5:0)|(temp==9?11:0)|(temp==10?3:0)|(temp==11?14:0)|(temp==12?10:0)|(temp==13?0:0)|(temp==14?6:0)|(temp==15?13:0)));
endmodule

module S2(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?15:0)|(temp==1?1:0)|(temp==2?8:0)|(temp==3?14:0)|(temp==4?6:0)|(temp==5?11:0)|(temp==6?3:0)|(temp==7?4:0)|(temp==8?9:0)|(temp==9?7:0)|(temp==10?2:0)|(temp==11?13:0)|(temp==12?12:0)|(temp==13?0:0)|(temp==14?5:0)|(temp==15?10:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?3:0)|(temp==1?13:0)|(temp==2?4:0)|(temp==3?7:0)|(temp==4?15:0)|(temp==5?2:0)|(temp==6?8:0)|(temp==7?14:0)|(temp==8?12:0)|(temp==9?0:0)|(temp==10?1:0)|(temp==11?10:0)|(temp==12?6:0)|(temp==13?9:0)|(temp==14?11:0)|(temp==15?5:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?0:0)|(temp==1?14:0)|(temp==2?7:0)|(temp==3?11:0)|(temp==4?10:0)|(temp==5?4:0)|(temp==6?13:0)|(temp==7?1:0)|(temp==8?5:0)|(temp==9?8:0)|(temp==10?12:0)|(temp==11?6:0)|(temp==12?9:0)|(temp==13?3:0)|(temp==14?2:0)|(temp==15?15:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?13:0)|(temp==1?8:0)|(temp==2?10:0)|(temp==3?1:0)|(temp==4?3:0)|(temp==5?15:0)|(temp==6?4:0)|(temp==7?2:0)|(temp==8?11:0)|(temp==9?6:0)|(temp==10?7:0)|(temp==11?12:0)|(temp==12?0:0)|(temp==13?5:0)|(temp==14?14:0)|(temp==15?9:0)));
endmodule

module S3(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout= 																													
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?10:0)|(temp==1?0:0)|(temp==2?9:0)|(temp==3?14:0)|(temp==4?6:0)|(temp==5?3:0)|(temp==6?15:0)|(temp==7?5:0)|(temp==8?1:0)|(temp==9?13:0)|(temp==10?12:0)|(temp==11?7:0)|(temp==12?11:0)|(temp==13?4:0)|(temp==14?2:0)|(temp==15?8:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?13:0)|(temp==1?7:0)|(temp==2?0:0)|(temp==3?9:0)|(temp==4?3:0)|(temp==5?4:0)|(temp==6?6:0)|(temp==7?10:0)|(temp==8?2:0)|(temp==9?8:0)|(temp==10?5:0)|(temp==11?14:0)|(temp==12?12:0)|(temp==13?11:0)|(temp==14?15:0)|(temp==15?1:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?13:0)|(temp==1?6:0)|(temp==2?4:0)|(temp==3?9:0)|(temp==4?8:0)|(temp==5?15:0)|(temp==6?3:0)|(temp==7?0:0)|(temp==8?11:0)|(temp==9?1:0)|(temp==10?2:0)|(temp==11?12:0)|(temp==12?5:0)|(temp==13?10:0)|(temp==14?14:0)|(temp==15?7:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?1:0)|(temp==1?10:0)|(temp==2?13:0)|(temp==3?0:0)|(temp==4?6:0)|(temp==5?9:0)|(temp==6?8:0)|(temp==7?7:0)|(temp==8?4:0)|(temp==9?15:0)|(temp==10?14:0)|(temp==11?3:0)|(temp==12?11:0)|(temp==13?5:0)|(temp==14?2:0)|(temp==15?12:0)));
endmodule

module S4(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?7:0)|(temp==1?13:0)|(temp==2?14:0)|(temp==3?3:0)|(temp==4?0:0)|(temp==5?6:0)|(temp==6?9:0)|(temp==7?10:0)|(temp==8?1:0)|(temp==9?2:0)|(temp==10?8:0)|(temp==11?5:0)|(temp==12?11:0)|(temp==13?12:0)|(temp==14?4:0)|(temp==15?15:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?13:0)|(temp==1?8:0)|(temp==2?11:0)|(temp==3?5:0)|(temp==4?6:0)|(temp==5?15:0)|(temp==6?0:0)|(temp==7?3:0)|(temp==8?4:0)|(temp==9?7:0)|(temp==10?2:0)|(temp==11?12:0)|(temp==12?1:0)|(temp==13?10:0)|(temp==14?14:0)|(temp==15?9:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?10:0)|(temp==1?6:0)|(temp==2?9:0)|(temp==3?0:0)|(temp==4?12:0)|(temp==5?11:0)|(temp==6?7:0)|(temp==7?13:0)|(temp==8?15:0)|(temp==9?1:0)|(temp==10?3:0)|(temp==11?14:0)|(temp==12?5:0)|(temp==13?2:0)|(temp==14?8:0)|(temp==15?4:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?3:0)|(temp==1?15:0)|(temp==2?0:0)|(temp==3?6:0)|(temp==4?10:0)|(temp==5?1:0)|(temp==6?13:0)|(temp==7?8:0)|(temp==8?9:0)|(temp==9?4:0)|(temp==10?5:0)|(temp==11?11:0)|(temp==12?12:0)|(temp==13?7:0)|(temp==14?2:0)|(temp==15?14:0)));
endmodule

module S5(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?2:0)|(temp==1?12:0)|(temp==2?4:0)|(temp==3?1:0)|(temp==4?7:0)|(temp==5?10:0)|(temp==6?11:0)|(temp==7?6:0)|(temp==8?8:0)|(temp==9?5:0)|(temp==10?3:0)|(temp==11?15:0)|(temp==12?13:0)|(temp==13?0:0)|(temp==14?14:0)|(temp==15?9:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?14:0)|(temp==1?11:0)|(temp==2?2:0)|(temp==3?12:0)|(temp==4?4:0)|(temp==5?7:0)|(temp==6?13:0)|(temp==7?1:0)|(temp==8?5:0)|(temp==9?0:0)|(temp==10?15:0)|(temp==11?10:0)|(temp==12?3:0)|(temp==13?9:0)|(temp==14?8:0)|(temp==15?6:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?4:0)|(temp==1?2:0)|(temp==2?1:0)|(temp==3?11:0)|(temp==4?10:0)|(temp==5?13:0)|(temp==6?7:0)|(temp==7?8:0)|(temp==8?15:0)|(temp==9?9:0)|(temp==10?12:0)|(temp==11?5:0)|(temp==12?6:0)|(temp==13?3:0)|(temp==14?0:0)|(temp==15?14:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?11:0)|(temp==1?8:0)|(temp==2?12:0)|(temp==3?7:0)|(temp==4?1:0)|(temp==5?14:0)|(temp==6?2:0)|(temp==7?13:0)|(temp==8?6:0)|(temp==9?15:0)|(temp==10?0:0)|(temp==11?9:0)|(temp==12?10:0)|(temp==13?4:0)|(temp==14?5:0)|(temp==15?3:0)));
endmodule

module S6(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?12:0)|(temp==1?1:0)|(temp==2?10:0)|(temp==3?15:0)|(temp==4?9:0)|(temp==5?2:0)|(temp==6?6:0)|(temp==7?8:0)|(temp==8?0:0)|(temp==9?13:0)|(temp==10?3:0)|(temp==11?4:0)|(temp==12?14:0)|(temp==13?7:0)|(temp==14?5:0)|(temp==15?11:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?10:0)|(temp==1?15:0)|(temp==2?4:0)|(temp==3?2:0)|(temp==4?7:0)|(temp==5?12:0)|(temp==6?9:0)|(temp==7?5:0)|(temp==8?6:0)|(temp==9?1:0)|(temp==10?13:0)|(temp==11?14:0)|(temp==12?0:0)|(temp==13?11:0)|(temp==14?3:0)|(temp==15?8:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?9:0)|(temp==1?14:0)|(temp==2?15:0)|(temp==3?5:0)|(temp==4?2:0)|(temp==5?8:0)|(temp==6?12:0)|(temp==7?3:0)|(temp==8?7:0)|(temp==9?0:0)|(temp==10?4:0)|(temp==11?10:0)|(temp==12?1:0)|(temp==13?13:0)|(temp==14?11:0)|(temp==15?6:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?4:0)|(temp==1?3:0)|(temp==2?2:0)|(temp==3?12:0)|(temp==4?9:0)|(temp==5?5:0)|(temp==6?15:0)|(temp==7?10:0)|(temp==8?11:0)|(temp==9?14:0)|(temp==10?1:0)|(temp==11?7:0)|(temp==12?6:0)|(temp==13?0:0)|(temp==14?8:0)|(temp==15?13:0)));
endmodule

module S7(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?4:0)|(temp==1?11:0)|(temp==2?2:0)|(temp==3?14:0)|(temp==4?15:0)|(temp==5?0:0)|(temp==6?8:0)|(temp==7?13:0)|(temp==8?3:0)|(temp==9?12:0)|(temp==10?9:0)|(temp==11?7:0)|(temp==12?5:0)|(temp==13?10:0)|(temp==14?6:0)|(temp==15?1:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?13:0)|(temp==1?0:0)|(temp==2?11:0)|(temp==3?7:0)|(temp==4?4:0)|(temp==5?9:0)|(temp==6?1:0)|(temp==7?10:0)|(temp==8?14:0)|(temp==9?3:0)|(temp==10?5:0)|(temp==11?12:0)|(temp==12?2:0)|(temp==13?15:0)|(temp==14?8:0)|(temp==15?6:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?1:0)|(temp==1?4:0)|(temp==2?11:0)|(temp==3?13:0)|(temp==4?12:0)|(temp==5?3:0)|(temp==6?7:0)|(temp==7?14:0)|(temp==8?10:0)|(temp==9?15:0)|(temp==10?6:0)|(temp==11?8:0)|(temp==12?0:0)|(temp==13?5:0)|(temp==14?9:0)|(temp==15?2:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?6:0)|(temp==1?11:0)|(temp==2?13:0)|(temp==3?8:0)|(temp==4?1:0)|(temp==5?4:0)|(temp==6?10:0)|(temp==7?7:0)|(temp==8?9:0)|(temp==9?5:0)|(temp==10?0:0)|(temp==11?15:0)|(temp==12?14:0)|(temp==13?2:0)|(temp==14?3:0)|(temp==15?12:0)));
endmodule

module S8(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:4] temp;
assign temp=bin[2:5];
assign vout=																														
	(((bin[1]==0&&bin[6]==0)?4'b1111:0)&((temp==0?13:0)|(temp==1?2:0)|(temp==2?8:0)|(temp==3?4:0)|(temp==4?6:0)|(temp==5?15:0)|(temp==6?11:0)|(temp==7?1:0)|(temp==8?10:0)|(temp==9?9:0)|(temp==10?3:0)|(temp==11?14:0)|(temp==12?5:0)|(temp==13?0:0)|(temp==14?12:0)|(temp==15?7:0)))|
	(((bin[1]==0&&bin[6]==1)?4'b1111:0)&((temp==0?1:0)|(temp==1?15:0)|(temp==2?13:0)|(temp==3?8:0)|(temp==4?10:0)|(temp==5?3:0)|(temp==6?7:0)|(temp==7?4:0)|(temp==8?12:0)|(temp==9?5:0)|(temp==10?6:0)|(temp==11?11:0)|(temp==12?0:0)|(temp==13?14:0)|(temp==14?9:0)|(temp==15?2:0)))|
	(((bin[1]==1&&bin[6]==0)?4'b1111:0)&((temp==0?7:0)|(temp==1?11:0)|(temp==2?4:0)|(temp==3?1:0)|(temp==4?9:0)|(temp==5?12:0)|(temp==6?14:0)|(temp==7?2:0)|(temp==8?0:0)|(temp==9?6:0)|(temp==10?10:0)|(temp==11?13:0)|(temp==12?15:0)|(temp==13?3:0)|(temp==14?5:0)|(temp==15?8:0)))|
	(((bin[1]==1&&bin[6]==1)?4'b1111:0)&((temp==0?2:0)|(temp==1?1:0)|(temp==2?14:0)|(temp==3?7:0)|(temp==4?4:0)|(temp==5?10:0)|(temp==6?8:0)|(temp==7?13:0)|(temp==8?15:0)|(temp==9?12:0)|(temp==10?9:0)|(temp==11?0:0)|(temp==12?3:0)|(temp==13?5:0)|(temp==14?6:0)|(temp==15?11:0)));
endmodule

module SEG7_LUT	(	oSEG,iDIG	);
input		[3:0]	iDIG;
output	[6:0]	oSEG;
reg		[6:0]	oSEG;

always @(iDIG)
begin
		case(iDIG)
		4'h1: oSEG = 7'b1111001;	// ---t----
		4'h2: oSEG = 7'b0100100; 	// |	  |
		4'h3: oSEG = 7'b0110000; 	// lt	 rt
		4'h4: oSEG = 7'b0011001; 	// |	  |
		4'h5: oSEG = 7'b0010010; 	// ---m----
		4'h6: oSEG = 7'b0000010; 	// |	  |
		4'h7: oSEG = 7'b1111000; 	// lb	 rb
		4'h8: oSEG = 7'b0000000; 	// |	  |
		4'h9: oSEG = 7'b0011000; 	// ---b----
		4'ha: oSEG = 7'b0001000;
		4'hb: oSEG = 7'b0000011;
		4'hc: oSEG = 7'b1000110;
		4'hd: oSEG = 7'b0100001;
		4'he: oSEG = 7'b0000110;
		4'hf: oSEG = 7'b0001110;
		4'h0: oSEG = 7'b1000000;
		endcase
end
endmodule
