//----------------------------------------------------------------
// Asynchronous single port read-only memory behavioural
// Support: 32-bit read
// Last Modified Date: 2023/8/8
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module rom #(parameter WIDTH = 32, DEPTH = 2480) (
  input wire [WIDTH-1:0] address,
  output wire [WIDTH-1:0] rdata
);

  wire [WIDTH-1:0] memory [DEPTH:0];
  assign rdata = memory[address[WIDTH-1:2]];

  `include "../fpga/system.v"

endmodule