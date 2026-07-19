
// Module: 4-to-1 Multiplexer (MUX4)
// Description:
// Selects one of four 32-bit inputs based on the 2-bit select signal.
// Used in the datapath to route the required data to the next stage.

module mux4(

    input [31:0] a,
    input [31:0] b,
    input [31:0] c,
    input [31:0] d,

    input [1:0] sel,

    output reg [31:0] y

);

always @(*) begin

    case(sel)

        2'b00: y = a;   // Select input a
        2'b01: y = b;   // Select input b
        2'b10: y = c;   // Select input c
        2'b11: y = d;   // Select input d

    endcase

end

endmodule
