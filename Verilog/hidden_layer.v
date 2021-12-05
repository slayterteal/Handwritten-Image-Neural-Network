
module hidden_layer 
    #(parameter weightFile="hidden_layer_weight.mem", 
        biasFile="hidden_layer_bias.mem")
    (input [784*32-1:0] photo, // 784 pixels, each value is 32 bits 
    output [50*32-1:0] data);
    
    wire [31:0] bias_value [50:0]; 

    genvar i;
    generate
        for(i=0; i<50; i = i + 1) begin: neuron
            memory #(.file("hidden_layer_bias.mem"), .num_of_inputs(50)) m (
                .r_add(i),
                .w_out(bias_value[i])
            );
            neuron #(.weight_file("hidden_layer_weight.mem"), .num_of_weights(784)) n(
                .inputs(photo),
                .bias_value(bias_value[i]),
                .result(data[31+32*i:32*i])
            );
        end  
    endgenerate

endmodule
