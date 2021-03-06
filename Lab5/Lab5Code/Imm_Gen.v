`timescale 1ns/1ps

module Imm_Gen(
    input      [31:0] instr_i,
    output reg [31:0] Imm_Gen_o
);

/* Write your code HERE */
//Internal Signals
wire [7-1:0] opcode;
wire [3-1:0] func3;
wire [3-1:0] Instr_field;
wire         sign;

assign opcode = instr_i[6:0];
assign func3  = instr_i[14:12];
assign sign   = instr_i[31];

always @(*) begin
    case (opcode)
        7'b0110011: begin // R-type
            Imm_Gen_o = 32'b0;
        end
        7'b0010011: begin // I-type
            if (func3 == 3'b001) begin
                Imm_Gen_o = { 7'b0, instr_i[24:20] };
            end
            else begin
                Imm_Gen_o = { { 21{ sign } }, instr_i[30:20] };
            end
        end
        7'b0000011: begin // Load
            Imm_Gen_o = { { 21{ sign } }, instr_i[30:20] };
        end
        7'b0100011: begin // Store
            Imm_Gen_o = { { 21{ sign } }, instr_i[30:25], instr_i[11:7] };
        end
        7'b1100011: begin // branch
            Imm_Gen_o = { { 21{ sign } }, instr_i[7], instr_i[30:25], instr_i[11:8] };
        end
        7'b1101111: begin // jal
            Imm_Gen_o = { { 13{ sign } }, instr_i[19:12], instr_i[20], instr_i[30:21] };
        end
        7'b1100111: begin // jalr
            Imm_Gen_o = { { 21{ sign } }, instr_i[30:20] };
        end
        default: begin
            Imm_Gen_o = 32'b0;
        end
    endcase
end
endmodule
