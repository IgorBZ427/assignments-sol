`timescale 1ns/100ps

module cordic_sqrt_ex_tb ;

reg clk,rst;
reg [31:0] din;
reg start;
reg [4:0] iterations;

wire [15:0] dout;
wire ready,busy;

cordic_sqrt_ex u0_DUT (
  .clk(clk), 
  .rst_n(rst),
  .din(din),         // number to compute sqrt off  (theta in C)
   .start(start),            // start computing
   .dout(dout),         // resulting square root  (s in C)
   .ready(ready),              // answer ready          
   .busy(busy),            
   .iterations(iterations) 
    );


initial begin
	clk = 0;
	forever #5 clk = ~clk;
end
   
initial begin
	   $dumpfile("test_sqrt.vcd");
	   $dumpvars(0,cordic_sqrt_ex_tb);

	  iterations = 0;
	  start = 0;
	  din = 0;
	  rst = 0;
		
	  #10 rst = 1;
	  #20
	  start = 1;
	  din = 9;
	  #10
	  start = 0;

	  #10
	  #10
	  start = 1;
	  din = 4;
	  #10
	  start = 0;

	  #10
	  #10
	  start = 1;
	  din = 16;
	  #10
	  start = 0;

	#50 $finish;
  end

 endmodule
