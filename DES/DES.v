module des(clk,reset,mode,din,key,dout,oflag);
	input clk,reset,mode;
	input[63:0] din,key;
	output[63:0] dout;
	output oflag;
	wire[55:0] key_plus;
	K_plus_gen kasdf(key,key_plus);
endmodule

module K_plus_gen(key,key_plus);
	input[63:0] key;
	output[55:0] key_plus;
endmodule

module CnDn_gen(cn_prev, dn_prev,CD1,CD2,CD3,CD4,CD5,CD6,C7,C8);//, num_shift);
	input[55:0] cn_prev,dn_prev;
	//input num_shift;
	//output[55:0] cn,dn;
	output[55:0] CD1,CD2,CD3,CD4,CD5,CD6,C7,C8;
	
	wire[28:0] C0;
	wire[28:0] D0;
	
	assign C0[27:0]=cn_prev;//cn[55:28];
	assign D0[27:0]=dn_prev;//cn[27:0];
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
	wire[28:0] C1;
	wire[28:0] D1;
	assign C1={C0[27:0],C0[28]};
	assign D1={D0[27:0],D0[28]};
	assign CD1={C1,D1};
	
	assign C2={C0[26:0],C0[28:27]};
	assign D2={D0[26:0],D0[28:27]};
	assign CD2={C2,D2};
	
	assign C3={C0[24:0],C0[28:25]};
	assign D3={D0[24:0],D0[28:25]};
	assign CD3={C3,D3};
	
	assign C4={C0[22:0],C0[28:23]};
	assign D4={D0[22:0],D0[28:23]};
	assign CD4={C4,D4};
	
	assign C5={C0[20:0],C0[28:21]};
	assign D5={D0[20:0],D0[28:21]};
	assign CD5={C5,D5};
	
	assign C6={C0[18:0],C0[28:19]};
	assign D6={D0[18:0],D0[28:19]};
	assign CD6={C6,D6};
	
	assign C7={C0[16:0],C0[28:17]};
	assign D7={D0[16:0],D0[28:17]};
	assign CD7={C7,D7};
	
	assign C8={C0[14:0],C0[28:15]};
	assign D8={D0[14:0],D0[28:15]};
	assign CD16={C16,D16};
	
	assign C9={C0[13:0],C0[28:14]};
	assign D9={D0[13:0],D0[28:14]};
	assign CD16={C16,D16};
	
	assign C10={C0[11:0],C0[28:12]};
	assign D10={D0[11:0],D0[28:12]};
	assign CD16={C16,D16};
	
	assign C11={C0[9:0],C0[28:10]};
	assign D11={D0[9:0],D0[28:10]};
	assign CD16={C16,D16};
	
	assign C12={C0[7:0],C0[28:8]};
	assign D12={D0[7:0],D0[28:8]};
	assign CD16={C16,D16};
	
	assign C13={C0[5:0],C0[28:6]};
	assign D13={D0[5:0],D0[28:6]};
	assign CD16={C16,D16};
	
	assign C14={C0[3:0],C0[28:4]};
	assign D14={D0[3:0],D0[28:4]};
	assign CD16={C16,D16};
	
	assign C15={C0[1:0],C0[28:2]};
	assign D15={D0[1:0],D0[28:2]};
	assign CD16={C16,D16};
	
	assign C16={C0[0],C0[28:1]};
	assign D16={D0[0],D0[28:1]};
	assign CD16={C16,D16};
endmodule

module kn_gen(cn,dn,kn);
	input[55:0] cn,dn;
	output[47:0] kn;
endmodule


