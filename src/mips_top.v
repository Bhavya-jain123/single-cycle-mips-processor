
// Module: Single-Cycle MIPS Processor (Top Module)
// Description:
// Integrates all datapath components of the 32-bit single-cycle MIPS processor, including the Program Counter, Instruction Memory, Control Unit, Register
// File, ALU, Data Memory, and Next PC logic. Coordinates instruction fetch, decode, execute, memory access, and write-back for each clock cycle.

module mips_top(

    input clk,
    input reset_n

);

//==================================================
//             Internal Signals
//==================================================

// PC
wire [31:0] pc;
wire [31:0] next_pc;
wire [31:0] pc_plus4;

// Instruction
wire [31:0] instruction;

// Register File
wire [31:0] read_data1;
wire [31:0] read_data2;

//================ Control Signals =================

wire RegDst;
wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;

wire BranchNE;
wire Jump;
wire JumpLink;
wire JumpReg;

wire [2:0] ALUOp;

//================ Additional Signals ==============

// Destination Register
wire [4:0] write_register;

// Immediate
wire [31:0] extended_immediate;
wire [31:0] immediate;

// ALU
wire [31:0] alu_input2;
wire [31:0] alu_result;
wire zero;
wire overflow;
wire [3:0] alu_control_signal;

// Data Memory
wire [31:0] memory_data;

// Write Back
wire [31:0] write_back_data;

// Branch
wire [31:0] shifted_immediate;
wire [31:0] branch_address;

// Jump
wire [31:0] jump_address;

// Invalid Instruction
wire InvalidOpcode;
wire InvalidInstruction;
wire invalid_instruction;

//==================================================
//             Program Counter (PC)
//==================================================

pc PC(

    .clk(clk),
    .reset_n(reset_n),
    .next_pc(next_pc),
    .pc(pc)

);

//==================================================
//            Instruction Memory
//==================================================

instruction_memory IM(

    .address(pc),
    .instruction(instruction)

);

//==================================================
//              Main Control Unit
//==================================================

control_unit CU(

    .opcode(instruction[31:26]),

    .RegDst(RegDst),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),

    .Branch(Branch),
    .BranchNE(BranchNE),

    .Jump(Jump),
    .JumpLink(JumpLink),

    .ALUOp(ALUOp),
    .InvalidOpcode(InvalidOpcode)

);

//==================================================
//               Register File
//==================================================

register_file RF(

    .clk(clk),
    .reset_n(reset_n),

    .reg_write(RegWrite),

    .read_reg1(instruction[25:21]),
    .read_reg2(instruction[20:16]),

    .write_reg(write_register),
    .write_data(write_back_data),

    .read_data1(read_data1),
    .read_data2(read_data2)

);

//==================================================
//           Immediate Extension
//==================================================

sign_extend SE(

    .immediate(instruction[15:0]),
    .extended_immediate(extended_immediate)

);

// Zero-extend immediates for ANDI and ORI.
// Sign-extend all other immediate instructions.

assign immediate =
    ((instruction[31:26] == 6'b001100) ||
     (instruction[31:26] == 6'b001101))
    ? {16'd0, instruction[15:0]}
    : extended_immediate;

//==================================================
//              ALU Control Unit
//==================================================

alu_control ALUCTRL(

    .ALUOp(ALUOp),
    .funct(instruction[5:0]),

    .alu_control(alu_control_signal),
    .JumpReg(JumpReg),
    .InvalidInstruction(InvalidInstruction)

);

//==================================================
//          ALU Operand Selection MUX
//==================================================
//
// sel:
// 00 -> Register operand
// 01 -> Immediate operand
//

mux4 ALU_SRC_MUX(

    .a(read_data2),
    .b(immediate),
    .c(32'd0),
    .d(32'd0),

    .sel({1'b0, ALUSrc}),

    .y(alu_input2)

);

//==================================================
//          Arithmetic Logic Unit
//==================================================

alu ALU(

    .a(read_data1),
    .b(alu_input2),

    .alu_control(alu_control_signal),

    .result(alu_result),
    .zero(zero),
    .overflow(overflow)

);

//==================================================
//               Data Memory
//==================================================

data_memory DM(

    .clk(clk),
    .reset_n(reset_n),

    .mem_write(MemWrite),
    .mem_read(MemRead),

    .address(alu_result),

    .write_data(read_data2),

    .read_data(memory_data)

);

//==================================================
//              PC + 4 Adder
//==================================================

adder PC_ADDER(

    .a(pc),
    .b(32'd4),

    .sum(pc_plus4)

);

//==================================================
//           Branch Address Calculation
//==================================================

// Shift the branch offset left by two bits to obtain
// the byte-aligned branch address.

assign shifted_immediate = immediate << 2;

adder BRANCH_ADDER(

    .a(pc_plus4),
    .b(shifted_immediate),

    .sum(branch_address)

);
//==================================================
//            Jump Address Calculation
//==================================================

// Construct the jump target address using the upper
// four bits of PC+4 and the 26-bit instruction field.

assign jump_address =
{
    pc_plus4[31:28],
    instruction[25:0],
    2'b00
};

//==================================================
//      Destination Register Selection MUX
//==================================================
//
// sel:
// 00 -> rt
// 01 -> rd
// 10 -> $31 (JAL)
// 11 -> Unused
//

wire [31:0] write_register_ext;

mux4 DEST_MUX(

    .a({27'd0, instruction[20:16]}),
    .b({27'd0, instruction[15:11]}),
    .c(32'd31),
    .d(32'd0),

    .sel({JumpLink, RegDst}),

    .y(write_register_ext)

);

assign write_register = write_register_ext[4:0];

//==================================================
//            Write-Back Data MUX
//==================================================
//
// sel:
// 00 -> ALU Result
// 01 -> Memory Data
// 10 -> PC + 4 (JAL)
// 11 -> Unused
//

mux4 WB_MUX(

    .a(alu_result),
    .b(memory_data),
    .c(pc_plus4),
    .d(32'd0),

    .sel({JumpLink, MemtoReg}),

    .y(write_back_data)

);

//==================================================
//        Invalid Instruction Detection
//==================================================

// Combine invalid opcode and invalid function detection.

assign invalid_instruction =
    InvalidOpcode || InvalidInstruction;

//==================================================
//             Next PC Selection Logic
//==================================================

// Priority:
// 1. Invalid instruction
// 2. Arithmetic overflow
// 3. JR
// 4. J / JAL
// 5. BEQ / BNE
// 6. Sequential execution (PC + 4)

assign next_pc =

    invalid_instruction ? pc :

    overflow ? pc :

    JumpReg ? read_data1 :

    Jump ? jump_address :

    (Branch && zero) ? branch_address :

    (BranchNE && !zero) ? branch_address :

    pc_plus4;

endmodule
