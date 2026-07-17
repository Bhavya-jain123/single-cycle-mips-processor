
// Module: ALU Control Unit
// Description:
// Generates the control signal for the ALU based on the ALUOp signal from the Main Control Unit and the function field of R-type instructions.

module alu_control(

    input [1:0] ALUOp,           // ALU operation type from Main Control Unit
    input [5:0] funct,           // Function field for R-type instructions

    output reg [3:0] alu_control // Control signal that determines the ALU operation

);

always @(*) begin

    case(ALUOp)

        // lw, sw, addi → Perform addition
        2'b00:
            alu_control = 4'b0010;

        // beq → Perform subtraction for comparison
        2'b01:
            alu_control = 4'b0110;

        // R-type instructions
        2'b10:
        begin
            case(funct)

                6'b100000: alu_control = 4'b0010; // ADD
                6'b100010: alu_control = 4'b0110; // SUB
                6'b100100: alu_control = 4'b0000; // AND
                6'b100101: alu_control = 4'b0001; // OR
                6'b101010: alu_control = 4'b0111; // SLT

                // Unsupported R-type instruction
                default:
                    alu_control = 4'b1111;

            endcase
        end

        // Unsupported ALUOp
        default:
            alu_control = 4'b1111;

    endcase

end

endmodule
