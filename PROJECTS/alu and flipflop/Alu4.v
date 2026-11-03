module alu_dff(
    input clk,
    input reset,
    input [3:0] A, B,
    input [2:0] opcode,
    output reg [3:0] Q
);

reg [3:0] result;

// ALU
always @(*) begin
    case(opcode)
        3'b000: result = A + B;
        3'b001: result = A - B;
        3'b010: result = A & B;
        3'b011: result = A | B;
        3'b100: result = A ^ B;
        default: result = 4'b0000;
    endcase
end

// D Flip-Flop
always @(posedge clk or posedge reset) begin
    if(reset)
        Q <= 4'b0000;
    else
        Q <= result;
end

endmodule