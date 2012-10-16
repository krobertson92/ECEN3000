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

module CnDn_gen(cn_prev, dn_prev, cn, dn, num_shift);
	input[55:0] cn_prev,dn_prev;
	input num_shift;
	output[55:0] cn,dn;
endmodule

module kn_gen(cn,dn,kn);
	input[55:0] cn,dn;
	output[47:0] kn;
endmodule
	