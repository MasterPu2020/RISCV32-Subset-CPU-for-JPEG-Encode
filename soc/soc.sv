//----------------------------------------------------------------
// JPEG encoding system on chip top module behavioural
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module soc (
  input wire clk, nrst, key, datai,
  output wire data0
);

  localparam 
    WIDTH = 32,
    ROMDEPTH = 2048,
    RAMDEPTH = 411699; // ram: 0 ~ 411699

  wire clkcore, clkbps;
  clock clock(.clk, .nrst, .clkcore, .clkbps);

  wire [31:0] programdata;
  wire [WIDTH-1:0] readramdata;
  wire writeram;
  wire [WIDTH-1:0] programaddress;
  wire [WIDTH-1:0] ramaddress;
  wire [WIDTH-1:0] writeramdata;
  core #(WIDTH) riscvcore(.clock(clkcore), .nreset(nrst), 
    .programdata, .readramdata, .writeram, .programaddress, .ramaddress, .writeramdata);

  wire [31:0] slaveaddr0, slaverdata0, slavewdata0, slaveaddr1, slaverdata1, slavewdata1;
  wire writeslave0, writeslave1;
  bus databus(.masteraddr(ramaddress), .masterrdata(readramdata), .masterwdata(writeramdata), 
    .masterwrite(writeram), 
    .writeslave0, .writeslave1,
    .slaveaddr0,  .slaveaddr1,
    .slaverdata0, .slaverdata1,
    .slavewdata0, .slavewdata1);

  button button(.clk(clkcore), .nrst, .key, .busaddr(slaveaddr1), .busdata(slaverdata1));

  wire [31:0] ramaddress2, wramdata2, rramdata2;
  wire wram2;
  uart uart(.clk(clkbps), .nrst, .datai, .rramdata(rramdata2), .datao, 
    .wram(wram2), .ramaddress(ramaddress2), .wramdata(wramdata2));

  ram #(WIDTH, RAMDEPTH) ram(
    .address1(slaveaddr0), .address2(ramaddress2),
    .wdata1(slavewdata0),  .wdata2(wramdata2), 
    .enw1(writeslave0),    .enw2(wram2),   
    .rdata1(slaverdata0),  .rdata2(rramdata2));

  rom #(WIDTH, ROMDEPTH) rom(.address(programaddress), .rdata(programdata));

endmodule