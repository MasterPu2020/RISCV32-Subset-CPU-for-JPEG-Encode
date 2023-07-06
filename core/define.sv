// -----------------------------------------------------------------------------------
// Using UTF-8
// Title: Defination of RISCV32 Instrcutions
// Last Modified Date: 2023/7/6
// Version: 1.0
// Author: Clark Pu
// -----------------------------------------------------------------------------------
//                                   RISC-V 32 Subset
// +---------------------------------------------------------------------------------+
// |31           25|24     20|19      5|14     12|11           7|6       0|   code   |
// +---------------------------------------------------------------------------------+
// |    0000000    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] add  |
// |    0000000    |   rs2   |   rs1   |   110   |      rd      | 0110011 | [R] or   |
// |    0000001    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] mul  |
// |    0000001    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] mulh |
// +---------------------------------------------------------------------------------+
// |        imm[11:0]        |   rs1   |   000   |      rd      | 0010011 | [I] addi |
// |        imm[11:0]        |   rs1   |   001   |      rd      | 0010011 | [I] slli |
// |        imm[11:0]        |   rs1   |   101   |      rd      | 0010011 | [I] srli |
// |        imm[11:0]        |   rs1   |   110   |      rd      | 0010011 | [I] xori |
// |        imm[11:0]        |   rs1   |   010   |      rd      | 0000011 | [I] lw   |
// +---------------------------------------------------------------------------------+
// |    imm[11:5]  |   rs2   |   rs1   |   010   |   imm[4:0]   | 0100011 | [S] sw   |
// +---------------------------------------------------------------------------------+
// |  imm[12|10:5] |   rs2   |   rs1   |   100   |  imm[4:1|11] | 1100011 | [B] blt  |
// +---------------------------------------------------------------------------------+
// |                    imm[31:12]               |      rd      | 0110111 | [U] lui? |
// +---------------------------------------------------------------------------------+
// Explain and Define:
// add  rs2 + rs1 -> rd
`define OP_ADD      7'b0110011
`define FUNCT7_ADD  7'b0000000
`define FUNCT3_ADD  3'b000
// or   rs2 | rs1 -> rd
`define OP_OR       7'b0110011
`define FUNCT7_OR   7'b0000000
`define FUNCT3_OR   3'b110
// mul  (rs2 * rs1)[31: 0] -> rd 
`define OP_MUL      7'b0110011
`define FUNCT7_MUL  7'b0000001
`define FUNCT3_MUL  3'b000
// mulh (rs2 * rs1)[63:32] -> rd 
`define OP_MULH     7'b0110011
`define FUNCT7_MULH 7'b0000001
`define FUNCT3_MULH 3'b001
// addi imm + rs1 -> rd
`define OP_ADDI     7'b0010011
`define FUNCT3_ADDI 3'b000
// slli r1 << imm[4:0] -> rd
`define OP_SLLI     7'b0010011
`define FUNCT3_SLLI 3'b001
// srli r1 >> imm[4:0] -> rd
`define OP_SRLI     7'b0010011
`define FUNCT3_SRLI 3'b101
// xori imm ^ rs1 -> rd
`define OP_XORI     7'b0010011
`define FUNCT3_XORI 3'b110
// lw   mem(imm + rs1) -> rd
`define OP_LW       7'b0000011
`define FUNCT3_LW   3'b010
// sw   mem(imm + rs1) <- rs2
`define OP_SW       7'b0100011
`define FUNCT3_SW   3'b010
// blt  pc <- ({imm,0} + pc) if (rs1 < rs2)
`define OP_BLT      7'b1100011
`define FUNCT3_BLT  3'b100
// -----------------------------------------------------------------------------------
