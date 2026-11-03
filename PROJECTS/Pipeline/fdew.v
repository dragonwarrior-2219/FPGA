`timescale 1ns/1ps

module riscv_processor (
    input wire clk,
    input wire reset
);

// ==========================================
// 1. MEMORY AND REGISTER FILE
// ==========================================

reg [31:0] PC;

reg [31:0] instruction_memory [0:255];
reg [31:0] data_memory [0:255];
reg [31:0] register_file [0:31];

integer i;

// ==========================================
// 2. PIPELINE REGISTER: IF / ID
// ==========================================

reg [31:0] IF_ID_instruction;
reg [31:0] IF_ID_PC;
reg IF_ID_valid;

// ==========================================
// 3. PIPELINE REGISTER: ID / EX
// ==========================================

reg [31:0] ID_EX_operand1;
reg [31:0] ID_EX_operand2;
reg [31:0] ID_EX_immediate;

reg [4:0] ID_EX_rs1;
reg [4:0] ID_EX_rs2;
reg [4:0] ID_EX_rd;

reg [3:0] ID_EX_alu_control;

reg ID_EX_alu_src;
reg ID_EX_reg_write;
reg ID_EX_mem_read;
reg ID_EX_mem_write;
reg ID_EX_valid;

// ==========================================
// 4. PIPELINE REGISTER: EX / MEM
// ==========================================

reg [31:0] EX_MEM_alu_result;
reg [31:0] EX_MEM_store_data;

reg [4:0] EX_MEM_rd;

reg EX_MEM_reg_write;
reg EX_MEM_mem_read;
reg EX_MEM_mem_write;
reg EX_MEM_valid;

// ==========================================
// 5. PIPELINE REGISTER: MEM / WB
// ==========================================

reg [31:0] MEM_WB_result;

reg [4:0] MEM_WB_rd;

reg MEM_WB_reg_write;
reg MEM_WB_valid;

// ==========================================
// 6. ALU CONTROL
// ==========================================

localparam ALU_ADD = 4'b0000;
localparam ALU_SUB = 4'b0001;
localparam ALU_AND = 4'b0010;
localparam ALU_OR  = 4'b0011;
localparam ALU_XOR = 4'b0100;

// ==========================================
// 7. INSTRUCTION DECODER
// ==========================================

wire [6:0] opcode;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = IF_ID_instruction[6:0];
assign rd     = IF_ID_instruction[11:7];
assign funct3 = IF_ID_instruction[14:12];
assign rs1    = IF_ID_instruction[19:15];
assign rs2    = IF_ID_instruction[24:20];
assign funct7 = IF_ID_instruction[31:25];

reg [31:0] immediate;
reg [3:0] alu_control;

reg alu_src;
reg reg_write;
reg mem_read;
reg mem_write;

// ==========================================
// 8. HAZARD DETECTION
// ==========================================

wire uses_rs1;
wire uses_rs2;
wire stall;

assign uses_rs1 =
    (opcode == 7'b0110011) ||
    (opcode == 7'b0010011) ||
    (opcode == 7'b0000011) ||
    (opcode == 7'b0100011);

assign uses_rs2 =
    (opcode == 7'b0110011) ||
    (opcode == 7'b0100011);

assign stall =
    IF_ID_valid &&
    ID_EX_valid &&
    ID_EX_mem_read &&
    (ID_EX_rd != 0) &&
    (
        (uses_rs1 && rs1 == ID_EX_rd) ||
        (uses_rs2 && rs2 == ID_EX_rd)
    );

// ==========================================
// 9. FETCH STAGE
// ==========================================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        PC <= 0;
        IF_ID_instruction <= 32'h00000013;
        IF_ID_PC <= 0;
        IF_ID_valid <= 0;

    end

    else if (!stall) begin

        IF_ID_instruction <= instruction_memory[PC[9:2]];

        IF_ID_PC <= PC;

        IF_ID_valid <= 1;

        PC <= PC + 4;

    end

end

// ==========================================
// 10. DECODE STAGE
// ==========================================

always @(*) begin

    immediate = 0;
    alu_control = ALU_ADD;

    alu_src = 0;
    reg_write = 0;
    mem_read = 0;
    mem_write = 0;

    if (IF_ID_valid) begin

        case (opcode)

            // R-TYPE

            7'b0110011: begin

                reg_write = 1;
                alu_src = 0;

                case ({funct7, funct3})

                    {7'b0000000, 3'b000}:
                        alu_control = ALU_ADD;

                    {7'b0100000, 3'b000}:
                        alu_control = ALU_SUB;

                    {7'b0000000, 3'b111}:
                        alu_control = ALU_AND;

                    {7'b0000000, 3'b110}:
                        alu_control = ALU_OR;

                    {7'b0000000, 3'b100}:
                        alu_control = ALU_XOR;

                    default:
                        reg_write = 0;

                endcase

            end

            // I-TYPE

            7'b0010011: begin

                reg_write = 1;
                alu_src = 1;

                immediate = {
                    {20{IF_ID_instruction[31]}},
                    IF_ID_instruction[31:20]
                };

                case (funct3)

                    3'b000: alu_control = ALU_ADD;
                    3'b111: alu_control = ALU_AND;
                    3'b110: alu_control = ALU_OR;

                    default: reg_write = 0;

                endcase

            end

            // LOAD WORD

            7'b0000011: begin

                reg_write = 1;
                mem_read = 1;
                alu_src = 1;

                immediate = {
                    {20{IF_ID_instruction[31]}},
                    IF_ID_instruction[31:20]
                };

                alu_control = ALU_ADD;

            end

            // STORE WORD

            7'b0100011: begin

                mem_write = 1;
                alu_src = 1;

                immediate = {
                    {20{IF_ID_instruction[31]}},
                    IF_ID_instruction[31:25],
                    IF_ID_instruction[11:7]
                };

                alu_control = ALU_ADD;

            end

            default: begin

                reg_write = 0;
                mem_read = 0;
                mem_write = 0;

            end

        endcase

    end

end

// ==========================================
// 11. ID / EX PIPELINE REGISTER
// ==========================================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        ID_EX_operand1 <= 0;
        ID_EX_operand2 <= 0;
        ID_EX_immediate <= 0;

        ID_EX_rs1 <= 0;
        ID_EX_rs2 <= 0;
        ID_EX_rd <= 0;

        ID_EX_alu_control <= ALU_ADD;

        ID_EX_alu_src <= 0;
        ID_EX_reg_write <= 0;
        ID_EX_mem_read <= 0;
        ID_EX_mem_write <= 0;
        ID_EX_valid <= 0;

    end

    else if (stall) begin

        // Insert bubble into pipeline

        ID_EX_reg_write <= 0;
        ID_EX_mem_read <= 0;
        ID_EX_mem_write <= 0;
        ID_EX_valid <= 0;

    end

    else begin

        ID_EX_operand1 <=
            (rs1 == 0) ? 0 :
            (MEM_WB_valid && MEM_WB_reg_write &&
             MEM_WB_rd != 0 && MEM_WB_rd == rs1) ?
             MEM_WB_result : register_file[rs1];

        ID_EX_operand2 <=
            (rs2 == 0) ? 0 :
            (MEM_WB_valid && MEM_WB_reg_write &&
             MEM_WB_rd != 0 && MEM_WB_rd == rs2) ?
             MEM_WB_result : register_file[rs2];

        ID_EX_immediate <= immediate;

        ID_EX_rs1 <= rs1;
        ID_EX_rs2 <= rs2;
        ID_EX_rd <= rd;

        ID_EX_alu_control <= alu_control;

        ID_EX_alu_src <= alu_src;
        ID_EX_reg_write <= reg_write;
        ID_EX_mem_read <= mem_read;
        ID_EX_mem_write <= mem_write;

        ID_EX_valid <= IF_ID_valid;

    end

end

// ==========================================
// 12. EXECUTE STAGE - FORWARDING UNIT
// ==========================================

reg [31:0] forwarded_operand1;
reg [31:0] forwarded_operand2;

reg [31:0] alu_operand2;
reg [31:0] alu_result;

always @(*) begin

    // Default register operands

    forwarded_operand1 = ID_EX_operand1;
    forwarded_operand2 = ID_EX_operand2;

    // Forward from EX/MEM stage

    if (
        EX_MEM_valid &&
        EX_MEM_reg_write &&
        !EX_MEM_mem_read &&
        EX_MEM_rd != 0 &&
        EX_MEM_rd == ID_EX_rs1
    ) begin

        forwarded_operand1 = EX_MEM_alu_result;

    end

    else if (
        MEM_WB_valid &&
        MEM_WB_reg_write &&
        MEM_WB_rd != 0 &&
        MEM_WB_rd == ID_EX_rs1
    ) begin

        forwarded_operand1 = MEM_WB_result;

    end

    // Forward second register operand

    if (
        EX_MEM_valid &&
        EX_MEM_reg_write &&
        !EX_MEM_mem_read &&
        EX_MEM_rd != 0 &&
        EX_MEM_rd == ID_EX_rs2
    ) begin

        forwarded_operand2 = EX_MEM_alu_result;

    end

    else if (
        MEM_WB_valid &&
        MEM_WB_reg_write &&
        MEM_WB_rd != 0 &&
        MEM_WB_rd == ID_EX_rs2
    ) begin

        forwarded_operand2 = MEM_WB_result;

    end

    // Select ALU second input

    if (ID_EX_alu_src)
        alu_operand2 = ID_EX_immediate;

    else
        alu_operand2 = forwarded_operand2;

    // ALU operations

    case (ID_EX_alu_control)

        ALU_ADD:
            alu_result = forwarded_operand1 + alu_operand2;

        ALU_SUB:
            alu_result = forwarded_operand1 - alu_operand2;

        ALU_AND:
            alu_result = forwarded_operand1 & alu_operand2;

        ALU_OR:
            alu_result = forwarded_operand1 | alu_operand2;

        ALU_XOR:
            alu_result = forwarded_operand1 ^ alu_operand2;

        default:
            alu_result = 0;

    endcase

end

// ==========================================
// 13. EX / MEM PIPELINE REGISTER
// ==========================================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        EX_MEM_alu_result <= 0;
        EX_MEM_store_data <= 0;
        EX_MEM_rd <= 0;

        EX_MEM_reg_write <= 0;
        EX_MEM_mem_read <= 0;
        EX_MEM_mem_write <= 0;
        EX_MEM_valid <= 0;

    end

    else begin

        EX_MEM_alu_result <= alu_result;

        EX_MEM_store_data <= forwarded_operand2;

        EX_MEM_rd <= ID_EX_rd;

        EX_MEM_reg_write <= ID_EX_reg_write;
        EX_MEM_mem_read <= ID_EX_mem_read;
        EX_MEM_mem_write <= ID_EX_mem_write;

        EX_MEM_valid <= ID_EX_valid;

    end

end

// ==========================================
// 14. MEMORY ACCESS STAGE
// ==========================================

always @(posedge clk) begin

    if (!reset && EX_MEM_valid && EX_MEM_mem_write) begin

        data_memory[EX_MEM_alu_result[9:2]]
            <= EX_MEM_store_data;

    end

end

// ==========================================
// 15. MEM / WB PIPELINE REGISTER
// ==========================================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        MEM_WB_result <= 0;
        MEM_WB_rd <= 0;

        MEM_WB_reg_write <= 0;
        MEM_WB_valid <= 0;

    end

    else begin

        if (EX_MEM_valid && EX_MEM_mem_read) begin

            MEM_WB_result <=
                data_memory[EX_MEM_alu_result[9:2]];

        end

        else begin

            MEM_WB_result <= EX_MEM_alu_result;

        end

        MEM_WB_rd <= EX_MEM_rd;

        MEM_WB_reg_write <= EX_MEM_reg_write;

        MEM_WB_valid <= EX_MEM_valid;

    end

end

// ==========================================
// 16. WRITE BACK STAGE
// ==========================================

always @(posedge clk or posedge reset) begin

    if (reset) begin

        for (i = 0; i < 32; i = i + 1) begin

            register_file[i] <= 0;

        end

    end

    else begin

        if (
            MEM_WB_valid &&
            MEM_WB_reg_write &&
            MEM_WB_rd != 0
        ) begin

            register_file[MEM_WB_rd] <= MEM_WB_result;

        end

        // x0 is always zero

        register_file[0] <= 0;

    end

end

endmodule
