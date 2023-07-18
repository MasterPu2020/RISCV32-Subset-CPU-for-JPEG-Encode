//----------------------------------------------------------------
// Synchronous dual port static random access memory
// Support: 32-bit read and write, address add by 1
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module dualram #(parameter WIDTH = 32, DEPTH = 206800) (
  input wire clk1, clk2,
  input wire [WIDTH-1:0] address1, address2,
  input wire [WIDTH-1:0] wdata1, wdata2,
  input wire enw1, enw2,
  output wire [WIDTH-1:0] rdata1, rdata2
);

  logic [WIDTH-1:0] memory [DEPTH-1:0];
  // read
  assign rdata1 = memory[address1-206800];
  assign rdata2 = memory[address2-206800];
  // write1
  always_ff @(posedge clk1)
    if (enw1)
      memory[address1-206800] <= wdata1;
  // write1
  always_ff @(posedge clk2)
    if (enw2)
      memory[address2-206800] <= wdata2;

endmodule