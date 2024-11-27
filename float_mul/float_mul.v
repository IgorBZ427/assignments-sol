
//TODO:
//1. accuracy improvment
//2. overflow,undeflow
//3. addition

module float_mul ( input [31:0] ain,input [31:0] bin, output [31:0] out);

wire [31:0] ZERO = 32'b0;
wire [31:0] NEGZERO = 32'h80000000;
wire zeroes = (ZERO==ain)||(ZERO==bin)||(NEGZERO==ain)||(NEGZERO==bin);
wire z_sign;
wire [7:0] z_exp;
wire [22:0] z_mat;
wire [63:0] mantissa_64_mult;

wire [8:0] exp_a,exp_b;
assign exp_a=ain[30:23];
assign exp_b=bin[30:23];
assign z_sign = (ain[31] ^ bin[31]);
assign z_exp = (ain[30:23] + bin[30:23] - 8'd127) + norm_exp_value;

//assign mantissa_64_mult = man_norm_a * man_norm_b;
assign mantissa_64_mult = (({1'b1,ain[22:0]}) * ({1'b1,bin[22:0]})); 
//assign mantissa_48 = mantissa_48_mult[(post_zeros-1) -:23];
assign z_mat = mantissa_64_mult[post_zeros-24] ?  (mantissa_64_mult[(post_zeros-1) -:23] +1) : mantissa_64_mult[(post_zeros-1) -:23];

assign out = zeroes ? ZERO : {z_sign,z_exp,z_mat};

wire [5:0] a_width,b_width;
wire [23:0] man_norm_a,man_norm_b;
wire [5:0] sum_widths,mantissa_width;
wire [7:0] norm_exp_value;
assign man_norm_a = {1'b1,ain[22:0]}>> (n1);
assign man_norm_b = {1'b1,bin[22:0]}>> (n2);
assign a_width = m1-n1;
assign b_width = m2-n2;
assign sum_widths = (a_width + b_width); 
assign mantissa_width = post_zeros - trail_zeros;
//assign norm_exp_value = mantissa_width - sum_widths;
//assign norm_exp_value = (post_zeros > 46) ? (post_zeros - 8'd46) : 0;
assign norm_exp_value = mantissa_64_mult[47]; 



integer i;
reg [5:0] trail_zeros;
reg [5:0] post_zeros;
reg first,first_a,first_b;
reg [4:0] m1,n1,m2,n2;

//get trailing zeros
always @(*) begin
    trail_zeros = 0;
    post_zeros = 0;
    first = 0;
    first_a = 0;
    first_b = 0;
    n1 =0;
    m1 =0;
    n2 =0;
    m2 =0;
    for(i=1;i<63;i=i+1) begin
        if((mantissa_64_mult[i-1]==1'b0) && (mantissa_64_mult[i]==1'b1) && ~first) begin 
            trail_zeros = i;
            first = 1;
            //$display ("mantissa[i-1]= %b , mantissa[i]= %b, i= %d, first=%b, mantissa_64_mult=%b",  mantissa_64_mult[i-1],mantissa_64_mult[i],i,first,mantissa_64_mult);
        end
        
        if((mantissa_64_mult[i-1]==1'b1) && (mantissa_64_mult[i]==1'b0)) begin 
            post_zeros = i-1;
            //$display ("mantissa[i-1]= %b , mantissa[i]= %b, i= %d, mantissa_64_mult=%b",  mantissa_64_mult[i-1],mantissa_64_mult[i],i,mantissa_64_mult);
        end
    end

    for(i=1;i<24;i=i+1) begin
        if((ain[i-1]==0) && (ain[i]==1) && first_a == 0) begin
            n1 = i;
            first_a = 1;
        end
        if((ain[i-1]==1) && (ain[i]==0)) m1 = i-1;

        if((bin[i-1]==0) && (bin[i]==1) && first_b == 0) begin
            n2 = i;
            first_b = 1;
        end
        if((bin[i-1]==1) && (bin[i]==0)) m2 = i-1;

    end

end

//$display("ain exp = %b ", ain[30:23]);
//$display("bin exp = %d ",bin[30:23]);

endmodule