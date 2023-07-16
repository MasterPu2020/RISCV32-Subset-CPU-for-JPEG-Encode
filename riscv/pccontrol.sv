//----------------------------------------------------------------
// Progrma counter controller behavioural
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module pccontrol #(parameter WIDTH = 32) (
  input wire flag,
  input wire [WIDTH-1:0] pcoffset,
  input wire [WIDTH-1:0] pcin,
  output wire [WIDTH-1:0] pcout
);

  assign pcout = flag ? pcin + pcoffset : pcin + 4;

endmodule