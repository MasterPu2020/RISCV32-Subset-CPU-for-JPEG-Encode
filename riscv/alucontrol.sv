//----------------------------------------------------------------
// ALU operation decoder behavioural
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module alucontrol (
  input wire [6:0] funct7,
  input wire [2:0] funct3,
  input wire [6:0] op,
  output wire [13:0] aluop
);

  `include "define.sv"

  logic ADD, SLL, SRA, XOR, AND, OR, MUL, MULH, RBUS0;
  logic EQ, NE, LT, GE, BBUS0;

  // B type
  assign EQ = op[6] & ~funct3[2] & ~funct3[0];
  assign NE = op[6] & ~funct3[2] &  funct3[0];
  assign LT = op[6] &  funct3[2] & ~funct3[0];
  assign GE = op[6] &  funct3[2] &  funct3[0];
  assign BBUS0 = ~op[6];

  // ALU
  assign RBUS0 = op[6];
  always_comb begin
    ADD  = 0;
    SLL  = 0;
    SRA  = 0;
    XOR  = 0;
    AND  = 0;
    OR   = 0;
    MUL  = 0;
    MULH = 0;
    if (~op[6])
      if (op[5:4] == 2'b11) // R type
        case (funct3)
          `FUNCT3_ADD  : ADD  = ~funct7[0];
          `FUNCT3_AND  : AND  = 1;
          `FUNCT3_OR   : OR   = 1;
          `FUNCT3_SLL  : SLL  = ~funct7[0];
          `FUNCT3_SRA  : SRA  = 1;
          `FUNCT3_MUL  : MUL  = funct7[0];
          `FUNCT3_MULH : MULH = funct7[0];
        endcase
      else if (funct3 == 3'b110) // I type: only one xori
        XOR = 1;
      else // S type
        ADD = 1;
  end

  assign aluop = {
    ADD, SLL, SRA, XOR, AND, OR, MUL, MULH, RBUS0, 
    EQ, NE, LT, GE, BBUS0};

endmodule