module ip_gen(din,ip);
	input[1:64] din;
	output[1:64] ip;
	assign ip[ 0]=din[58];assign ip[ 1]=din[50];assign ip[ 2]=din[42];assign ip[ 3]=din[34];assign ip[ 4]=din[26];assign ip[ 5]=din[18];assign ip[ 6]=din[10];assign ip[ 7]=din[2];
	assign ip[ 8]=din[60];assign ip[ 9]=din[52];assign ip[10]=din[44];assign ip[11]=din[36];assign ip[12]=din[28];assign ip[13]=din[20];assign ip[14]=din[12];assign ip[15]=din[4];
	assign ip[16]=din[62];assign ip[17]=din[54];assign ip[18]=din[46];assign ip[19]=din[38];assign ip[20]=din[30];assign ip[21]=din[22];assign ip[22]=din[14];assign ip[23]=din[6];
	assign ip[24]=din[64];assign ip[25]=din[56];assign ip[26]=din[48];assign ip[27]=din[40];assign ip[28]=din[32];assign ip[29]=din[24];assign ip[30]=din[16];assign ip[31]=din[8];
	assign ip[32]=din[57];assign ip[32]=din[49];assign ip[33]=din[41];assign ip[34]=din[33];assign ip[35]=din[25];assign ip[36]=din[17];assign ip[37]=din[ 9];assign ip[38]=din[1];
	assign ip[40]=din[59];assign ip[41]=din[51];assign ip[42]=din[43];assign ip[43]=din[35];assign ip[44]=din[27];assign ip[45]=din[19];assign ip[46]=din[11];assign ip[47]=din[3];
	assign ip[48]=din[61];assign ip[49]=din[53];assign ip[50]=din[45];assign ip[51]=din[37];assign ip[52]=din[29];assign ip[53]=din[21];assign ip[54]=din[13];assign ip[55]=din[5];
	assign ip[56]=din[63];assign ip[57]=din[55];assign ip[58]=din[47];assign ip[59]=din[39];assign ip[60]=din[31];assign ip[61]=din[23];assign ip[62]=din[15];assign ip[63]=din[7];
endmodule

module LnRn_gen();

endmodule

module genEXORK(ein,kin,exout);
	input[1:48] ein,kin;
	output[1:48] exout;
	assign exporout=kin^ein;
endmodule

module sBox(exorin,biout);
	input[1:48] exorin;
	output[1:48] biout;
endmodule

