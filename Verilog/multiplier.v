
// this is a 32 bit carry look ahead multiplier
module multiplier (
	input [31:0] x, 
	input [31:0] y, 
	output [31:0] result);

wire [31:0] x_tmp [31:0];
wire [31:0] temp_product [31:0]; 
wire [31:0] carry;
wire [63:0] product;

genvar i,j;
generate 
	for(j = 0; j < 32; j = j + 1) begin: carry_generation
		assign x_tmp[j] =  x & {32{y[j]}};
	end
	
	assign temp_product[0] = x_tmp[0];
	assign carry[0] = 1'b0;
	assign product[0] = temp_product[0][0];

	for(i = 1; i < 32; i = i + 1) begin: multiplier
		adder add (
			.x(x_tmp[i]),
			.y({carry[i-1],temp_product[i-1][31-:31]}),
			.c_in(1'b0),
			.c_out(carry[i]),
			.sum(temp_product[i]));

		assign product[i] = temp_product[i][0];
	end 

	assign product[63:32] = {carry[31],temp_product[31][31-:31]};
endgenerate
// testing for a specific overflow
// 1 for pos_overflow, 0 for neg_overflow
wire [63:0] frac_shift = product>>>16;
wire overflow_type = ((($signed(x)>0)&&($signed(y)>0))||(($signed(x)<0)&&(y<0))) ? 1'b1 : 1'b0;
wire is_overflow = frac_shift[63:32] > 32'h0000_0001; 
wire [31:0] overflow_result = overflow_type ? 32'h7fff_ffff : 32'h8000_0000;

// truncated multiplication result
// given the numbers I'm working with, every operation "should" be
// able to fit into a 32 bit number.
assign result[31:0] = is_overflow ? overflow_result : frac_shift[31:0]; 

endmodule

