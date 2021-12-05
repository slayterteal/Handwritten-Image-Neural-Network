// accesses a value in memory based on inputs. 
// file = the weight file that we are reading
// numOfInputs = tells us how many "things" of data we're reading in. 
// we only need to READ from memory, nothing more. 
module memory #(parameter file="", num_of_inputs=784)
(input [31:0] r_add, output [31:0] w_out);

    // numOfInputs is used to tell us the depth of our mem
    reg [31:0] mem [num_of_inputs-1:0];
    initial begin
        $readmemh(file, mem); // read from the file, store into mem.
    end
    assign w_out = mem[r_add];

endmodule
