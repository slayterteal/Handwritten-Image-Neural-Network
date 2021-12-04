

module relu_tb;
reg [31:0] x;
wire [31:0] y;

relu r (.x(x), .y(y));

initial begin

x = 32'h0000_0000;
#20
x = 32'h0000_0003;
#20
x = 32'hff00_0000;

end

endmodule
