/*------------------------DES_Testbench-------------------------------*/

module DES_Testbench;
//define input and output for the DES_Testbench
	reg clk,reset,mode;//clk, reset and mode control
					   //mode-if '0':Encryption;if '1':Decryption
    reg [0:63] din;//input 64-bit plaintext data
    reg [0:63] key;//input original 64-bit key
    wire [0:63] dout;//Encrypted Data
	wire oflag;//output data valid indicator
	
//instantiate the Device Under Test(DUT)
	des MyDes (
	.clk (clk),
	.en (reset),
	.mode (mode),
	.din (din),
	.key (key),
	.dout (dout),
	.oflag (oflag)
	);
//set all input pin into known states
	initial//one time
	begin
		$display($time, "<< Starting the DES Simulation >>");
		clk = 0;
		reset = 1;//disable,do initialize and reset
		
		din = 64'h8787878787878787;//eight-digital decimal 
		key = 64'h0E329232EA6D0D73;//result of encryption:0x0000000000000000
	
		mode = 0;//in Encryption mode		
		#300 reset = 0;//Enable the DES	 
	end
	
	always
		#5 clk=~clk;//Create clk
	
	initial begin//all the initial, always blocks start execution at time 0
		$dumpfile("DES.vcd");//simulator store vars
		$dumpvars;
	end
	
	initial begin
		$display($time,"\tclk,\treset,\mode\n");
		$monitor("%d",$time);//track the changes
		$monitor("%h\t,%h\t",key,reset);
	end
	
	initial
	#2000 $finish;// terminating the simulation after #2000 time units
endmodule