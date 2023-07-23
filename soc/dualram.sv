//----------------------------------------------------------------
// Synchronous dual port static random access memory
// Support: 32-bit read and write, address add by 1
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module dualram #(parameter WIDTH = 32, DEPTH = 1200) (
  input wire clk1, clk2,
  input wire [WIDTH-1:0] address1, address2,
  input wire [WIDTH-1:0] wdata1, wdata2,
  input wire enw1, enw2,
  output wire [WIDTH-1:0] rdata1, rdata2
);

  localparam ADDROFFSET = 206800;

  logic [WIDTH-1:0] memory [DEPTH-1:0];
  logic [WIDTH-1:0] system_control[1:0];

  // read
  assign rdata1 = memory[address1-ADDROFFSET];
  assign rdata2 = memory[address2-ADDROFFSET];
  // write1
  always_ff @(posedge clk1)
    if (enw1) begin
      if (address1-ADDROFFSET < 1200)
        memory[address1-ADDROFFSET] <= wdata1;
      else if (address1 == 411698)
        system_control[0] <= wdata1;
      else if (address1 == 411699)
        system_control[1] <= wdata1;
    end
  // write1
  always_ff @(posedge clk2)
    if (enw2) begin
      if (address2-ADDROFFSET < 1200)
        memory[address2-ADDROFFSET] <= wdata2;
      else if (address2 == 411698)
        system_control[0] <= wdata2;
      else if (address2 == 411699)
        system_control[1] <= wdata2;
    end

endmodule