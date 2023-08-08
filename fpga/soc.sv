//----------------------------------------------------------------
// RISCV SoC for Cyclone V DE1-SoC demonstration
// Last Modified Date: 2023/8/7
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module soc #(parameter CLK_RATE = 50_000_000) (
  input wire clock, nreset,
  input wire button[2:0],
  output wire [6:0] seg [0:5],
  output logic [9:0] led
);

  localparam 
    WIDTH = 32, // bit
    ROM_DEPTH = 2500,    // word
    RAM_DEPTH = 100_000, // word
    CORE_RATE = 6_250_000, // hz (1/8 of 50Mhz clock)
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
  localparam PROGRESS = 10'b10_0000_0000;
  always_comb begin
    led = '1;
    if (programaddress < (ROM_DEPTH/10))
      led = PROGRESS;
    else if (programaddress < (ROM_DEPTH/10*2))
      led = PROGRESS >> 1;
    else if (programaddress < (ROM_DEPTH/10*3))
      led = PROGRESS >> 2;
    else if (programaddress < (ROM_DEPTH/10*4))
      led = PROGRESS >> 3;
    else if (programaddress < (ROM_DEPTH/10*5))
      led = PROGRESS >> 4;
    else if (programaddress < (ROM_DEPTH/10*6))
      led = PROGRESS >> 5;
    else if (programaddress < (ROM_DEPTH/10*7))
      led = PROGRESS >> 6;
    else if (programaddress < (ROM_DEPTH/10*8))
      led = PROGRESS >> 7;
    else if (programaddress < (ROM_DEPTH/10*9))
      led = PROGRESS >> 8;
    else
      led = PROGRESS >> 9;
  end

endmodule