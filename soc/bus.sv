//----------------------------------------------------------------
// Core write back bus behavioural
// Support: CPU write back distribution
// Last Modified Date: 2023/7/18
// Version: 1.1
// Author: Clark Pu
//----------------------------------------------------------------

module bus(
  // either read nor write
  input  logic [31:0] masteraddr, masterwdata,
  output logic [31:0] masterrdata,
  input  logic masterwrite,
  output logic writeslave0, writeslave1, writeslave2,
  output logic [31:0] slaveaddr0,  slaveaddr1,  slaveaddr2, 
  input  logic [31:0] slaverdata0, slaverdata1, slaverdata2,
  output logic [31:0] slavewdata0, slavewdata1, slavewdata2 
);

  always_comb begin
    masterrdata = 0;
    writeslave0 = 0;
    writeslave1 = 0;
    slavewdata0 = masterwdata;
    slavewdata1 = masterwdata;
    slaveaddr0 = masteraddr;
    slaveaddr1 = masteraddr;
    if (masteraddr < 206800) // ram: 0 ~ 206799
      masterrdata = slaverdata0;
      if (masterwrite)
        writeslave0 = 1;
    else if (masteraddr < 411700) // dual-ram: 206800 ~ 411699
      masterrdata = slaverdata1;
      if (masterwrite)
        writeslave1 = 1;
    else if (masteraddr < 411701) // buttom interface: 411700
      masterrdata = slaverdata2;
      if (masterwrite)
        writeslave2 = 1;
  end

endmodule