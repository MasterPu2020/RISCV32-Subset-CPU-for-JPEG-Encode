//----------------------------------------------------------------
// SoC Buttom interface behavioural
// Support: Debounce
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module buttom #(CLKRATE = 25000000, DBMSEC = 150)(
  input wire clk, nrst, key,
  input wire [31:0] busaddr,
  output wire [31:0] busdata
);

  localparam DBMAX = CLKRATE / 1000 * DBMSEC;

  reg data;
  reg [$clog2(DBMAX):0] dbcnt;

  assign busdata = data;

  always_ff @(posedge clk, negedge nrst) 
    if (~nrst)
      data <= 0;
    else 
      if (busaddr == 411700) // buttom interface: 411700
        data <= 0;
      else if (~key)
        if (dbcnt <= DBMAX)
          dbcnt <= dbcnt + 1;
      else if (dbcnt >= DBMAX) begin
        data <= 1;
        dbcnt <= 0;
      end
      else
        dbcnt <= 0;

endmodule