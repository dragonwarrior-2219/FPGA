`timescale 1ns/1ps
module flipflop3 (
    input clk,
    input [2:0] D,
    output reg [2:0] Q
);

always @(posedge clk)
begin
    Q <= D;
end

endmodule