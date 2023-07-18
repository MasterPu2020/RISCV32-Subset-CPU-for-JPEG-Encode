//----------------------------------------------------------------
// Synchronous single port static random access memory
// Support: 32-bit read and write, no reset
// Last Modified Date: 2023/7/18
// Version: 1.1
// Author: Clark Pu
//----------------------------------------------------------------

module ram #(parameter WIDTH = 32, DEPTH = 2048) (
  input wire clk,
  input wire [WIDTH-1:0] address,
  input wire [WIDTH-1:0] wdata,
  input wire enw,
  output wire [WIDTH-1:0] rdata
);

  reg [WIDTH-1:0] memory [0:DEPTH-1 ];
  assign rdata = memory[address[$clog2(DEPTH)-1:0]];
  always_ff @(posedge clk)
    if (enw)
        memory[address[$clog2(DEPTH)-1:0]] <= wdata;

endmodule