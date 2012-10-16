module des(clk,reset,mode,din,key,dout,oflag);
	input clk,reset,mode;
	input[63:0] din,key;
	output[63:0] dout;
	output oflag;
	wire[55:0] key_plus;
	K_plus_gen kasdf(key,key_plus);
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

module CnDn_gen(cn_prev, dn_prev, cn, dn, num_shift);
	input[55:0] cn_prev,dn_prev;
	input num_shift;
	output[55:0] cn,dn;
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
	assign k1[1] = cd1[14];assign k1[2] = cd1[17];assign k1[3] = cd1[11];assign k1[4] = cd1[24];assign k1[5] = cd1[1];assign k1[6] = cd1[5];
	assign k1[7] = cd1[3];assign k1[8] = cd1[28];assign k1[9] = cd1[15];assign k1[10] = cd1[6];assign k1[11] = cd1[21];assign k1[12] = cd1[10];
	assign k1[13] = cd1[23];assign k1[14] = cd1[17];assign k1[15] = cd1[11];assign k1[16] = cd1[4];assign k1[17] = cd1[26];assign k1[18] = cd1[8];
   assign k1[19] = cd1[16];assign k1[20] = cd1[7];assign k1[21] = cd1[27];assign k1[22] = cd1[20];assign k1[23] = cd1[13];assign k1[24] = cd1[2];               
   assign k1[25] = cd1[41];assign k1[26] = cd1[52];assign k1[27] = cd1[31];assign k1[28] = cd1[37];assign k1[29] = cd1[47];assign k1[30] = cd1[55];
   assign k1[31] = cd1[30];assign k1[32] = cd1[40];assign k1[33] = cd1[51];assign k1[34] = cd1[45];assign k1[35] = cd1[33];assign k1[36] = cd1[48];
   assign k1[37] = cd1[44];assign k1[38] = cd1[49];assign k1[39] = cd1[39];assign k1[40] = cd1[56];assign k1[41] = cd1[34];assign k1[42] = cd1[53];
   assign k1[43] = cd1[46];assign k1[44] = cd1[42];assign k1[45] = cd1[50];assign k1[46] = cd1[36];assign k1[47] = cd1[29];assign k1[48] = cd1[32];
	
	/*k2 generation*/
	assign k2[1] = cd2[14];assign k2[2] = cd2[17];assign k2[3] = cd2[11];assign k2[4] = cd2[24];assign k2[5] = cd2[1];assign k2[6] = cd2[5];
	assign k2[7] = cd2[3];assign k2[8] = cd2[28];assign k2[9] = cd2[15];assign k2[10] = cd2[6];assign k2[11] = cd2[21];assign k2[12] = cd2[10];
	assign k2[13] = cd2[23];assign k2[14] = cd2[17];assign k2[15] = cd2[11];assign k2[16] = cd2[4];assign k2[17] = cd2[26];assign k2[18] = cd2[8];
   assign k2[19] = cd2[16];assign k2[20] = cd2[7];assign k2[21] = cd2[27];assign k2[22] = cd2[20];assign k2[23] = cd2[13];assign k2[24] = cd2[2];               
   assign k2[25] = cd2[41];assign k2[26] = cd2[52];assign k2[27] = cd2[31];assign k2[28] = cd2[37];assign k2[29] = cd2[47];assign k2[30] = cd2[55];
   assign k2[31] = cd2[30];assign k2[32] = cd2[40];assign k2[33] = cd2[51];assign k2[34] = cd2[45];assign k2[35] = cd2[33];assign k2[36] = cd2[48];
   assign k2[37] = cd2[44];assign k2[38] = cd2[49];assign k2[39] = cd2[39];assign k2[40] = cd2[56];assign k2[41] = cd2[34];assign k2[42] = cd2[53];
   assign k2[43] = cd2[46];assign k2[44] = cd2[42];assign k2[45] = cd2[50];assign k2[46] = cd2[36];assign k2[47] = cd2[29];assign k2[48] = cd2[32];
	
	/*k3 generation*/
	assign k3[1] = cd3[14];assign k3[2] = cd3[17];assign k3[3] = cd3[11];assign k3[4] = cd3[24];assign k3[5] = cd3[1];assign k3[6] = cd3[5];
	assign k3[7] = cd3[3];assign k3[8] = cd3[28];assign k3[9] = cd3[15];assign k3[10] = cd3[6];assign k3[11] = cd3[21];assign k3[12] = cd3[10];
	assign k3[13] = cd3[23];assign k3[14] = cd3[17];assign k3[15] = cd3[11];assign k3[16] = cd3[4];assign k3[17] = cd3[26];assign k3[18] = cd3[8];
   assign k3[19] = cd3[16];assign k3[20] = cd3[7];assign k3[21] = cd3[27];assign k3[22] = cd3[20];assign k3[23] = cd3[13];assign k3[24] = cd3[2];               
   assign k3[25] = cd3[41];assign k3[26] = cd3[52];assign k3[27] = cd3[31];assign k3[28] = cd3[37];assign k3[29] = cd3[47];assign k3[30] = cd3[55];
   assign k3[31] = cd3[30];assign k3[32] = cd3[40];assign k3[33] = cd3[51];assign k3[34] = cd3[45];assign k3[35] = cd3[33];assign k3[36] = cd3[48];
   assign k3[37] = cd3[44];assign k3[38] = cd3[49];assign k3[39] = cd3[39];assign k3[40] = cd3[56];assign k3[41] = cd3[34];assign k3[42] = cd3[53];
   assign k3[43] = cd3[46];assign k3[44] = cd3[42];assign k3[45] = cd3[50];assign k3[46] = cd3[36];assign k3[47] = cd3[29];assign k3[48] = cd3[32];
	
	/*k4 generation*/
	assign k4[1] = cd4[14];assign k4[2] = cd4[17];assign k4[3] = cd4[11];assign k4[4] = cd4[24];assign k4[5] = cd4[1];assign k4[6] = cd4[5];
	assign k4[7] = cd4[3];assign k4[8] = cd4[28];assign k4[9] = cd4[15];assign k4[10] = cd4[6];assign k4[11] = cd4[21];assign k4[12] = cd4[10];
	assign k4[13] = cd4[23];assign k4[14] = cd4[17];assign k4[15] = cd4[11];assign k4[16] = cd4[4];assign k4[17] = cd4[26];assign k4[18] = cd4[8];
   assign k4[19] = cd4[16];assign k4[20] = cd4[7];assign k4[21] = cd4[27];assign k4[22] = cd4[20];assign k4[23] = cd4[13];assign k4[24] = cd4[2];               
   assign k4[25] = cd4[41];assign k4[26] = cd4[52];assign k4[27] = cd4[31];assign k4[28] = cd4[37];assign k4[29] = cd4[47];assign k4[30] = cd4[55];
   assign k4[31] = cd4[30];assign k4[32] = cd4[40];assign k4[33] = cd4[51];assign k4[34] = cd4[45];assign k4[35] = cd4[33];assign k4[36] = cd4[48];
   assign k4[37] = cd4[44];assign k4[38] = cd4[49];assign k4[39] = cd4[39];assign k4[40] = cd4[56];assign k4[41] = cd4[34];assign k4[42] = cd4[53];
   assign k4[43] = cd4[46];assign k4[44] = cd4[42];assign k4[45] = cd4[50];assign k4[46] = cd4[36];assign k4[47] = cd4[29];assign k4[48] = cd4[32];
	
	/*k5 generation*/
	assign k5[1] = cd5[14];assign k5[2] = cd5[17];assign k5[3] = cd5[11];assign k5[4] = cd5[24];assign k5[5] = cd5[1];assign k5[6] = cd5[5];
	assign k5[7] = cd5[3];assign k5[8] = cd5[28];assign k5[9] = cd5[15];assign k5[10] = cd5[6];assign k5[11] = cd5[21];assign k5[12] = cd5[10];
	assign k5[13] = cd5[23];assign k5[14] = cd5[17];assign k5[15] = cd5[11];assign k5[16] = cd5[4];assign k5[17] = cd5[26];assign k5[18] = cd5[8];
   assign k5[19] = cd5[16];assign k5[20] = cd5[7];assign k5[21] = cd5[27];assign k5[22] = cd5[20];assign k5[23] = cd5[13];assign k5[24] = cd5[2];               
   assign k5[25] = cd5[41];assign k5[26] = cd5[52];assign k5[27] = cd5[31];assign k5[28] = cd5[37];assign k5[29] = cd5[47];assign k5[30] = cd5[55];
   assign k5[31] = cd5[30];assign k5[32] = cd5[40];assign k5[33] = cd5[51];assign k5[34] = cd5[45];assign k5[35] = cd5[33];assign k5[36] = cd5[48];
   assign k5[37] = cd5[44];assign k5[38] = cd5[49];assign k5[39] = cd5[39];assign k5[40] = cd5[56];assign k5[41] = cd5[34];assign k5[42] = cd5[53];
   assign k5[43] = cd5[46];assign k5[44] = cd5[42];assign k5[45] = cd5[50];assign k5[46] = cd5[36];assign k5[47] = cd5[29];assign k5[48] = cd5[32];
	
	/*k6 generation*/
	assign k6[1] = cd6[14];assign k6[2] = cd6[17];assign k6[3] = cd6[11];assign k6[4] = cd6[24];assign k6[5] = cd6[1];assign k6[6] = cd6[5];
	assign k6[7] = cd6[3];assign k6[8] = cd6[28];assign k6[9] = cd6[15];assign k6[10] = cd6[6];assign k6[11] = cd6[21];assign k6[12] = cd6[10];
	assign k6[13] = cd6[23];assign k6[14] = cd6[17];assign k6[15] = cd6[11];assign k6[16] = cd6[4];assign k6[17] = cd6[26];assign k6[18] = cd6[8];
   assign k6[19] = cd6[16];assign k6[20] = cd6[7];assign k6[21] = cd6[27];assign k6[22] = cd6[20];assign k6[23] = cd6[13];assign k6[24] = cd6[2];               
   assign k6[25] = cd6[41];assign k6[26] = cd6[52];assign k6[27] = cd6[31];assign k6[28] = cd6[37];assign k6[29] = cd6[47];assign k6[30] = cd6[55];
   assign k6[31] = cd6[30];assign k6[32] = cd6[40];assign k6[33] = cd6[51];assign k6[34] = cd6[45];assign k6[35] = cd6[33];assign k6[36] = cd6[48];
   assign k6[37] = cd6[44];assign k6[38] = cd6[49];assign k6[39] = cd6[39];assign k6[40] = cd6[56];assign k6[41] = cd6[34];assign k6[42] = cd6[53];
   assign k6[43] = cd6[46];assign k6[44] = cd6[42];assign k6[45] = cd6[50];assign k6[46] = cd6[36];assign k6[47] = cd6[29];assign k6[48] = cd6[32];
	
	/*k7 generation*/
	assign k7[1] = cd7[14];assign k7[2] = cd7[17];assign k7[3] = cd7[11];assign k7[4] = cd7[24];assign k7[5] = cd7[1];assign k7[6] = cd7[5];
	assign k7[7] = cd7[3];assign k7[8] = cd7[28];assign k7[9] = cd7[15];assign k7[10] = cd7[6];assign k7[11] = cd7[21];assign k7[12] = cd7[10];
	assign k7[13] = cd7[23];assign k7[14] = cd7[17];assign k7[15] = cd7[11];assign k7[16] = cd7[4];assign k7[17] = cd7[26];assign k7[18] = cd7[8];
   assign k7[19] = cd7[16];assign k7[20] = cd7[7];assign k7[21] = cd7[27];assign k7[22] = cd7[20];assign k7[23] = cd7[13];assign k7[24] = cd7[2];               
   assign k7[25] = cd7[41];assign k7[26] = cd7[52];assign k7[27] = cd7[31];assign k7[28] = cd7[37];assign k7[29] = cd7[47];assign k7[30] = cd7[55];
   assign k7[31] = cd7[30];assign k7[32] = cd7[40];assign k7[33] = cd7[51];assign k7[34] = cd7[45];assign k7[35] = cd7[33];assign k7[36] = cd7[48];
   assign k7[37] = cd7[44];assign k7[38] = cd7[49];assign k7[39] = cd7[39];assign k7[40] = cd7[56];assign k7[41] = cd7[34];assign k7[42] = cd7[53];
   assign k7[43] = cd7[46];assign k7[44] = cd7[42];assign k7[45] = cd7[50];assign k7[46] = cd7[36];assign k7[47] = cd7[29];assign k7[48] = cd7[32];
	
	/*k8 generation*/
	assign k8[1] = cd8[14];assign k8[2] = cd8[17];assign k8[3] = cd8[11];assign k8[4] = cd8[24];assign k8[5] = cd8[1];assign k8[6] = cd8[5];
	assign k8[7] = cd8[3];assign k8[8] = cd8[28];assign k8[9] = cd8[15];assign k8[10] = cd8[6];assign k8[11] = cd8[21];assign k8[12] = cd8[10];
	assign k8[13] = cd8[23];assign k8[14] = cd8[17];assign k8[15] = cd8[11];assign k8[16] = cd8[4];assign k8[17] = cd8[26];assign k8[18] = cd8[8];
   assign k8[19] = cd8[16];assign k8[20] = cd8[7];assign k8[21] = cd8[27];assign k8[22] = cd8[20];assign k8[23] = cd8[13];assign k8[24] = cd8[2];               
   assign k8[25] = cd8[41];assign k8[26] = cd8[52];assign k8[27] = cd8[31];assign k8[28] = cd8[37];assign k8[29] = cd8[47];assign k8[30] = cd8[55];
   assign k8[31] = cd8[30];assign k8[32] = cd8[40];assign k8[33] = cd8[51];assign k8[34] = cd8[45];assign k8[35] = cd8[33];assign k8[36] = cd8[48];
   assign k8[37] = cd8[44];assign k8[38] = cd8[49];assign k8[39] = cd8[39];assign k8[40] = cd8[56];assign k8[41] = cd8[34];assign k8[42] = cd8[53];
   assign k8[43] = cd8[46];assign k8[44] = cd8[42];assign k8[45] = cd8[50];assign k8[46] = cd8[36];assign k8[47] = cd8[29];assign k8[48] = cd8[32];
	
	/*k9 generation*/
	assign k9[1] = cd9[14];assign k9[2] = cd9[17];assign k9[3] = cd9[11];assign k9[4] = cd9[24];assign k9[5] = cd9[1];assign k9[6] = cd9[5];
	assign k9[7] = cd9[3];assign k9[8] = cd9[28];assign k9[9] = cd9[15];assign k9[10] = cd9[6];assign k9[11] = cd9[21];assign k9[12] = cd9[10];
	assign k9[13] = cd9[23];assign k9[14] = cd9[17];assign k9[15] = cd9[11];assign k9[16] = cd9[4];assign k9[17] = cd9[26];assign k9[18] = cd9[8];
   assign k9[19] = cd9[16];assign k9[20] = cd9[7];assign k9[21] = cd9[27];assign k9[22] = cd9[20];assign k9[23] = cd9[13];assign k9[24] = cd9[2];               
   assign k9[25] = cd9[41];assign k9[26] = cd9[52];assign k9[27] = cd9[31];assign k9[28] = cd9[37];assign k9[29] = cd9[47];assign k9[30] = cd9[55];
   assign k9[31] = cd9[30];assign k9[32] = cd9[40];assign k9[33] = cd9[51];assign k9[34] = cd9[45];assign k9[35] = cd9[33];assign k9[36] = cd9[48];
   assign k9[37] = cd9[44];assign k9[38] = cd9[49];assign k9[39] = cd9[39];assign k9[40] = cd9[56];assign k9[41] = cd9[34];assign k9[42] = cd9[53];
   assign k9[43] = cd9[46];assign k9[44] = cd9[42];assign k9[45] = cd9[50];assign k9[46] = cd9[36];assign k9[47] = cd9[29];assign k9[48] = cd9[32];
	
	/*k10 generation*/
	assign k10[1] = cd10[14];assign k10[2] = cd10[17];assign k10[3] = cd10[11];assign k10[4] = cd10[24];assign k10[5] = cd10[1];assign k10[6] = cd10[5];
	assign k10[7] = cd10[3];assign k10[8] = cd10[28];assign k10[9] = cd10[15];assign k10[10] = cd10[6];assign k10[11] = cd10[21];assign k10[12] = cd10[10];
	assign k10[13] = cd10[23];assign k10[14] = cd10[17];assign k10[15] = cd10[11];assign k10[16] = cd10[4];assign k10[17] = cd10[26];assign k10[18] = cd10[8];
   assign k10[19] = cd10[16];assign k10[20] = cd10[7];assign k10[21] = cd10[27];assign k10[22] = cd10[20];assign k10[23] = cd10[13];assign k10[24] = cd10[2];               
   assign k10[25] = cd10[41];assign k10[26] = cd10[52];assign k10[27] = cd10[31];assign k10[28] = cd10[37];assign k10[29] = cd10[47];assign k10[30] = cd10[55];
   assign k10[31] = cd10[30];assign k10[32] = cd10[40];assign k10[33] = cd10[51];assign k10[34] = cd10[45];assign k10[35] = cd10[33];assign k10[36] = cd10[48];
   assign k10[37] = cd10[44];assign k10[38] = cd10[49];assign k10[39] = cd10[39];assign k10[40] = cd10[56];assign k10[41] = cd10[34];assign k10[42] = cd10[53];
   assign k10[43] = cd10[46];assign k10[44] = cd10[42];assign k10[45] = cd10[50];assign k10[46] = cd10[36];assign k10[47] = cd10[29];assign k10[48] = cd10[32];
	
	/*k11 generation*/
	assign k11[1] = cd11[14];assign k11[2] = cd11[17];assign k11[3] = cd11[11];assign k11[4] = cd11[24];assign k11[5] = cd11[1];assign k11[6] = cd11[5];
	assign k11[7] = cd11[3];assign k11[8] = cd11[28];assign k11[9] = cd11[15];assign k11[10] = cd11[6];assign k11[11] = cd11[21];assign k11[12] = cd11[10];
	assign k11[13] = cd11[23];assign k11[14] = cd11[17];assign k11[15] = cd11[11];assign k11[16] = cd11[4];assign k11[17] = cd11[26];assign k11[18] = cd11[8];
   assign k11[19] = cd11[16];assign k11[20] = cd11[7];assign k11[21] = cd11[27];assign k11[22] = cd11[20];assign k11[23] = cd11[13];assign k11[24] = cd11[2];               
   assign k11[25] = cd11[41];assign k11[26] = cd11[52];assign k11[27] = cd11[31];assign k11[28] = cd11[37];assign k11[29] = cd11[47];assign k11[30] = cd11[55];
   assign k11[31] = cd11[30];assign k11[32] = cd11[40];assign k11[33] = cd11[51];assign k11[34] = cd11[45];assign k11[35] = cd11[33];assign k11[36] = cd11[48];
   assign k11[37] = cd11[44];assign k11[38] = cd11[49];assign k11[39] = cd11[39];assign k11[40] = cd11[56];assign k11[41] = cd11[34];assign k11[42] = cd11[53];
   assign k11[43] = cd11[46];assign k11[44] = cd11[42];assign k11[45] = cd11[50];assign k11[46] = cd11[36];assign k11[47] = cd11[29];assign k11[48] = cd11[32];
	
	/*k12 generation*/
	assign k12[1] = cd12[14];assign k12[2] = cd12[17];assign k12[3] = cd12[11];assign k12[4] = cd12[24];assign k12[5] = cd12[1];assign k12[6] = cd12[5];
	assign k12[7] = cd12[3];assign k12[8] = cd12[28];assign k12[9] = cd12[15];assign k12[10] = cd12[6];assign k12[11] = cd12[21];assign k12[12] = cd12[10];
	assign k12[13] = cd12[23];assign k12[14] = cd12[17];assign k12[15] = cd12[11];assign k12[16] = cd12[4];assign k12[17] = cd12[26];assign k12[18] = cd12[8];
   assign k12[19] = cd12[16];assign k12[20] = cd12[7];assign k12[21] = cd12[27];assign k12[22] = cd12[20];assign k12[23] = cd12[13];assign k12[24] = cd12[2];               
   assign k12[25] = cd12[41];assign k12[26] = cd12[52];assign k12[27] = cd12[31];assign k12[28] = cd12[37];assign k12[29] = cd12[47];assign k12[30] = cd12[55];
   assign k12[31] = cd12[30];assign k12[32] = cd12[40];assign k12[33] = cd12[51];assign k12[34] = cd12[45];assign k12[35] = cd12[33];assign k12[36] = cd12[48];
   assign k12[37] = cd12[44];assign k12[38] = cd12[49];assign k12[39] = cd12[39];assign k12[40] = cd12[56];assign k12[41] = cd12[34];assign k12[42] = cd12[53];
   assign k12[43] = cd12[46];assign k12[44] = cd12[42];assign k12[45] = cd12[50];assign k12[46] = cd12[36];assign k12[47] = cd12[29];assign k12[48] = cd12[32];
	
	/*k13 generation*/
	assign k13[1] = cd13[14];assign k13[2] = cd13[17];assign k13[3] = cd13[11];assign k13[4] = cd13[24];assign k13[5] = cd13[1];assign k13[6] = cd13[5];
	assign k13[7] = cd13[3];assign k13[8] = cd13[28];assign k13[9] = cd13[15];assign k13[10] = cd13[6];assign k13[11] = cd13[21];assign k13[12] = cd13[10];
	assign k13[13] = cd13[23];assign k13[14] = cd13[17];assign k13[15] = cd13[11];assign k13[16] = cd13[4];assign k13[17] = cd13[26];assign k13[18] = cd13[8];
   assign k13[19] = cd13[16];assign k13[20] = cd13[7];assign k13[21] = cd13[27];assign k13[22] = cd13[20];assign k13[23] = cd13[13];assign k13[24] = cd13[2];               
   assign k13[25] = cd13[41];assign k13[26] = cd13[52];assign k13[27] = cd13[31];assign k13[28] = cd13[37];assign k13[29] = cd13[47];assign k13[30] = cd13[55];
   assign k13[31] = cd13[30];assign k13[32] = cd13[40];assign k13[33] = cd13[51];assign k13[34] = cd13[45];assign k13[35] = cd13[33];assign k13[36] = cd13[48];
   assign k13[37] = cd13[44];assign k13[38] = cd13[49];assign k13[39] = cd13[39];assign k13[40] = cd13[56];assign k13[41] = cd13[34];assign k13[42] = cd13[53];
   assign k13[43] = cd13[46];assign k13[44] = cd13[42];assign k13[45] = cd13[50];assign k13[46] = cd13[36];assign k13[47] = cd13[29];assign k13[48] = cd13[32];
	
	/*k14 generation*/
	assign k14[1] = cd14[14];assign k14[2] = cd14[17];assign k14[3] = cd14[11];assign k14[4] = cd14[24];assign k14[5] = cd14[1];assign k14[6] = cd14[5];
	assign k14[7] = cd14[3];assign k14[8] = cd14[28];assign k14[9] = cd14[15];assign k14[10] = cd14[6];assign k14[11] = cd14[21];assign k14[12] = cd14[10];
	assign k14[13] = cd14[23];assign k14[14] = cd14[17];assign k14[15] = cd14[11];assign k14[16] = cd14[4];assign k14[17] = cd14[26];assign k14[18] = cd14[8];
   assign k14[19] = cd14[16];assign k14[20] = cd14[7];assign k14[21] = cd14[27];assign k14[22] = cd14[20];assign k14[23] = cd14[13];assign k14[24] = cd14[2];               
   assign k14[25] = cd14[41];assign k14[26] = cd14[52];assign k14[27] = cd14[31];assign k14[28] = cd14[37];assign k14[29] = cd14[47];assign k14[30] = cd14[55];
   assign k14[31] = cd14[30];assign k14[32] = cd14[40];assign k14[33] = cd14[51];assign k14[34] = cd14[45];assign k14[35] = cd14[33];assign k14[36] = cd14[48];
   assign k14[37] = cd14[44];assign k14[38] = cd14[49];assign k14[39] = cd14[39];assign k14[40] = cd14[56];assign k14[41] = cd14[34];assign k14[42] = cd14[53];
   assign k14[43] = cd14[46];assign k14[44] = cd14[42];assign k14[45] = cd14[50];assign k14[46] = cd14[36];assign k14[47] = cd14[29];assign k14[48] = cd14[32];
	
	/*k15 generation*/
	assign k15[1] = cd15[14];assign k15[2] = cd15[17];assign k15[3] = cd15[11];assign k15[4] = cd15[24];assign k15[5] = cd15[1];assign k15[6] = cd15[5];
	assign k15[7] = cd15[3];assign k15[8] = cd15[28];assign k15[9] = cd15[15];assign k15[10] = cd15[6];assign k15[11] = cd15[21];assign k15[12] = cd15[10];
	assign k15[13] = cd15[23];assign k15[14] = cd15[17];assign k15[15] = cd15[11];assign k15[16] = cd15[4];assign k15[17] = cd15[26];assign k15[18] = cd15[8];
   assign k15[19] = cd15[16];assign k15[20] = cd15[7];assign k15[21] = cd15[27];assign k15[22] = cd15[20];assign k15[23] = cd15[13];assign k15[24] = cd15[2];               
   assign k15[25] = cd15[41];assign k15[26] = cd15[52];assign k15[27] = cd15[31];assign k15[28] = cd15[37];assign k15[29] = cd15[47];assign k15[30] = cd15[55];
   assign k15[31] = cd15[30];assign k15[32] = cd15[40];assign k15[33] = cd15[51];assign k15[34] = cd15[45];assign k15[35] = cd15[33];assign k15[36] = cd15[48];
   assign k15[37] = cd15[44];assign k15[38] = cd15[49];assign k15[39] = cd15[39];assign k15[40] = cd15[56];assign k15[41] = cd15[34];assign k15[42] = cd15[53];
   assign k15[43] = cd15[46];assign k15[44] = cd15[42];assign k15[45] = cd15[50];assign k15[46] = cd15[36];assign k15[47] = cd15[29];assign k15[48] = cd15[32];
	
	/*k16 generation*/
	assign k16[1] = cd16[14];assign k16[2] = cd16[17];assign k16[3] = cd16[11];assign k16[4] = cd16[24];assign k16[5] = cd16[1];assign k16[6] = cd16[5];
	assign k16[7] = cd16[3];assign k16[8] = cd16[28];assign k16[9] = cd16[15];assign k16[10] = cd16[6];assign k16[11] = cd16[21];assign k16[12] = cd16[10];
	assign k16[13] = cd16[23];assign k16[14] = cd16[17];assign k16[15] = cd16[11];assign k16[16] = cd16[4];assign k16[17] = cd16[26];assign k16[18] = cd16[8];
   assign k16[19] = cd16[16];assign k16[20] = cd16[7];assign k16[21] = cd16[27];assign k16[22] = cd16[20];assign k16[23] = cd16[13];assign k16[24] = cd16[2];               
   assign k16[25] = cd16[41];assign k16[26] = cd16[52];assign k16[27] = cd16[31];assign k16[28] = cd16[37];assign k16[29] = cd16[47];assign k16[30] = cd16[55];
   assign k16[31] = cd16[30];assign k16[32] = cd16[40];assign k16[33] = cd16[51];assign k16[34] = cd16[45];assign k16[35] = cd16[33];assign k16[36] = cd16[48];
   assign k16[37] = cd16[44];assign k16[38] = cd16[49];assign k16[39] = cd16[39];assign k16[40] = cd16[56];assign k16[41] = cd16[34];assign k16[42] = cd16[53];
   assign k16[43] = cd16[46];assign k16[44] = cd16[42];assign k16[45] = cd16[50];assign k16[46] = cd16[36];assign k16[47] = cd16[29];assign k16[48] = cd16[32];
                
endmodule
	