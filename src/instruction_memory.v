
// Module: Instruction Memory
// Description:
// Here we create a Instruction memory which stores program instructions and outputs the instruction corresponding to the current Program Counter (PC) address.

module instruction_memory(
    input [31:0] address,          // Address from the Program Counter
    output [31:0] instruction      // Instruction fetched from memory
);

    // 256-word instruction memory
    reg [31:0] memory [0:255];

    initial begin
        // Load instructions from the memory initialization file
        $readmemh("instructions.mem", memory);
    end

    // Word-aligned instruction fetch
    assign instruction = memory[address[9:2]];

endmodule
