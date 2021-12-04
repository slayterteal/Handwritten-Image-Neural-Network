
// I'm using a handmade file to test this. 
module memory_tb;

reg [31:0] read_address;
wire [31:0] data;

memory #("mem_test.txt", 5) m (.read_add(read_address), .write_out(data));

initial begin
read_address = 5'b00001;
#10
read_address = 5'b00010;

end

endmodule 
