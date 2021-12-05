
module neural_network #(parameter image_file = "picture_1.mem")( 
    output [10*32-1:0] result
    );
    wire [784*32-1:0] photo;
     
    /* This code essentially flattens the pixel values from the image */
    genvar p;
    generate
        for(p=0; p < 784; p = p+1) begin: parse_image
            memory #(.file(image_file), .num_of_inputs(50)) ph (
                .r_add(p),
                .w_out(photo[31+32*p:32*p])
            );
        end
    endgenerate

    wire [50*32-1:0] hidden_output;
    hidden_layer layer1 (
        .photo(photo),
        .data(hidden_output)
    );
    output_layer layer2 (
        .previous_layer(hidden_output),
        .data(result)
    );

endmodule