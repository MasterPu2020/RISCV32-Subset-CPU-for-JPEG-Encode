//----------------------------------------------------------------
// JPEG encoding system on chip top module behavioural
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module soc (
  input wire clk, nrst, key, datai,
  output wire datao
);

  localparam 
    WIDTH = 32,
    ROMDEPTH = 2048; // ram: 0 ~ 411700

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

  wire [31:0] 
    slaveaddr0, slaverdata0, slavewdata0,
    slaveaddr1, slaverdata1, slavewdata1, 
    slaveaddr2, slaverdata2, slavewdata2;
  wire writeslave0, writeslave1, writeslave2;
  bus databus(.masteraddr(ramaddress), .masterwdata(writeramdata), .masterrdata(readramdata), .masterwrite(writeram), 
    .writeslave0, .writeslave1, .writeslave2,
    .slaveaddr0,  .slaveaddr1,  .slaveaddr2,
    .slaverdata0, .slaverdata1, .slaverdata2,
    .slavewdata0, .slavewdata1, .slavewdata2);

  buttom buttom(.clk(clkcore), .nrst, .key, .busaddr(slaveaddr2), .busdata(slaverdata2));

  wire [31:0] ramaddress2, wramdata2, rramdata2;
  wire wram2;
  uart uart(.clk(clkbps), .nrst, .datai, .rramdata(rramdata2), .datao, 
    .wram(wram2), .ramaddress(ramaddress2), .wramdata(wramdata2));

  ram ram(.clk(clkcore), .address(slaveaddr0), .wdata(slavewdata0), .enw(writeslave0), .rdata(slaverdata0));

  dualram dualram(
    .clk1(clkcore), .clk2(clkbps),
    .address1(slaveaddr1), .address2(ramaddress2),
    .wdata1(slavewdata1),  .wdata2(wramdata2), 
    .enw1(writeslave1),    .enw2(wram2),   
    .rdata1(slaverdata1),  .rdata2(rramdata2));

  rom #(WIDTH, ROMDEPTH) rom(.address(programaddress), .rdata(programdata));

endmodule