
`timescale 1ns/1ps

module tb_riscv_processor;

// ==========================================
// 1. SIGNAL DECLARATION
// ==========================================

reg clk;
reg reset;

integer cycle;
integer j;

// ==========================================
// 2. DUT INSTANTIATION
// ==========================================

riscv_processor uut (
    .clk(clk),
    .reset(reset)
);

// ==========================================
// 3. CLOCK GENERATION
// ==========================================

initial begin
    clk = 0;

    repeat (80) begin
        #5 clk = ~clk;
    end

    clk = 0;
end

// ==========================================
// 4. R-TYPE INSTRUCTION ENCODER
// ==========================================

function [31:0] encode_r;

    input [6:0] funct7;
    input [4:0] rs2;
    input [4:0] rs1;
    input [2:0] funct3;
    input [4:0] rd;

    begin
        encode_r = {
            funct7,
            rs2,
            rs1,
            funct3,
            rd,
            7'b0110011
        };
    end

endfunction

// ==========================================
// 5. I-TYPE INSTRUCTION ENCODER
// ==========================================

function [31:0] encode_i;

    input [11:0] imm;
    input [4:0] rs1;
    input [2:0] funct3;
    input [4:0] rd;

    begin
        encode_i = {
            imm,
            rs1,
            funct3,
            rd,
            7'b0010011
        };
    end

endfunction

// ==========================================
// 6. S-TYPE INSTRUCTION ENCODER
// ==========================================

function [31:0] encode_s;

    input [11:0] imm;
    input [4:0] rs2;
    input [4:0] rs1;
    input [2:0] funct3;

    begin
        encode_s = {
            imm[11:5],
            rs2,
            rs1,
            funct3,
            imm[4:0],
            7'b0100011
        };
    end

endfunction

// ==========================================
// 7. MAIN TEST PROGRAM
// ==========================================

initial begin

    reset = 1;
    cycle = 0;

    // INITIALIZE INSTRUCTION MEMORY

    for (j = 0; j < 256; j = j + 1) begin
        uut.instruction_memory[j] = 32'h00000013;
    end

    // INITIALIZE DATA MEMORY

    for (j = 0; j < 256; j = j + 1) begin
        uut.data_memory[j] = 0;
    end

    // ======================================
    // 8. LOAD INSTRUCTIONS INTO MEMORY
    // ======================================

    // INSTRUCTION 1:
    // ADDI x1, x0, 10

    uut.instruction_memory[0] =
        encode_i(
            12'd10,
            5'd0,
            3'b000,
            5'd1
        );

    // INSTRUCTION 2:
    // ADDI x2, x0, 20

    uut.instruction_memory[1] =
        encode_i(
            12'd20,
            5'd0,
            3'b000,
            5'd2
        );

    // INSTRUCTION 3:
    // ADD x3, x1, x2

    uut.instruction_memory[2] =
        encode_r(
            7'b0000000,
            5'd2,
            5'd1,
            3'b000,
            5'd3
        );

    // INSTRUCTION 4:
    // SUB x4, x3, x1

    uut.instruction_memory[3] =
        encode_r(
            7'b0100000,
            5'd1,
            5'd3,
            3'b000,
            5'd4
        );

    // INSTRUCTION 5:
    // SW x4, 0(x0)

    uut.instruction_memory[4] =
        encode_s(
            12'd0,
            5'd4,
            5'd0,
            3'b010
        );

    // INSTRUCTION 6:
    // LW x5, 0(x0)

    uut.instruction_memory[5] =
        encode_i(
            12'd0,
            5'd0,
            3'b010,
            5'd5
        );

    // INSTRUCTION 7:
    // ADD x6, x5, x1
    // Tests LOAD-USE HAZARD

    uut.instruction_memory[6] =
        encode_r(
            7'b0000000,
            5'd1,
            5'd5,
            3'b000,
            5'd6
        );

    // INSTRUCTION 8:
    // AND x7, x5, x4

    uut.instruction_memory[7] =
        encode_r(
            7'b0000000,
            5'd4,
            5'd5,
            3'b111,
            5'd7
        );

    // INSTRUCTION 9:
    // OR x8, x1, x2

    uut.instruction_memory[8] =
        encode_r(
            7'b0000000,
            5'd2,
            5'd1,
            3'b110,
            5'd8
        );

    // INSTRUCTION 10:
    // XOR x9, x8, x1

    uut.instruction_memory[9] =
        encode_r(
            7'b0000000,
            5'd1,
            5'd8,
            3'b100,
            5'd9
        );

    // ======================================
    // 9. RESET CONTROL
    // ======================================

    #20;

    reset = 0;

    // ======================================
    // 10. PIPELINE MONITORING
    // ======================================

    repeat (25) begin

        @(posedge clk);

        cycle = cycle + 1;

        #1;

        $display("");
        $display("============================================");
        $display("             CLOCK CYCLE : %0d", cycle);
        $display("============================================");

        // FETCH STAGE

        $display("");
        $display("FETCH STAGE (IF)");

        $display("PC                : %h", uut.PC);

        $display("Instruction       : %h",
                 uut.IF_ID_instruction);

        // DECODE STAGE

        $display("");
        $display("DECODE STAGE (ID)");

        $display("RS1               : %0d", uut.rs1);

        $display("RS2               : %0d", uut.rs2);

        $display("RD                : %0d", uut.rd);

        // EXECUTE STAGE

        $display("");
        $display("EXECUTE STAGE (EX)");

        $display("Operand 1         : %0d",
                 uut.forwarded_operand1);

        $display("Operand 2         : %0d",
                 uut.alu_operand2);

        $display("ALU Result        : %0d",
                 uut.alu_result);

        // MEMORY STAGE

        $display("");
        $display("MEMORY STAGE (MEM)");

        $display("Memory Read       : %b",
                 uut.EX_MEM_mem_read);

        $display("Memory Write      : %b",
                 uut.EX_MEM_mem_write);

        $display("Memory Address    : %h",
                 uut.EX_MEM_alu_result);

        // WRITE BACK STAGE

        $display("");
        $display("WRITE BACK STAGE (WB)");

        $display("Destination Reg   : %0d",
                 uut.MEM_WB_rd);

        $display("Writeback Result  : %0d",
                 uut.MEM_WB_result);

        // HAZARD DETECTION

        $display("");
        $display("HAZARD DETECTION");

        $display("Stall Signal      : %b",
                 uut.stall);

        $display("============================================");

    end

    // ======================================
    // 11. FINAL REGISTER RESULTS
    // ======================================

    $display("");
    $display("============================================");
    $display("       FINAL RISC-V PROCESSOR RESULTS");
    $display("============================================");

    $display("REGISTER x1  : %0d",
             uut.register_file[1]);

    $display("REGISTER x2  : %0d",
             uut.register_file[2]);

    $display("REGISTER x3  : %0d",
             uut.register_file[3]);

    $display("REGISTER x4  : %0d",
             uut.register_file[4]);

    $display("REGISTER x5  : %0d",
             uut.register_file[5]);

    $display("REGISTER x6  : %0d",
             uut.register_file[6]);

    $display("REGISTER x7  : %0d",
             uut.register_file[7]);

    $display("REGISTER x8  : %0d",
             uut.register_file[8]);

    $display("REGISTER x9  : %0d",
             uut.register_file[9]);

    $display("--------------------------------------------");

    $display("DATA MEMORY [0] : %0d",
             uut.data_memory[0]);

    $display("============================================");

    // ======================================
    // 12. AUTOMATIC VERIFICATION
    // ======================================

    if (
        uut.register_file[1] == 10 &&
        uut.register_file[2] == 20 &&
        uut.register_file[3] == 30 &&
        uut.register_file[4] == 20 &&
        uut.register_file[5] == 20 &&
        uut.register_file[6] == 30 &&
        uut.register_file[7] == 20 &&
        uut.register_file[8] == 30 &&
        uut.register_file[9] == 20 &&
        uut.data_memory[0] == 20
    ) begin

        $display("");
        $display("TEST STATUS : ALL TESTS PASSED");

    end

    else begin

        $display("");
        $display("TEST STATUS : TEST FAILED");

    end

    $display("");
    $display("SIMULATION COMPLETED");
    $display("NO FINISH FUNCTION USED");

end

endmodule
