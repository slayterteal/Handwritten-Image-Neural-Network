module output_layer 
    #(parameter weightFile="output_layer_weight.mem", 
        biasFile="output_layer_bias.mem")
    (input [50*32-1:0] previous_layer, // 1 data point from each node, each point is 32 bits 
    output [10*32-1:0] data);

    wire [31:0] bias_value [50:0]; 

    genvar i;
    generate
        for(i=0; i < 10; i = i + 1) begin: neuron
            memory #(.file("output_layer_bias.mem"), .num_of_inputs(10)) m (
                .r_add(i),
                .w_out(bias_value[i])
            );
            neuron #(.weight_file("output_layer_weight.mem"), .num_of_weights(50)) n(
                .inputs(photo),
                .bias_value(bias_value[i]),
                .result(data[31+32*i:32*i])
            );
        end  
    endgenerate

endmodule
