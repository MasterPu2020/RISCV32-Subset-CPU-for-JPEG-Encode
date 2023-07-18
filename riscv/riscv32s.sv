//----------------------------------------------------------------
// RISCV SoC for test
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module riscv32s (
  input clock, nreset
);

  localparam 
    WIDTH = 32,
    ROMDEPTH = 2048,
    RAMDEPTH = 9999;

  wire [31:0] programdata;
  wire [WIDTH-1:0] readramdata;
  wire writeram;
  wire [WIDTH-1:0] programaddress;
  wire [WIDTH-1:0] ramaddress;
  wire [WIDTH-1:0] writeramdata;

  core #(WIDTH) riscvcore(.clock, .nreset, 
    .programdata, .readramdata, .writeram, .programaddress, .ramaddress, .writeramdata);
  rom #(WIDTH, ROMDEPTH) rom(.address(programaddress), .rdata(programdata));
  ram #(WIDTH, RAMDEPTH) ram(.clk(clock), .address(ramaddress), .wdata(writeramdata), .enw(writeram), .rdata(readramdata));

endmodule