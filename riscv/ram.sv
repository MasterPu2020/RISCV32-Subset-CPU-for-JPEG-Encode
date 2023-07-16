//----------------------------------------------------------------
// Asynchronous single port static random access memory
// Support: 32-bit read and write
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module ram #(parameter WIDTH = 32, DEPTH = 2048) (
  input wire [WIDTH-1:0] address,
  input wire [WIDTH-1:0] wdata,
  input wire enw,
  output wire [WIDTH-1:0] rdata
);

  logic [WIDTH-1:0] memory [DEPTH-1:0];
  assign rdata = memory[address];
  always_latch
    if (enw)
        memory[address] <= wdata;

endmodule