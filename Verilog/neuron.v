
// this is where things get wild...
module neuron 
	#(parameter weight_file="", num_of_weights=784)
	(
		input [784*32-1:0] inputs,
		input [31:0] bias_value,
		output [31:0] result
	);

	reg [31:0] read_address;
	wire [31:0] weight_value;

	memory#(.file(weight_file),.numOfInputs(num_of_weights)) weight_memory (
		.r_add(read_address),
		.w_out(weight_value)
	);

	genvar i;
	generate
		for(i = 0; i < num_of_weights; i = i+1) begin: cal
			/*
				mul = weight_value*input
				sum = sum + mul - use the adder

			*/
		end
	endgenerate

	// output = mul.sum() + bias

endmodule
