
module hiddenLayer 
    #(parameter weightFile="hidden_layer_weight.mem", 
        biasFile="hidden_layer_bias.mem")
    (input ready, 
    input [784*32-1:0] photo, // 784 pixels, each value is 32 bits
    output outValid,  
    output [50*32-1:0] data);

    reg [31:0] read_address;
    wire [31:0] bias_value; 

    memory #(.file("hidden_layer_bias.mem"), .num_of_inputs(50)) m (
        .r_add(read_address),
        .w_out(bias_value)
    );
    
    genvar i;
    generate
        if(ready) begin: readyCheck
            for(i=0; i<50; i = i + 1) begin: neuron
                neuron #(.weight_file("hidden_layer_weight.mem"), .num_of_weights(784)) n();
            end 
        end    
    endgenerate

endmodule
