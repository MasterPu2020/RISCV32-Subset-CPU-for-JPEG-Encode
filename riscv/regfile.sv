//----------------------------------------------------------------
// Register File behavioural
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module regfile #(parameter WIDTH = 32) (
  input wire clk, nrst, enw,
  input wire [4:0] rs1addr, rs2addr, rdaddr,
  input wire [WIDTH-1:0] rddata,
  output wire [WIDTH-1:0] rs1data, rs2data
);

  // register file
  reg [WIDTH-1:0] x [31:0];

  // read
  assign rs1data = x[rs1addr];
  assign rs2data = x[rs2addr];

  // write
  always_ff @(posedge clk, negedge nrst) begin
    if (~nrst)
      for(int addr = 0; addr < 32; addr = addr + 1)
        x[addr] <= 0;
    else begin
      if (rdaddr != 0 && enw)
        x[rdaddr] <= rddata;
    end
  end

endmodule