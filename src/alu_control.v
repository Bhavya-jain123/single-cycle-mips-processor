
// Module: ALU Control Unit
// Description:
// Generates the ALU control signal based on the ALUOp field from the Control Unit and the function field of R-type instructions. 
// Also identifies JR instructions and flags invalid or unsupported operations.

module alu_control(

    input [2:0] ALUOp,
    input [5:0] funct,

    output reg [3:0] alu_control,
    output reg JumpReg,
    output reg InvalidInstruction

);

always @(*) begin

    // Default outputs
    alu_control = 4'b1111;      // Default to invalid operation
    JumpReg = 1'b0;
    InvalidInstruction = 1'b0;

    case(ALUOp)

        // Immediate addition (LW, SW, ADDI)
        3'b000: begin
            alu_control = 4'b0010;
        end

        // Subtraction (BEQ, BNE)
        3'b001: begin
            alu_control = 4'b0110;
        end

        // Decode R-type instructions using the function field
        3'b010: begin

            case(funct)

                6'b100000: alu_control = 4'b0010; // ADD

                6'b100010: alu_control = 4'b0110; // SUB

                6'b100100: alu_control = 4'b0000; // AND

                6'b100101: alu_control = 4'b0001; // OR

                6'b100110: alu_control = 4'b0011; // XOR

                6'b100111: alu_control = 4'b1100; // NOR

                6'b101010: alu_control = 4'b0111; // SLT

                6'b001000: begin                  // JR
                    JumpReg = 1'b1;
                    alu_control = 4'b1110;        // No ALU operation required
                end

                default: begin
                    // Unsupported R-type instruction
                    InvalidInstruction = 1'b1;
                    alu_control = 4'b1111;
                end

            endcase

        end

        // AND Immediate
        3'b011: begin
            alu_control = 4'b0000;
        end

        // OR Immediate
        3'b100: begin
            alu_control = 4'b0001;
        end

        // Set Less Than Immediate
        3'b101: begin
            alu_control = 4'b0111;
        end

        // Invalid ALUOp code
        default: begin
            InvalidInstruction = 1'b1;
            alu_control = 4'b1111;
        end

    endcase

end

endmodule
