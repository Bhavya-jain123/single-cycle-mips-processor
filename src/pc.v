// Module: Program Counter (PC)
// Description:
// Holds the address of the current instruction.
// On every rising edge of the clock, the PC is updated with the next instruction address.
// An active-low asynchronous reset initializes the PC to 0x00000000.

module pc(
    input clk,
    input reset_n,
    input [31:0] next_pc,
    output reg [31:0] pc
);
always @(posedge clk or negedge reset_n)
begin
    if(!reset_n)
        pc <= 32'd0;
    else
        pc <= next_pc;
end
endmodule
