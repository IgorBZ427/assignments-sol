
module cordic_sqrt_ex (
  input clk, input rst_n
    ,input [31:0] din         // number to compute sqrt off  (theta in C)
	,input vldin
    ,input start            // start computing
    ,output reg [15:0] dout         // resulting square root  (s in C)
    ,output reg ready              // answer ready          
    ,output reg busy            // in the middle of work, start is disregarded at the duration
    ,input [4:0] iterations // optional: number of iterations. if writing without, just use 32.
);


reg [15:0] base,y;
wire [15:0] x;
reg [16:0] sum_y;
integer i,j;
reg start_d;
wire start_pulse;
reg start_pulse_d;
reg vldin_d;

assign start_pulse = vldin & ~vldin_d; 


//assign x = start_pulse ? din[15:0]: 16'b0;
assign x = din[15:0];

//variation #1
//https://www.convict.lu/Jeunes/Math/square_root_CORDIC.htm
always @(*)
begin
	y = 16'b0;
	base = 16'd128;
	sum_y = 17'b0;
	
	for(i=0 ;i<8; i = i+1)
	begin
		if(start_pulse_d) 
		begin
			y = y + base;
			//$display ("y=%d ",y);
		end
		sum_y=0;
		for (j=0; j<y ; j = j+1) 
		begin
			sum_y = sum_y + y;
		end

		if(sum_y > x) 
		begin
			y = y - base;
		end
		if(start_pulse_d) base = base>>1;
		//$display ("y=%d , base = %d, sum_y=%d, start_pulse = %d, clk = %d",y,base,sum_y,start_pulse_d,clk);
	end

end
	

always @ (posedge clk or negedge rst_n ) 
begin
	if(~rst_n)
	begin
 		dout <= 15'b0;         // resulting square root  (s in C)
    	ready <= 1'b0;              // answer ready          
    	busy <= 1'b0;            // in the middle of work, start is disregarded at the duration
		start_d <= 1'b0;
		vldin_d <= 1'b0;
		
		start_pulse_d <= 1'b0;
	end
	else
	begin
		vldin_d <= vldin;
		start_d <= start;
		start_pulse_d <= start_pulse;
		if(start_pulse_d) dout <= y;
		else dout <= 1'b0;
		ready <= start_pulse_d;

				

	end

end

endmodule


