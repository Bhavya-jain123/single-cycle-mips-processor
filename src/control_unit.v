
// Module: Main Control Unit
// Description:
// Decodes the instruction opcode and generates the control signals required for the datapath. 
// Supports R-type, memory access, branch, immediate, jump, and jump-and-link instructions. 
// Flags invalid or unsupported opcodes.

module control_unit(

    input [5:0] opcode,

    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg BranchNE,
    output reg Jump,
    output reg JumpLink,

    output reg [2:0] ALUOp,

    output reg InvalidOpcode

);

always @(*) begin

    // Default control signals
    RegDst = 0;
    ALUSrc = 0;
    MemtoReg = 0;
    RegWrite = 0;
    MemRead = 0;
    MemWrite = 0;
    Branch = 0;
    BranchNE = 0;
    Jump = 0;
    JumpLink = 0;

    ALUOp = 3'b000;
    InvalidOpcode = 0;

    case(opcode)

        // Decode R-type instructions
        6'b000000: begin
            RegDst = 1;
            RegWrite = 1;
            ALUOp = 3'b010;
        end

        // Load Word (LW)
        6'b100011: begin
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead = 1;
            ALUOp = 3'b000;
        end

        // Store Word (SW)
        6'b101011: begin
            ALUSrc = 1;
            MemWrite = 1;
            ALUOp = 3'b000;
        end

        // Branch if Equal (BEQ)
        6'b000100: begin
            Branch = 1;
            ALUOp = 3'b001;
        end

        // Branch if Not Equal (BNE)
        6'b000101: begin
            BranchNE = 1;
            ALUOp = 3'b001;
        end

        // Add Immediate (ADDI)
        6'b001000: begin
            ALUSrc = 1;
            RegWrite = 1;
            ALUOp = 3'b000;
        end

        // AND Immediate (ANDI)
        6'b001100: begin
            ALUSrc = 1;
            RegWrite = 1;
            ALUOp = 3'b011;
        end

        // OR Immediate (ORI)
        6'b001101: begin
            ALUSrc = 1;
            RegWrite = 1;
            ALUOp = 3'b100;
        end

        // Set Less Than Immediate (SLTI)
        6'b001010: begin
            ALUSrc = 1;
            RegWrite = 1;
            ALUOp = 3'b101;
        end

        // Jump (J)
        6'b000010: begin
            Jump = 1;
        end

        // Jump and Link (JAL)
        6'b000011: begin
            Jump = 1;
            JumpLink = 1;
            RegWrite = 1;
        end

        // Unsupported opcode
        default: begin
            InvalidOpcode = 1;
        end

    endcase

end

endmodule
