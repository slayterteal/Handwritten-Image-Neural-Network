module neuron 
	#(parameter weight_file="", num_of_weights=784, neurons_in_layer=50)
	(
		input [num_of_weights*32-1:0] inputs,
		input [31:0] bias_value,
		output [31:0] result
	);

	wire [31:0] weight_value [num_of_weights-1:0];
	wire [31:0] multiply_results [num_of_weights-1:0];

	genvar i;
	generate
		for(i = 0; i < num_of_weights; i = i+1) begin: mul
			memory#(.file(weight_file),.num_of_inputs(num_of_weights), .nn(neurons_in_layer)) weight_memory (
				.r_add(i),
				.w_out(weight_value[i])
			);
			// multiplier m (.x(weight_value[i]),
			// 	.y(inputs[31+32*i:32*i]),
			// 	.result(multiply_results[i]));
			assign multiply_results[i] = weight_value[i] * inputs[31+32*i:32*i];	
		end
	endgenerate

	// multiply result summation
	wire [31:0] summation [num_of_weights-2:0];
	wire carry_out;
	wire [31:0] summation_result;
	genvar j;
	generate
		assign summation[0] = multiply_results[0] + multiply_results[1];
		for(j=0; j < num_of_weights-2; j = j + 1) begin: sum
			adder s (.x(summation[j]), 
				.y(multiply_results[j+2]),
				.c_in(1'b0),
				.c_out(carry_out),
				.sum(summation[j+1]));
		end
	endgenerate
	assign summation_result = summation[num_of_weights-2];
	wire signbit;
	assign signbit = ($signed(summation_result) > 0); // 1 if pos, 0 if neg

	wire [31:0] temp;
	adder add_bias (.x(bias_value), 
		.y(summation_result),
		.c_in(1'b0),
		.c_out(carry_out),
		.sum(temp));
	
	// checking for positive or negative overflow
	wire [31:0] overflow_type;
	wire [31:0] temp_result;
	assign overflow_type = signbit ? 32'h7fff_ffff : 32'h8000_0000;
	assign temp_result = carry_out ? overflow_type : temp; 
	
	relu final (.x(temp_result), .y(result)); // return result

endmodule
