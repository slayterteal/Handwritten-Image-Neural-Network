/*
    To test the neuron I've hand made a few files
    so that it's easier to determine the output of the neuron
    by hand.

    Test Files:
        neuron_test_bias.mem
        neuron_test_weight.mem
        neuron_test_input.mem
*/
module neuron_tb;

    wire [2*32-1:0] image;
    wire [31:0] bias_value;
    wire [31:0] result;

    genvar p; // flatten the image data into a single value: image
    generate
        for(p=0; p < 2; p = p+1) begin: parse_image
            memory #(.file("neuron_test_input.mem"), .num_of_inputs(2), .nn(1)) ph (
                .r_add(p),
                .w_out(image[31+32*p:32*p])
            );
        end
    endgenerate

    memory #(.file("neuron_test_bias.mem"), .num_of_inputs(1), .nn(1)) bias (
        .r_add(0),
        .w_out(bias_value)
    );

    neuron #(.weight_file("neuron_test_weight.mem"), .num_of_weights(2), .neurons_in_layer(1)) n (
        .inputs(image),
        .bias_value(bias_value),
        .result(result)
    );


endmodule
