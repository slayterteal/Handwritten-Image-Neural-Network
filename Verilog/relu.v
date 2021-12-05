
// relu activation function. If x is negative return 0, else return x
// y = max(0, x)
module relu(input [31:0] x, output [31:0] y);

assign y = ($signed(x) > 0) ? x : 32'h0000_0000;

endmodule
