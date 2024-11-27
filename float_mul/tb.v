module tb;
reg [31:0] cycles;   initial cycles=0;
reg [31:0] errors;   initial errors=0;
reg [31:0] wrongs;   initial wrongs=0;
reg [31:0] corrects; initial corrects=0;
reg [31:0] marker;   initial marker=0;


reg  clk;
always begin
    clk=0;
    #10;
    clk=1;
    #3;
    $python("negedge()");
    #7;
end

initial begin
    $dumpvars(0,tb);
    ain = 0;
    bin = 0;
    #100;
end

reg [31:0] ain;
reg [31:0] bin;
wire [31:0] out;

float_mul dut (
    .ain(ain),
    .bin(bin),
    .out(out)

);


endmodule
