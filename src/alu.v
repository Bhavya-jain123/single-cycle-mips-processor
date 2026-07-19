
// Module: Arithmetic Logic Unit (ALU)
// Description:
// Performs arithmetic and logical operations based on the ALU control signal.
// Supported operations include AND, OR, ADD, SUB, XOR, NOR, SLT, and JR.
// Generates Zero and Overflow flags for branch decisions and signed arithmetic.

module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0] alu_control,
    output reg [31:0] result,
    output zero,
    output reg overflow
);

always @(*) begin

    overflow = 1'b0;                  // Default: no overflow

    case (alu_control)

        4'b0000: result = a & b;      // AND: Bitwise AND operation

        4'b0001: result = a | b;      // OR: Bitwise OR operation

        4'b0010: begin                // ADD: Perform signed addition
            result = a + b;
            // Detect signed overflow during addition
            overflow = (~(a[31] ^ b[31])) &
                       (result[31] ^ a[31]);
        end

        4'b0110: begin                // SUB: Perform signed subtraction
            result = a - b;
            // Detect signed overflow during subtraction
            overflow = (a[31] ^ b[31]) &
                       (result[31] ^ a[31]);
        end

        4'b0011: result = a ^ b;      // XOR: Bitwise Exclusive-OR operation

        4'b0111: begin                // SLT: Set result to 1 if a < b (signed comparison)
            if ($signed(a) < $signed(b))
                result = 32'd1;
            else
                result = 32'd0;
        end

        4'b1100: result = ~(a | b);   // NOR: Bitwise NOR operation

        4'b1110: begin                // JR: No ALU computation required; PC is updated separately
            result = 32'd0;
            overflow = 1'b0;
        end

        default: begin                // Invalid/unsupported ALU operation
            result = 32'd0;
        end

    endcase
end

assign zero = (result == 32'd0);      // Assert zero flag when ALU result equals zero

endmodule
