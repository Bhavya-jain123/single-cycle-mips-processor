
// Module: Main Control Unit
// Description:
// Decodes the opcode field of the instruction and generates the control signals required for the datapath. 

module control_unit(

    input [5:0] opcode,          // Instruction opcode

    output reg RegDst,           // Selects destination register (rd/rt)
    output reg ALUSrc,           // Selects ALU second operand (register/immediate)
    output reg MemtoReg,         // Selects data written back to the register
    output reg RegWrite,         // Enables write to register file 
    output reg MemRead,          // Enables data memory read
    output reg MemWrite,         // Enables data memory write
    output reg Branch,           // Enables branch decision further used in beq
    output reg [1:0] ALUOp       // Specifies ALU operation type
);

always @(*) begin

    // Default values
    RegDst   = 0;
    ALUSrc   = 0;
    MemtoReg = 0;
    RegWrite = 0;
    MemRead  = 0;
    MemWrite = 0;
    Branch   = 0;
    ALUOp    = 2'b00;

    case(opcode)

        // R-Type
        6'b000000: begin
            RegDst   = 1;
            RegWrite = 1;
            ALUOp    = 2'b10;
        end

        // lw
        6'b100011: begin
            ALUSrc   = 1;
            MemtoReg = 1;
            RegWrite = 1;
            MemRead  = 1;
        end

        // sw
        6'b101011: begin
            ALUSrc   = 1;
            MemWrite = 1;
        end

        // beq
        6'b000100: begin
            Branch = 1;
            ALUOp  = 2'b01;
        end

        // addi
        6'b001000: begin
            ALUSrc   = 1;
            RegWrite = 1;
        end

    endcase

end

endmodule
