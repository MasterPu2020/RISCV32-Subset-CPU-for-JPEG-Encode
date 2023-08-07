//----------------------------------------------------------------
// Synchronous single port static random access memory on FPGA
// Last Modified Date: 2023/8/7
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module ram #(parameter WIDTH = 32, DEPTH = 100_000) (
  input  wire clk, enw,
  input  wire [WIDTH-1:0] address,
  input  wire [WIDTH-1:0] wdata,
  output logic [WIDTH-1:0] rdata
);

  // using RAM resource on FPGA
  logic [WIDTH-1:0] memory [0:DEPTH]; 
  always_ff @(posedge clk) begin 
    rdata <= memory[address];
    if (enw)
      memory[address] <= wdata;
  end

endmodule