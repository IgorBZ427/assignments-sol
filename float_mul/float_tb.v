`timescale 1ns/100ps

module float_tb ;


reg [31:0] ain;
reg [31:0] bin;
wire [31:0] out;


float_mul u0_DUT (
.ain(ain),
.bin(bin),
.out(out));




  
initial begin
	$dumpfile("float.vcd");
	$dumpvars(0,float_tb);
    #20
    //ain = 32'b01000000011000001000000001000000; //3.5
    //bin = 32'b01000000001000000010000100000000; //2.5
      ain = 32'b01000011111101000100000000000000;
      bin = 32'b10111110101100110011001100110100;


	#500 $finish;
  end


 endmodule
