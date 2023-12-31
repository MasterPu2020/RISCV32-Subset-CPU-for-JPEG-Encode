//----------------------------------------------------------------
// Synchronous single port static random access memory
// Support: separate 8-bit, 16-bit and 32-bit read and write, no reset
// Last Modified Date: 2023/7/18
// Version: 1.2
// Author: Clark Pu
//----------------------------------------------------------------

`define Simulation

module ram #(parameter WIDTH = 32) (
  input wire clk,
  input wire [WIDTH-1:0] address,
  input wire [WIDTH-1:0] wdata,
  input wire enw,
  output logic [WIDTH-1:0] rdata
);

  // special memory for FPGA
  reg [15:0] constant [0:1207]; //    0 - 1207
  reg [31:0] block [0:328];     // 1208 - 1536
  reg [24:0] row [0:1024];      // 2000 - 3024

  // simulation only
  `ifdef Simulation
    wire [31:0] memory [0:206800];
    generate
      for (genvar i = 0; i < 206800; i++) begin
        if (i <= 1207)
          assign memory[i] = constant[i];
        else if (i <= 1536)
          assign memory[i] = block[i - 1208];
        else if (i <= 3024)
          assign memory[i] = row[i - 2000];
        else 
          assign memory[i] = 'x;
      end
    endgenerate
  `endif

  always_comb begin
    rdata = 0;
    if (address <= 1207)
      rdata = constant[address];
    else if (address <= 1536)
      rdata = block[address - 1208];
    else if (address >= 2000 && address <= 3024)
      rdata = row[address - 2000];
  end

  always_ff @(posedge clk)
    if (enw) begin
      if (address <= 1207)
        constant[address] <= wdata;
      else if (address <= 1536)
        block[address - 1208] <= wdata;
      else if (address >= 2000 && address <= 3024)
        row[address - 2000] <= wdata;
    end

endmodule