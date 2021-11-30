module halfadder(x, y, c_out, result);
	input x, y;
	output c_out, result;

	assign result = x ^ y;
	assign c_out = x & y;	

endmodule
