
// Module: MIPS Processor Testbench
// Description:
// Verifies the functionality of the 32-bit single-cycle MIPS processor by generating clock and reset signals.

`timescale 1ns/1ps

module tb_mips;

reg clk;
reg reset_n;

// Instantiate the MIPS processor
mips_top DUT(

    .clk(clk),
    .reset_n(reset_n)

);

// Clock Generation
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset and Simulation Control
initial
begin

    // Apply active-low reset
    reset_n = 0;

    #20;

    // Release reset
    reset_n = 1;

    // Runs the simulation for the specified time
    #285;

    // Stop the simulation
    $stop;

end

endmodule
