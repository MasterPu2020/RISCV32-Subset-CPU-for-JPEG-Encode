//----------------------------------------------------------------
// Asynchronous dual port static random access memory
// Support: 32-bit read and write, address add by 1
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module ram #(parameter WIDTH = 32, DEPTH = 2048) (
  input wire [WIDTH-1:0] address1, address2,
  input wire [WIDTH-1:0] wdata1, wdata2,
  input wire enw1, enw2,
  output wire [WIDTH-1:0] rdata1, rdata2
);

  logic [WIDTH-1:0] memory [DEPTH-1:0];
  // read
  assign rdata1 = memory[address1];
  assign rdata2 = memory[address2];
  // write
  always_latch begin
    if (enw1)
      memory[address1] <= wdata1;
    if (enw2)
      memory[address2] <= wdata2;
  end 

endmodule