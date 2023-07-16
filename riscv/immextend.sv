//----------------------------------------------------------------
// Immediate number generator
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module immextend #(WIDTH = 32) (
  input wire [31:0] inst,
  output logic [WIDTH-1:0] imm
);

  // this core doesn't contain a J type
  wire [11:0] immi, imms, immb;
  assign immb = {inst[31], inst[7], inst[30:25], inst[11:8]};
  assign imms = {inst[31:25], inst[11:7]};
  assign immi = inst[31:20];

  always_comb begin
    imm = 0;
    case (inst[6:4])
      3'b001: imm = {{(WIDTH-12){immi[11]}}, immi}; // I type
      3'b000: imm = {{(WIDTH-12){immi[11]}}, immi}; // I type
      3'b010: imm = {{(WIDTH-12){imms[11]}}, imms}; // S type
      3'b110: imm = {{(WIDTH-13){immb[11]}}, immb, 1'b0}; // B type
    endcase
  end

endmodule