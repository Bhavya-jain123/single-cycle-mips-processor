
// Data Memory Module
// Description:
// Implements a 256 × 32-bit data memory for the MIPS processor. 
// Supports synchronous write operations, asynchronous read operations, and an active-low asynchronous reset that initializes all memory
// locations to zero.

module data_memory(
    input clk,
    input reset_n,
    input mem_write,
    input mem_read,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);
    // 256-word data memory, each word is 32 bits wide
    reg [31:0] memory [0:255];

    integer i;

    // Synchronous write and asynchronous reset
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n)
        begin
            // Initialize all memory locations to zero
            for(i = 0; i < 256; i = i + 1)
                memory[i] <= 32'd0;
        end
        else if(mem_write)
        begin
            // Write data into memory
            memory[address[9:2]] <= write_data;
        end
    end
  
    // Asynchronous read operation
    assign read_data = (mem_read) ? memory[address[9:2]] : 32'd0;

endmodule
