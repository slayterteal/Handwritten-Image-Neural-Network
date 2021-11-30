
module multiplier_tb;
	reg [31:0] x, y;
	wire [31:0] result;

	multiplier m (.x(x), .y(y), .result(result));

	initial begin
		assign x = 4;
		assign y = 2;
		#20;
		assign x = 32'h0000_0435;
		assign y = 32'h0000_0435;
		#20
		assign x = 32'h7ff0_0435;
		assign y = 32'h8000_0435;
		#20
		assign x = 32'hffff_ff18;
		assign y = 32'h0000_0435;
		#20
		assign x = 32'hffff_fffe;
		assign y = 32'h0000_0002;
	end

endmodule
