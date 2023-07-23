//----------------------------------------------------------------
// SoC Button interface behavioural
// Support: Debounce
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module button #(CLKRATE = 25000000, DBMSEC = 150)(
  input wire clk, nrst, key,
  input wire [31:0] busaddr,
  output wire [31:0] busdata
);

  localparam DBMAX = (1000_000 * DBMSEC) / (1000_000_000 / CLKRATE) / 2;

  reg data;
  reg [$clog2(DBMAX):0] dbcnt;

  assign busdata = data;

  always_ff @(posedge clk, negedge nrst) 
    if (~nrst) begin
      data <= 0;
      dbcnt <= 0;
    end
    else begin
      if (busaddr == 411700) // buttom interface: 411700
        data <= 0;
      else if (~key) begin
        if (dbcnt <= DBMAX)
          dbcnt <= dbcnt + 1;
      end
      else if (dbcnt >= DBMAX) begin
        data <= 1;
        dbcnt <= 0;
      end
      else
        dbcnt <= 0;
    end
endmodule