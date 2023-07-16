//----------------------------------------------------------------
// Program counter behavioural
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module pc #(WIDTH = 32) (
  input wire clk, nrst,
  input wire [WIDTH-1:0] addressin,
  output reg [WIDTH-1:0] addressout
);

  always_ff @(posedge clk, negedge nrst)
    if (~nrst)
      addressout <= 0;
    else
      addressout <= addressin;

endmodule