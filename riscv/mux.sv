//----------------------------------------------------------------
// Parallel data mutilpexer
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module mux #(parameter WIDTH = 32) (
  input wire [WIDTH-1:0] data1, data2,
  input wire sel,
  output wire [WIDTH-1:0] datao
);

  assign datao = sel ? data1 : data2;

endmodule