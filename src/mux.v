
// Module: 2-to-1 Multiplexer (MUX)
// Description:
// Selects one of two 32-bit input signals based on the select signal. 
// This module is used throughout the MIPS datapath for operations such as selecting the ALU operand, destination register, write-back
// data, and next Program Counter source.

module mux(
    input [31:0] a,
    input [31:0] b,
    input sel,
    output [31:0] y
);

assign y = (sel) ? b : a;

endmodule
