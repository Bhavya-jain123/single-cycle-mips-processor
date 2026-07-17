
// Module: Top-Level MIPS Processor
// Description:
// Integrates all datapath and control modules to
// implement a 32-bit single-cycle MIPS processor.

module mips_top(

    input clk,
    input reset_n

);

//==================================================
//                WIRES
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

// Control Signals
wire RegDst;
wire ALUSrc;
wire MemtoReg;
wire RegWrite;
wire MemRead;
wire MemWrite;
wire Branch;
wire [1:0] ALUOp;

//==================================================
//                PROGRAM COUNTER
//==================================================

pc PC(

    .clk(clk),
    .reset_n(reset_n),
    .next_pc(next_pc),
    .pc(pc)

);

//==================================================
//             INSTRUCTION MEMORY
//==================================================

instruction_memory IM(
    .address(pc),
    .instruction(instruction)
);

//==================================================
//               CONTROL UNIT
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
    .ALUOp(ALUOp)

);

//==================================================
// Additional Wires
//==================================================

// Destination register
wire [4:0] write_register;

// Sign Extension
wire [31:0] extended_immediate;

// ALU
wire [31:0] alu_input2;
wire [31:0] alu_result;
wire zero;
wire [3:0] alu_control_signal;

// Data Memory
wire [31:0] memory_data;

// Write Back
wire [31:0] write_back_data;

//Used in pc realted function 
wire [31:0] branch_address;
wire [31:0] shifted_immediate;
  
//==================================================
// Register File
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
// Sign Extend
//==================================================

sign_extend SE(

    .immediate(instruction[15:0]),
    .extended_immediate(extended_immediate)

);

//==================================================
// ALU Control
//==================================================

alu_control ALUCTRL(

    .ALUOp(ALUOp),
    .funct(instruction[5:0]),
    .alu_control(alu_control_signal)

);

//==================================================
// ALU Source MUX
//==================================================

mux ALU_MUX(

    .a(read_data2),
    .b(extended_immediate),

    .sel(ALUSrc),

    .y(alu_input2)

);

//==================================================
// ALU
//==================================================

alu ALU(

    .a(read_data1),
    .b(alu_input2),

    .alu_control(alu_control_signal),

    .result(alu_result),

    .zero(zero)

);

//==================================================
// Data Memory
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
// Destination Register MUX
//==================================================

assign write_register = (RegDst) ? instruction[15:11] : instruction[20:16];

//==================================================
// Write Back MUX
//==================================================

assign write_back_data =
        (MemtoReg) ? memory_data : alu_result;
        
//==================================================
// PC + 4
//==================================================

adder PC_ADDER(

    .a(pc),
    .b(32'd4),

    .sum(pc_plus4)

);
//used for beq functions where we need to jump to certain place 
assign shifted_immediate = extended_immediate << 2;

//Normal pc+4 
adder BRANCH_ADDER(

    .a(pc_plus4),
    .b(shifted_immediate),
    .sum(branch_address)

);
//For choosing next pc:
assign next_pc =
        (Branch && zero) ? branch_address : pc_plus4;

endmodule
