//----------------------------------------------------------------
// Instruction decoder behavioural
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module control (
  input wire [6:0] op,
  output wire meml, mems, regw, aluimm
);

  assign meml = op[6:4] == 3'b000;
  assign mems = op[6:4] == 3'b010;
  assign regw = (op[5:4] != 2'b10);
  assign aluimm = (~op[6]) & (op[5:4] != 2'b11);

endmodule