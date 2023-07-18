//----------------------------------------------------------------
// Asynchronous single port read-only memory behavioural
// Support: 32-bit read, address add by 4
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module rom #(parameter WIDTH = 32, DEPTH = 2048) (
  input wire [WIDTH-1:0] address,
  output wire [WIDTH-1:0] rdata
);

  wire [WIDTH-1:0] memory [DEPTH-1:0];
  assign rdata = memory[address[WIDTH-1:2]];

  // JPEG encode program
  `include "system.hex"

endmodule