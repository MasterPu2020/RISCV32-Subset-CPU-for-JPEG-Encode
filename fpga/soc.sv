//----------------------------------------------------------------
// RISCV SoC for Cyclone V DE1-SoC demonstration
// Last Modified Date: 2023/8/7
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module soc (
  input wire clock, nreset,
  input wire button[2:0],
  output wire [6:0] seg [0:5],
  output logic [9:0] led
);

  localparam 
    WIDTH = 32, // bit
    ROMDEPTH = 2000,    // word
    RAMDEPTH = 100_000, // word
    CLKRATE = 25000000, // hz
    DBMSEC = 150; // ms

  wire [31:0] programdata;
  wire [WIDTH-1:0] readramdata;
  wire writeram;
  wire [WIDTH-1:0] programaddress;
  wire [WIDTH-1:0] ramaddress;
  wire [WIDTH-1:0] writeramdata;

  core #(WIDTH) core(.clock, .nreset, 
    .programdata, .readramdata, .writeram, .programaddress, .ramaddress, .writeramdata);
  
  rom #(WIDTH, ROMDEPTH) rom(.address(programaddress), .rdata(programdata));
  
  panel #(WIDTH, RAMDEPTH, CLKRATE, DBMSEC) panel(
    .clk(clock), .nrst(nreset),
    .button,
    .address(ramaddress), .wdata(writeramdata), .enw(writeram), .rdata(readramdata),
    .seg);

  // pc monitor
  localparam PROGRESS = 10'b10_0000_0000;
  always_comb begin
    led = '1;
    if (programaddress < (ROMDEPTH/10))
      led = PROGRESS;
    else if (programaddress < (ROMDEPTH/10*2))
      led = PROGRESS >> 1;
    else if (programaddress < (ROMDEPTH/10*3))
      led = PROGRESS >> 2;
    else if (programaddress < (ROMDEPTH/10*4))
      led = PROGRESS >> 3;
    else if (programaddress < (ROMDEPTH/10*5))
      led = PROGRESS >> 4;
    else if (programaddress < (ROMDEPTH/10*6))
      led = PROGRESS >> 5;
    else if (programaddress < (ROMDEPTH/10*7))
      led = PROGRESS >> 6;
    else if (programaddress < (ROMDEPTH/10*8))
      led = PROGRESS >> 7;
    else if (programaddress < (ROMDEPTH/10*9))
      led = PROGRESS >> 8;
    else
      led = PROGRESS >> 9;
  end

endmodule