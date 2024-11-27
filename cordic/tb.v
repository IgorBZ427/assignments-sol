module tb;
reg [31:0] cycles;   initial cycles=0;
reg [31:0] errors;   initial errors=0;
reg [31:0] wrongs;   initial wrongs=0;
reg [31:0] corrects; initial corrects=0;
reg [31:0] marker;   initial marker=0;

reg [31:0] din;
reg [4:0]  iterations;
reg  clk,rst_n,start;
wire [15:0] dout;
wire  ready,busy;
reg vldin;

always begin
    clk=0;
    #10;
    clk=1;
    #3; $python("negedge()"); #7;
end

initial begin
    $dumpvars(0,tb);
    din[31:0] = 0;
    iterations = 0;
    rst_n = 0;
    start = 0;
    vldin = 0;
    #100;
    rst_n=1;
end

cordic_sqrt_ex sqrt_u40_5 (
  .clk(clk), .rst_n(rst_n),
    .din(din),         // number to compute sqrt off  (theta in C)
    .start(start),            // start computing
    .vldin(vldin),
    .dout(dout),         // resulting square root  (s in C)
    .ready(ready),              // answer ready          
    .busy(busy),            // in the middle of work, start is disregarded at the duration
    .iterations(iterations) // optional: number of iterations. if writing without, just use 32.
);


endmodule
