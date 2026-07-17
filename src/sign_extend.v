
// Module: Sign Extension Module
// Description:
// Extends a 16-bit immediate value to a 32-bit signed value by replicating the sign bit (MSB). 
// This module is used for I-type instructions such as addi, lw, sw, and beq.

module sign_extend(
    input  [15:0] immediate,
    output [31:0] extended_immediate
);

assign extended_immediate = {{16{immediate[15]}}, immediate};

endmodule
