
// Module: Register File
// Description:
// Implements 32 registers each 32 bits wide for the MIPS processor. 
// Here, as of now all the registers can be modifiable but in real MIPS processor some registers are reserved and cannot be used.
// Supports two asynchronous read ports and one synchronous write port. 
// Register $zero (R0) is hardwired to zero and cannot be modified. 
// An active-low asynchronous reset initializes all registers to zero.

module register_file(
    input clk,
    input reset_n,
    input reg_write,

    input [4:0] read_reg1,
    input [4:0] read_reg2,
    input [4:0] write_reg,

    input [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2
);
    // 32 general-purpose registers, each 32 bits wide
    reg [31:0] registers [0:31];
    integer i;

    // Synchronous write and asynchronous reset
    always @(posedge clk or negedge reset_n)
    begin
        if(!reset_n)
        begin
            // Reset all registers to zero
            for(i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else if(reg_write && (write_reg != 5'd0))
        begin
            // Write data into the destination register except register R0 ($zero)
            registers[write_reg] <= write_data;
        end
    end

    // Asynchronous read ports
    assign read_data1 = (read_reg1 == 5'd0) ? 32'd0 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'd0 : registers[read_reg2];
  
endmodule
