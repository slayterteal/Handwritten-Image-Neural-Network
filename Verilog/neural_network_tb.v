
module neural_network_tb;

    wire [10*32-1:0] network_output;
    wire [31:0] network_result [9:0];

    genvar i;
    generate
        for(i = 0; i < 10; i = i + 1) begin: parse_output
            assign network_result[i] = network_output[31+32*i:32*i];
        end
    endgenerate

    neural_network #(.image_file("picture_1.mem")) nn (
        .result(network_output)
    );

endmodule