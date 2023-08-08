//----------------------------------------------------------------
// RISCV SoC for Cyclone V DE1-SoC demonstration
// Last Modified Date: 2023/8/7
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

// button:  | reset | increase | switch | encode |
// LED:     [9]------>[0] process of program
// Segment: [5][4]: address [3][2][1][0]: half word data

module soc #(parameter CLK_RATE = 50_000_000) (
  input wire clock, nreset,
  input wire [2:0] button,
  output wire [6:0] seg [0:5],
  output logic [9:0] led
);

  localparam 
    WIDTH = 32, // bit
    ROM_DEPTH = 2500,    // word
    RAM_DEPTH = 100_000, // word
    CORE_RATE = 3_125_000, // hz (1/16 of 50Mhz clock)
    CORE_MAX = (CLK_RATE/CORE_RATE/2 - 1),
    DBMSEC = 150; // ms

  // clock divider
  logic [$clog2(CORE_MAX):0] core_cnt;
  logic clk_core;
  always_ff @(posedge clock, negedge nreset)
    if (~nreset) begin
      clk_core <= 0;
      core_cnt <= 0;
    end
    else begin
      // core clock
      if (core_cnt == CORE_MAX) begin
        clk_core <= ~ clk_core;
        core_cnt <= 0;
      end
      else
        core_cnt <= core_cnt + 1;
    end

  wire [31:0] programdata;
  wire [WIDTH-1:0] readramdata;
  wire writeram;
  wire [WIDTH-1:0] programaddress;
  wire [WIDTH-1:0] ramaddress;
  wire [WIDTH-1:0] writeramdata;

  core #(WIDTH) core(.clock(clk_core), .nreset, 
    .programdata, .readramdata, .writeram, .programaddress, .ramaddress, .writeramdata);
  
  rom #(WIDTH, ROM_DEPTH) rom(.address(programaddress), .rdata(programdata));
  
  panel #(WIDTH, RAM_DEPTH, CORE_RATE, DBMSEC) panel(
    .clk(clk_core), .nrst(nreset),
    .button,
    .address(ramaddress), .wdata(writeramdata), .enw(writeram), .rdata(readramdata),
    .seg);

  // pc monitor
  always_comb begin
    led = '1;
    if (programaddress < (1870 * 4)) // end of init
      led = 10'b1000000000;
    else if (programaddress < (1882 * 4)) // start of main
      led = 10'b0100000000;
    else if (programaddress < (2005 * 4)) // end of re-ordering
      led = 10'b0010000000;
    else if (programaddress < (2015 * 4)) // end of block subtraction
      led = 10'b0001000000;
    else if (programaddress < (2101 * 4)) // end of CORDIC
      led = 10'b0000100000;
    else if (programaddress < (2179 * 4)) // end of DCT
      led = 10'b0000010000;
    else if (programaddress < (2371 * 4)) // end of huffman encode
      led = 10'b0000001000;
    else if (programaddress < (2411 * 4)) // start of sampling
      led = 10'b0000000100;
    else if (programaddress < (2473 * 4)) // end of program
      led = 10'b0000000010;
    else
      led = 10'b0000000001;
  end

endmodule