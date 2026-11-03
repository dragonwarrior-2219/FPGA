`timescale 1ns/1ps

module tb_alu_dff;

reg clk, reset;
reg [3:0] A, B;
reg [2:0] opcode;

wire [3:0] Q;

// DUT
alu_dff uut(
    .clk(clk),
    .reset(reset),
    .A(A),
    .B(B),
    .opcode(opcode),
    .Q(Q)
);

// Clock generation
always #5 clk = ~clk;

// Test cases
initial begin
    clk = 0;
    reset = 1;
    A = 0;
    B = 0;
    opcode = 0;

    #10 reset = 0;

    // Addition
    A = 4'b0011;
    B = 4'b0010;
    opcode = 3'b000;
    #10;

    // Subtraction
    A = 4'b0110;
    B = 4'b0010;
    opcode = 3'b001;
    #10;

    // AND
    A = 4'b1100;
    B = 4'b1010;
    opcode = 3'b010;
    #10;

    // OR
    A = 4'b1100;
    B = 4'b1010;
    opcode = 3'b011;
    #10;

    // XOR
    A = 4'b1111;
    B = 4'b1010;
    opcode = 3'b100;
    #10;

    // Reset
    reset = 1;
    #10;

    reset = 0;
    #10;
 $finish;
end

// Display output
initial begin
    $monitor("Time=%0t | CLK=%b | RESET=%b | A=%b | B=%b | OP=%b | Q=%b",
             $time, clk, reset, A, B, opcode, Q);
end

endmodule