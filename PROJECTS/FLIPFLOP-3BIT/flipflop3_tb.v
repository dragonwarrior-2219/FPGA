`timescale 1ns/1ps
module tb_flipflop3;

reg clk;
reg [2:0] D;
wire [2:0] Q;

flipflop3 uut(clk, D, Q);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    D = 3'b000;
    #10 D = 3'b101;
    #10 D = 3'b110;
    #10 D = 3'b111;
    #10;
end

endmodule