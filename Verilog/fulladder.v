
module fulladder(input x, input y, input c_in, output c_out, output result);

	assign result = (x ^ y) ^ c_in;
	assign c_out = (x & y) | (x & c_in) | (y & c_in); 

endmodule
