module multiplier_24bit (
    input [23:0] arg1,
    input [23:0] arg2,
    output [31:0] res_out
);

reg [31:0] result;
assign res_out = result;
integer i, j;
always @(*) begin
    
    result = 32'b0;

    for (i = 0; i < 24; i = i + 1) begin
        for (j = 0; j < 24; j = j + 1) begin
            if (arg1[i] & arg2[j]) begin
                result[i+j] = result[i+j] + 1;
            end
        end
    end
end

endmodule