
// Module: Arithmetic Logic Unit (ALU)
// Description:
// Performs arithmetic and logical operations based on the ALU control signal. Supported operations include AND, OR, ADD, SUB, SLT, and NOR. 
// Generates a Zero flag when the ALU result is equal to zero.


module alu(
    input  [31:0] a,
    input  [31:0] b,
    input  [3:0] alu_control,
    output reg [31:0] result,
    output zero
);

always @(*) begin
    case (alu_control)
        4'b0000: result = a & b;      // AND
        4'b0001: result = a | b;      // OR
        4'b0010: result = a + b;      // ADD
        4'b0110: result = a - b;      // SUB

        4'b0111: begin                // SLT (Signed Set Less Than)
            if ($signed(a) < $signed(b))
                result = 32'd1;
            else
                result = 32'd0;
        end
        4'b1100: result = ~(a | b);   // NOR
        default: result = 32'd0;
    endcase
end
// Zero flag is asserted when the ALU result is zero.
assign zero = (result == 32'd0);
endmodule
