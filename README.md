# 32-bit Single-Cycle MIPS Processor using Verilog HDL

This Project demonstates a 32-bit Single-Cycle MIPS Processor designed and implemented in **Verilog HDL** using **Xilinx Vivado**. The processor executes each instruction in a single clock cycle by integrating the datapath and control unit into a complete processor architecture.

This project demonstrates the implementation of the fundamental components of a MIPS processor, including the Program Counter, Instruction Memory, Register File, Arithmetic Logic Unit (ALU), Data Memory, Control Unit, ALU Control Unit, multiplexers, adders, and branch logic. Functional verification was carried out through behavioral simulation using a custom testbench.

---

## Features

- Designed individual hardware modules and integrated them into a complete processor
- Integrated datapath and control path architecture
- Supports arithmetic, logical, memory access, immediate, and branch instructions
- Functional verification using behavioral simulation
- Well-documented and reusable Verilog modules
- Machine-code based instruction execution using instruction memory

---

## Supported Instructions

| Instruction Type | Instructions |
|------------------|--------------|
| Arithmetic | `add`, `sub`, `addi` |
| Logical | `and`, `or` |
| Comparison | `slt` |
| Memory Access | `lw`, `sw` |
| Branch | `beq` |

---

## Processor Architecture

The processor consists of the following major modules:

- Program Counter (PC)
- Instruction Memory
- Main Control Unit
- Register File
- Sign Extension Unit
- ALU Control Unit
- Arithmetic Logic Unit (ALU)
- Data Memory
- Multiplexers
- Adders
- Branch Address Generation Logic
- Top-Level Processor Integration Module

Each module was designed independently and then integrated to implement the complete single-cycle processor.

---

##  Project Structure

```text
single-cycle-mips-processor/
│
├── src/
│   ├── pc.v                  // Implements the Program Counter (PC)
│   ├── instruction_memory.v  // Stores the machine code instructions
│   ├── control_unit.v        // Generates the control signals for the processor
│   ├── register_file.v       // Implements the 32-bit register file
│   ├── sign_extend.v         // Extends 16-bit immediate values to 32 bits
│   ├── alu_control.v         // Generates the ALU control signals
│   ├── alu.v                 // Performs arithmetic and logical operations
│   ├── data_memory.v         // Implements the data memory module
│   ├── mux.v                 // Implements the multiplexers used in the datapath
│   ├── adder.v               // Implements the 32-bit adders used in the datapath
│   └── mips_top.v            // Top-level module integrating all processor components
│
├── sim/
│   ├── tb_mips.v             // Testbench for processor verification
│   └── instructions.mem      // Machine code program for simulation
│
├── images/
│   ├── datapath.png          // Processor datapath diagram
│   ├── rtl.png               // RTL schematic generated in Vivado
│   └── waveform.png          // Simulation waveform
│
└── README.md                 // Project documentation
```

---

## Datapath Execution Flow

Each instruction is executed in a single clock cycle through the following stages:

1. Fetch the instruction from Instruction Memory.
2. Decode the instruction and generate the required control signals.
3. Read source operands from the Register File.
4. Perform arithmetic or logical operations using the ALU if required by the instruction.
5. Access Data Memory for load and store instructions.
6. Write the result back to the Register File if required by the instruction.
7. Update the Program Counter to the next sequential or branch address.

---

## Verification

A custom Verilog testbench was developed to verify the processor functionality.

The test program stored in `instructions.mem` validates:

- Arithmetic operations (`add`, `sub`, `addi`)
- Logical operations (`and`, `or`)
- Comparison operation (`slt`)
- Load (`lw`) and Store (`sw`) instructions
- Branch Equal (`beq`)
- Register write-back
- Data memory read/write operations
- Program Counter update logic

Simulation waveforms confirmed the correct execution of all supported instructions.

---

## Sample Program

The processor executes machine-code instructions stored in `instructions.mem`.

Example program:

```assembly
addi $t0, $zero, 10
addi $t1, $zero, 20
add  $t3, $t0, $t1
sw   $t3, 0($zero)
lw   $s2, 0($zero)
beq  $s2, $t3, LABEL
```

---

## Simulation Results

The processor was successfully verified through behavioral simulation.

Simulation validates:

- Correct ALU operations
- Proper control signal generation
- Register file read/write operations
- Data memory access
- Branch execution
- Correct Program Counter updates

> **Note:** Simulation waveforms and RTL schematic are provided in the `images` directory.

---

## Future Improvements

Possible extensions to this processor include:

- Support for additional MIPS instructions like Jump (`j`) and Jump-and-Link (`jal`) instructions
- 5-stage pipelined MIPS architecture
- FPGA implementation and hardware validation

---

## Tools Used


- Xilinx Vivado

---
## Author

**Bhavya Jain**

B.Tech, Integrated Circuit Design and Technology (ICDT)  
Indian Institute of Technology Gandhinagar
