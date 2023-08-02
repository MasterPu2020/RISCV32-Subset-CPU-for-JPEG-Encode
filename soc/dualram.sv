//----------------------------------------------------------------
// Synchronous dual port static random access memory
// Support: 32-bit read and write, address add by 1
// Last Modified Date: 2023/7/23
// Version: 1.1
// Author: Clark Pu
//----------------------------------------------------------------

module dualram #(parameter WIDTH = 32, DEPTH = 1026) (
  input wire clk1, clk2, // clock 1 much faster than 2
  input wire [WIDTH-1:0] address1, address2,
  input wire [WIDTH-1:0] wdata1, wdata2,
  input wire enw1, enw2,
  output logic [WIDTH-1:0] rdata1, rdata2
);

  localparam ADDROFFSET = 206800;

  logic [WIDTH-1:0] memory [DEPTH-1:0];
  logic [WIDTH-1:0] system_control[1:0];

  logic clkbuff1, clkbuff2, clkbuff3, clkbuff4, is_edge;

  // asynchronous read
  always_comb begin
    rdata1 = 0;
    rdata2 = 0;
    if (address1-ADDROFFSET < 1200)
      rdata1 = memory[address1-ADDROFFSET];
    else if (address1 == 411698)
      rdata1 = system_control[0];
    else if (address1 == 411699)
      rdata1 = system_control[1];
    if (address2-ADDROFFSET < 1200)
      rdata2 = memory[address2-ADDROFFSET];
    else if (address2 == 411698)
      rdata2 = system_control[0];
    else if (address2 == 411699)
      rdata2 = system_control[1];
  end

  always_ff @(posedge clk1) begin
    // fast clock domain write
    if (enw1) begin
      if (address1-ADDROFFSET < 1200)
        memory[address1-ADDROFFSET] <= wdata1;
      else if (address1 == 411698)
        system_control[0] <= wdata1;
      else if (address1 == 411699)
        system_control[1] <= wdata1;
    end
    // slow clock domain write
    else if(is_edge) begin // only sample input when it is stable in fast clock domain
      if (enw2) begin
        if (address2-ADDROFFSET < 1200)
          memory[address2-ADDROFFSET] <= wdata2;
        else if (address2 == 411698)
          system_control[0] <= wdata2;
        else if (address2 == 411699)
          system_control[1] <= wdata2;
      end
    end
  end

  // slow clock domain synchronization buffer
  // metastable state risks all falls on 1-bit clk2 signal
  always_ff @(posedge clk1) begin
    clkbuff1 <= clk2;
    clkbuff2 <= clkbuff1; // input synchronization
    clkbuff3 <= clkbuff2;
    clkbuff4 <= clkbuff3;
    if (clkbuff3 & (~clkbuff4)) // rising edge detect
      is_edge <= 1;
    else
      is_edge <= 0;
  end

endmodule