module S1(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=14;assign S[2]=4;assign S[3]=13;assign S[4]=1;assign S[5]=2;assign S[6]=15;assign S[7]=11;assign S[8]=8;assign S[9]=3;assign S[10]=10;assign S[11]=6;assign S[12]=12;assign S[13]=5;assign S[14]=9;assign S[15]=0;assign S[16]=7;
assign S[17]=0;assign S[18]=15;assign S[19]=7;assign S[20]=4;assign S[21]=14;assign S[22]=2;assign S[23]=13;assign S[24]=1;assign S[25]=10;assign S[26]=6;assign S[27]=12;assign S[28]=11;assign S[29]=9;assign S[30]=5;assign S[31]=3;assign S[32]=8;
assign S[33]=4;assign S[34]=1;assign S[35]=14;assign S[36]=8;assign S[37]=13;assign S[38]=6;assign S[39]=2;assign S[40]=11;assign S[41]=15;assign S[42]=12;assign S[43]=9;assign S[44]=7;assign S[45]=3;assign S[46]=10;assign S[47]=5;assign S[48]=0;
assign S[49]=15;assign S[50]=12;assign S[51]=8;assign S[52]=2;assign S[53]=4;assign S[54]=9;assign S[55]=1;assign S[56]=7;assign S[57]=5;assign S[58]=11;assign S[59]=3;assign S[60]=14;assign S[61]=10;assign S[62]=0;assign S[63]=6;assign S[64]=13;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S2(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=15;assign S[2]=1;assign S[3]=8;assign S[4]=14;assign S[5]=6;assign S[6]=11;assign S[7]=3;assign S[8]=4;assign S[9]=9;assign S[10]=7;assign S[11]=2;assign S[12]=13;assign S[13]=12;assign S[14]=0;assign S[15]=5;assign S[16]=10;
assign S[17]=3;assign S[18]=13;assign S[19]=4;assign S[20]=7;assign S[21]=15;assign S[22]=2;assign S[23]=8;assign S[24]=14;assign S[25]=12;assign S[26]=0;assign S[27]=1;assign S[28]=10;assign S[29]=6;assign S[30]=9;assign S[31]=11;assign S[32]=5;
assign S[33]=0;assign S[34]=14;assign S[35]=7;assign S[36]=11;assign S[37]=10;assign S[38]=4;assign S[39]=13;assign S[40]=1;assign S[41]=5;assign S[42]=8;assign S[43]=12;assign S[44]=6;assign S[45]=9;assign S[46]=3;assign S[47]=2;assign S[48]=15;
assign S[49]=13;assign S[50]=8;assign S[51]=10;assign S[52]=1;assign S[53]=3;assign S[54]=15;assign S[55]=4;assign S[56]=2;assign S[57]=11;assign S[58]=6;assign S[59]=7;assign S[60]=12;assign S[61]=0;assign S[62]=5;assign S[63]=14;assign S[64]=9;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S3(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=10;assign S[2]=0;assign S[3]=9;assign S[4]=14;assign S[5]=6;assign S[6]=3;assign S[7]=15;assign S[8]=5;assign S[9]=1;assign S[10]=13;assign S[11]=12;assign S[12]=7;assign S[13]=11;assign S[14]=4;assign S[15]=2;assign S[16]=8;
assign S[17]=13;assign S[18]=7;assign S[19]=0;assign S[20]=9;assign S[21]=3;assign S[22]=4;assign S[23]=6;assign S[24]=10;assign S[25]=2;assign S[26]=8;assign S[27]=5;assign S[28]=14;assign S[29]=12;assign S[30]=11;assign S[31]=15;assign S[32]=1;
assign S[33]=13;assign S[34]=6;assign S[35]=4;assign S[36]=9;assign S[37]=8;assign S[38]=15;assign S[39]=3;assign S[40]=0;assign S[41]=11;assign S[42]=1;assign S[43]=2;assign S[44]=12;assign S[45]=5;assign S[46]=10;assign S[47]=14;assign S[48]=7;
assign S[49]=1;assign S[50]=10;assign S[51]=13;assign S[52]=0;assign S[53]=6;assign S[54]=9;assign S[55]=8;assign S[56]=7;assign S[57]=4;assign S[58]=15;assign S[59]=14;assign S[60]=3;assign S[61]=11;assign S[62]=5;assign S[63]=2;assign S[64]=12;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S4(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=7;assign S[2]=13;assign S[3]=14;assign S[4]=3;assign S[5]=0;assign S[6]=6;assign S[7]=9;assign S[8]=10;assign S[9]=1;assign S[10]=2;assign S[11]=8;assign S[12]=5;assign S[13]=11;assign S[14]=12;assign S[15]=4;assign S[16]=15;
assign S[17]=13;assign S[18]=8;assign S[19]=11;assign S[20]=5;assign S[21]=6;assign S[22]=15;assign S[23]=0;assign S[24]=3;assign S[25]=4;assign S[26]=7;assign S[27]=2;assign S[28]=12;assign S[29]=1;assign S[30]=10;assign S[31]=14;assign S[32]=9;
assign S[33]=10;assign S[34]=6;assign S[35]=9;assign S[36]=0;assign S[37]=12;assign S[38]=11;assign S[39]=7;assign S[40]=13;assign S[41]=15;assign S[42]=1;assign S[43]=3;assign S[44]=14;assign S[45]=5;assign S[46]=2;assign S[47]=8;assign S[48]=4;
assign S[49]=3;assign S[50]=15;assign S[51]=0;assign S[52]=6;assign S[53]=10;assign S[54]=1;assign S[55]=13;assign S[56]=8;assign S[57]=9;assign S[58]=4;assign S[59]=5;assign S[60]=11;assign S[61]=12;assign S[62]=7;assign S[63]=2;assign S[64]=14;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S5(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=2;assign S[2]=12;assign S[3]=4;assign S[4]=1;assign S[5]=7;assign S[6]=10;assign S[7]=11;assign S[8]=6;assign S[9]=8;assign S[10]=5;assign S[11]=3;assign S[12]=15;assign S[13]=13;assign S[14]=0;assign S[15]=14;assign S[16]=9;
assign S[17]=14;assign S[18]=11;assign S[19]=2;assign S[20]=12;assign S[21]=4;assign S[22]=7;assign S[23]=13;assign S[24]=1;assign S[25]=5;assign S[26]=0;assign S[27]=15;assign S[28]=10;assign S[29]=3;assign S[30]=9;assign S[31]=8;assign S[32]=6;
assign S[33]=4;assign S[34]=2;assign S[35]=1;assign S[36]=11;assign S[37]=10;assign S[38]=13;assign S[39]=7;assign S[40]=8;assign S[41]=15;assign S[42]=9;assign S[43]=12;assign S[44]=5;assign S[45]=6;assign S[46]=3;assign S[47]=0;assign S[48]=14;
assign S[49]=11;assign S[50]=8;assign S[51]=12;assign S[52]=7;assign S[53]=1;assign S[54]=14;assign S[55]=2;assign S[56]=13;assign S[57]=6;assign S[58]=15;assign S[59]=0;assign S[60]=9;assign S[61]=10;assign S[62]=4;assign S[63]=5;assign S[64]=3;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S6(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=12;assign S[2]=1;assign S[3]=10;assign S[4]=15;assign S[5]=9;assign S[6]=2;assign S[7]=6;assign S[8]=8;assign S[9]=0;assign S[10]=13;assign S[11]=3;assign S[12]=4;assign S[13]=14;assign S[14]=7;assign S[15]=5;assign S[16]=11;
assign S[17]=10;assign S[18]=15;assign S[19]=4;assign S[20]=2;assign S[21]=7;assign S[22]=12;assign S[23]=9;assign S[24]=5;assign S[25]=6;assign S[26]=1;assign S[27]=13;assign S[28]=14;assign S[29]=0;assign S[30]=11;assign S[31]=3;assign S[32]=8;
assign S[33]=9;assign S[34]=14;assign S[35]=15;assign S[36]=5;assign S[37]=2;assign S[38]=8;assign S[39]=12;assign S[40]=3;assign S[41]=7;assign S[42]=0;assign S[43]=4;assign S[44]=10;assign S[45]=1;assign S[46]=13;assign S[47]=11;assign S[48]=6;
assign S[49]=4;assign S[50]=3;assign S[51]=2;assign S[52]=12;assign S[53]=9;assign S[54]=5;assign S[55]=15;assign S[56]=10;assign S[57]=11;assign S[58]=14;assign S[59]=1;assign S[60]=7;assign S[61]=6;assign S[62]=0;assign S[63]=8;assign S[64]=13;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S7(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=4;assign S[2]=11;assign S[3]=2;assign S[4]=14;assign S[5]=15;assign S[6]=0;assign S[7]=8;assign S[8]=13;assign S[9]=3;assign S[10]=12;assign S[11]=9;assign S[12]=7;assign S[13]=5;assign S[14]=10;assign S[15]=6;assign S[16]=1;
assign S[17]=13;assign S[18]=0;assign S[19]=11;assign S[20]=7;assign S[21]=4;assign S[22]=9;assign S[23]=1;assign S[24]=10;assign S[25]=14;assign S[26]=3;assign S[27]=5;assign S[28]=12;assign S[29]=2;assign S[30]=15;assign S[31]=8;assign S[32]=6;
assign S[33]=1;assign S[34]=4;assign S[35]=11;assign S[36]=13;assign S[37]=12;assign S[38]=3;assign S[39]=7;assign S[40]=14;assign S[41]=10;assign S[42]=15;assign S[43]=6;assign S[44]=8;assign S[45]=0;assign S[46]=5;assign S[47]=9;assign S[48]=2;
assign S[49]=6;assign S[50]=11;assign S[51]=13;assign S[52]=8;assign S[53]=1;assign S[54]=4;assign S[55]=10;assign S[56]=7;assign S[57]=9;assign S[58]=5;assign S[59]=0;assign S[60]=15;assign S[61]=14;assign S[62]=2;assign S[63]=3;assign S[64]=12;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule

module S8(bin,vout);
input[1:6] bin;
output[1:4] vout;
wire[1:64] S;
assign S[1]=13;assign S[2]=2;assign S[3]=8;assign S[4]=4;assign S[5]=6;assign S[6]=15;assign S[7]=11;assign S[8]=1;assign S[9]=10;assign S[10]=9;assign S[11]=3;assign S[12]=14;assign S[13]=5;assign S[14]=0;assign S[15]=12;assign S[16]=7;
assign S[17]=1;assign S[18]=15;assign S[19]=13;assign S[20]=8;assign S[21]=10;assign S[22]=3;assign S[23]=7;assign S[24]=4;assign S[25]=12;assign S[26]=5;assign S[27]=6;assign S[28]=11;assign S[29]=0;assign S[30]=14;assign S[31]=9;assign S[32]=2;
assign S[33]=7;assign S[34]=11;assign S[35]=4;assign S[36]=1;assign S[37]=9;assign S[38]=12;assign S[39]=14;assign S[40]=2;assign S[41]=0;assign S[42]=6;assign S[43]=10;assign S[44]=13;assign S[45]=15;assign S[46]=3;assign S[47]=5;assign S[48]=8;
assign S[49]=2;assign S[50]=1;assign S[51]=14;assign S[52]=7;assign S[53]=4;assign S[54]=10;assign S[55]=8;assign S[56]=13;assign S[57]=15;assign S[58]=12;assign S[59]=9;assign S[60]=0;assign S[61]=3;assign S[62]=5;assign S[63]=6;assign S[64]=11;
assign vout=S[{bin[1],bin[6]}<<3+bin[2:4]];
endmodule
