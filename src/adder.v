
// Module: Adder
// Description:
// Performs 32-bit addition of two input operands.
// This module is used in the MIPS datapath for operations such as PC + 4 and branch target address calculation.

module adder(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum
);
  
assign sum = a + b;

endmodule
