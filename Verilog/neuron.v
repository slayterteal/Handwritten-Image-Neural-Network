module neuron 
	#(parameter weight_file="", num_of_weights=784)
	(
		input [784*32-1:0] inputs,
		input [31:0] bias_value,
		output [31:0] result
	);

	wire [31:0] weight_value [783:0];
	wire [31:0] multiply_results [783:0];

	genvar i;
	generate
		for(i = 0; i < num_of_weights; i = i+1) begin: mul
			memory#(.file(weight_file),.num_of_inputs(num_of_weights)) weight_memory (
				.r_add(i),
				.w_out(weight_value[i])
			);
			assign multiply_results[i] = weight_value[i] * inputs[31+32*i:32*i];	
		end
	endgenerate

	// multiply result summation
	wire [31:0] summation [781:0];
	wire carry_out;
	wire [31:0] summation_result;
	genvar j;
	generate
		assign summation[0] = multiply_results[0] + multiply_results[1];
		for(j=0; j < 781; j = j + 1) begin: sum
			adder s (.x(summation[j]), 
				.y(multiply_results[j+2]),
				.c_in(1'b0),
				.c_out(carry_out),
				.sum(summation[j+1]));
		end
	endgenerate
	assign summation_result = summation[781];
	wire signbit;
	assign signbit = ($signed(summation_result) > 0); // 1 if pos, 0 if neg

	wire [31:0] temp_result;
	adder bias (.x(bias_value), 
		.y(summation_result),
		.c_in(1'b0),
		.c_out(carry_out),
		.sum(temp_result));
	
	// checking for positive or negative overflow
	assign temp_result = carry_out ? 
		(signbit ? 32'h7fff_ffff : 32'h8000_0000) 
		: temp_result; 
	
	relu final (.x(temp_result), .y(result)); // return result

endmodule
