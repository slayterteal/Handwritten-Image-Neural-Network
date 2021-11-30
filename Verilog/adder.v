
// this is a 32 bit carry look ahead adder
module adder (input [31:0] x, input [31:0] y, input c_in, output c_out, output [31:0] sum);

wire [31:0] gen;
wire [31:0] pro;
wire [32:0] carry_tmp;

genvar j, i;
generate
 //assume carry_tmp in is zero
 assign carry_tmp[0] = c_in;
 
 //carry generator
 for(j = 0; j < 32; j = j + 1) begin: carry_generator
 assign gen[j] = x[j] & y[j];
 assign pro[j] = x[j] | y[j];
 assign carry_tmp[j+1] = gen[j] | pro[j] & carry_tmp[j];
 end
 //carry out 
 assign c_out = carry_tmp[32];
 //calculate sum 
 //assign sum[0] = in1[0] ^ in2 ^ carry_in;
 for(i = 0; i < 32; i = i+1) begin: sum_without_carry
 assign sum[i] = x[i] ^ y[i] ^ carry_tmp[i];
 end 
endgenerate
endmodule
