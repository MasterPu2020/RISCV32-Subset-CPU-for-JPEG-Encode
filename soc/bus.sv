//----------------------------------------------------------------
// Core write back bus behavioural
// Support: CPU write back distribution
// Last Modified Date: 2023/7/18
// Version: 1.1
// Author: Clark Pu
//----------------------------------------------------------------

module bus(
  input  logic [31:0] masteraddr, masterwdata,
  output logic [31:0] masterrdata,
  input  logic masterwrite,
  output logic writeslave0, writeslave1, writeslave2,
  output logic [31:0] slaveaddr0,  slaveaddr1,  slaveaddr2, 
  input  logic [31:0] slaverdata0, slaverdata1, slaverdata2,
  output logic [31:0] slavewdata0, slavewdata1, slavewdata2 
);

  // either read nor write
  always_comb begin
    masterrdata = 0;
    writeslave0 = 0;
    writeslave1 = 0;
    writeslave2 = 0;
    slavewdata0 = 0;
    slavewdata1 = 0;
    slavewdata2 = 0;
    slaveaddr0  = 0;
    slaveaddr1  = 0;
    slaveaddr2  = 0;
    if (masteraddr < 206800) begin // ram: 0 ~ 206799
      masterrdata = slaverdata0;
      slaveaddr0 = masteraddr;
      slavewdata0 = masterwdata;
      if (masterwrite)
        writeslave0 = 1;
    end
    else if (masteraddr < 411700) begin // dual-ram: 206800 ~ 411699
      masterrdata = slaverdata1;
      slaveaddr1 = masteraddr;
      slavewdata1 = masterwdata;
      if (masterwrite)
        writeslave1 = 1;
    end
    else if (masteraddr < 411701) begin // buttom interface: 411700
      masterrdata = slaverdata2;
      slaveaddr2 = masteraddr;
      slavewdata2 = masterwdata;
      if (masterwrite)
        writeslave2 = 1;
    end
  end

endmodule