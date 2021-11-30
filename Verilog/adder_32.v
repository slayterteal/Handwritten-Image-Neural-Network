module adder_32(x, y, c_out, result);
	input [31:0] x, y;
	output c_out;
	output [31:0] result;
	
	wire [31:0] carry;

	genvar i;
	generate
		for (i=0; i < 32; i=i+1)
			begin: generate_adder_32
				if(i==0) halfadder f(x[0], y[0], carry[0], result[0]);
				else fulladder f(x[i], y[i], carry[i-1], carry[i], result[i]);
			end
		assign c_out = carry[31];
	endgenerate
endmodule
