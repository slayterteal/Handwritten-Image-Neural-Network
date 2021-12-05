
module memory #(parameter file="", num_of_inputs=784, nn=50)
(input [31:0] r_add, output signed [31:0] w_out);

    // numOfInputs is used to tell us the depth of our mem
    reg signed [31:0] mem [num_of_inputs*nn-1:0];
    initial begin
        $readmemh(file, mem); // read from the file, store into mem.
    end
    assign w_out = (mem[r_add]);

endmodule
