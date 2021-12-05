 
module memory_tb;

reg [31:0] read_address;
wire signed [31:0] data;

memory #(.file("output_layer_bias.mem"), .num_of_inputs(10)) m 
    (.r_add(read_address), 
    .w_out(data));

initial begin
read_address = 32'h00000001;
#100
read_address = 32'h00000002;
#100
read_address = 9;

end

endmodule 
