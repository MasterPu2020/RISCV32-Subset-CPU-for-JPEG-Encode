// -----------------------------------------------------------------------------------
// Using UTF-8
// Title: Defination of RISCV32 Instrcutions
// Last Modified Date: 2023/7/6
// Version: 1.0
// Author: Clark Pu
// -----------------------------------------------------------------------------------
//                                   RISC-V 32 Subset
// +---------------------------------------------------------------------------------+
// |31           25|24     20|19     15|14     12|11           7|6       0|   code   |
// +---------------------------------------------------------------------------------+
// |    0000000    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] add  |
// |    0000000    |   rs2   |   rs1   |   111   |      rd      | 0110011 | [R] and  |
// |    0000000    |   rs2   |   rs1   |   110   |      rd      | 0110011 | [R] or   |
// |    0000000    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] sll  |
// |    0100000    |   rs2   |   rs1   |   101   |      rd      | 0110011 | [R] sra  |
// |    0000001    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] mul  |
// |    0000001    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] mulh |
// +---------------------------------------------------------------------------------+
// |        imm[11:0]        |   rs1   |   000   |      rd      | 0010011 | [I] addi |
// |        imm[11:0]        |   rs1   |   110   |      rd      | 0010011 | [I] xori |
// |        imm[11:0]        |   rs1   |   010   |      rd      | 0000011 | [I] lw   |
// +---------------------------------------------------------------------------------+
// |    imm[11:5]  |   rs2   |   rs1   |   010   |   imm[4:0]   | 0100011 | [S] sw   |
// +---------------------------------------------------------------------------------+
// |  imm[12|10:5] |   rs2   |   rs1   |   000   |  imm[4:1|11] | 1100011 | [B] beq  |
// |  imm[12|10:5] |   rs2   |   rs1   |   001   |  imm[4:1|11] | 1100011 | [B] bne  |
// |  imm[12|10:5] |   rs2   |   rs1   |   100   |  imm[4:1|11] | 1100011 | [B] blt  |
// |  imm[12|10:5] |   rs2   |   rs1   |   101   |  imm[4:1|11] | 1100011 | [B] bge  |
// +---------------------------------------------------------------------------------+
// Explain and Define:
// add  rs2 + rs1 -> rd
`define OP_ADD      7'b0110011
`define FUNCT7_ADD  7'b0000000
`define FUNCT3_ADD  3'b000
// and   rs2 & rs1 -> rd
`define OP_AND      7'b0110011
`define FUNCT7_AND  7'b0000000
`define FUNCT3_AND  3'b111
// or   rs2 | rs1 -> rd
`define OP_OR       7'b0110011
`define FUNCT7_OR   7'b0000000
`define FUNCT3_OR   3'b110
// sll r1 << r2 -> rd
`define OP_SLL      7'b0110011
`define FUNCT3_SLL  3'b001
// sra r1 >> r2 -> rd
`define OP_SRA      7'b0110011
`define FUNCT3_SRA  3'b101
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
// xori imm ^ rs1 -> rd
`define OP_XORI     7'b0010011
`define FUNCT3_XORI 3'b110
// lw   mem(imm + rs1) -> rd
`define OP_LW       7'b0000011
`define FUNCT3_LW   3'b010
// sw   mem(imm + rs1) <- rs2
`define OP_SW       7'b0100011
`define FUNCT3_SW   3'b010
// beq  pc <- ({imm,0} + pc) if (rs1 == rs2)
`define OP_BEQ      7'b1100011
`define FUNCT3_BEQ  3'b000
// bne  pc <- ({imm,0} + pc) if (rs1 != rs2)
`define OP_BNE      7'b1100011
`define FUNCT3_BNE  3'b001
// blt  pc <- ({imm,0} + pc) if (rs1 < rs2)
`define OP_BLT      7'b1100011
`define FUNCT3_BLT  3'b100
// bge  pc <- ({imm,0} + pc) if (rs1 >= rs2)
`define OP_BGE      7'b1100011
`define FUNCT3_BGE  3'b101

// -----------------------------------------------------------------------------------
