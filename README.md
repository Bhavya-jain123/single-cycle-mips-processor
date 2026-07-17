# 32-bit Single-Cycle MIPS Processor using Verilog HDL

A 32-bit Single-Cycle MIPS Processor designed and implemented in **Verilog HDL** using **Xilinx Vivado**. The processor executes each instruction in a single clock cycle by integrating the datapath and control unit into a complete processor architecture.

This project demonstrates the implementation of the fundamental components of a MIPS processor, including the Program Counter, Instruction Memory, Register File, Arithmetic Logic Unit (ALU), Data Memory, Control Unit, ALU Control Unit, multiplexers, adders, and branch logic. Functional verification was carried out through behavioral simulation using a custom testbench.

---

## Features

- Designed a 32-bit Single-Cycle MIPS Processor in Verilog HDL
- Modular RTL implementation with independently developed components
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

## Project Structure

```text
single-cycle-mips-processor/
│
├── src/
│   ├── pc.v
│   ├── instruction_memory.v
│   ├── control_unit.v
│   ├── register_file.v
│   ├── sign_extend.v
│   ├── alu_control.v
│   ├── alu.v
│   ├── data_memory.v
│   ├── mux.v
│   ├── adder.v
│   └── mips_top.v
│
├── sim/
│   ├── tb_mips.v
│   └── instructions.mem
│
├── images/
│   ├── datapath.png
│   ├── rtl.png
│   └── waveform.png
│
└── README.md
```

---

## Datapath Execution Flow

Each instruction is executed in a single clock cycle through the following stages:

1. Fetch the instruction from Instruction Memory.
2. Decode the instruction and generate the required control signals.
3. Read source operands from the Register File.
4. Perform arithmetic or logical operations using the ALU.
5. Access Data Memory for load and store instructions.
6. Write the result back to the Register File.
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

## Tools Used

- Verilog HDL
- Xilinx Vivado
- Behavioral Simulation

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

- 5-stage pipelined MIPS architecture
- Hazard Detection Unit
- Data Forwarding Unit
- Support for additional MIPS instructions
- Jump (`j`) and Jump-and-Link (`jal`) instructions
- FPGA implementation and hardware validation

---

## Author

**Bhavya Jain**

B.Tech, Integrated Circuit Design and Technology (ICDT)  
Indian Institute of Technology Gandhinagar
