//----------------------------------------------------------------
// SoC Clock generator behavioural
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module clock #(parameter CLKRATE = 50_000_000, BAUDRATE = 9600, CORERATE = 12_500_000) (
  input wire clk, nrst,
  output logic clkcore, clkbps
);

  localparam 
    COREMAX = (CLKRATE/CORERATE/2 - 1),
    BPSMAX = (CLKRATE/BAUDRATE/2 - 1);
  reg [$clog2(COREMAX):0] corecnt;
  reg [$clog2(BPSMAX):0] bpscnt;

  always_ff @(posedge clk, negedge nrst)
    if (~nrst) begin
      clkcore <= 0;
      clkbps <= 0;
      bpscnt <= 0;
      corecnt <= 0;
    end
    else begin
      // core clock
      if (corecnt == COREMAX) begin
        clkcore <= ~ clkcore;
        corecnt <= 0;
      end
      else
        corecnt <= corecnt + 1;
      // uart clock
      if (bpscnt == BPSMAX) begin
        clkbps <= ~ clkbps;
        bpscnt <= 0;
      end
      else
        bpscnt <= bpscnt + 1;  
    end

endmodule