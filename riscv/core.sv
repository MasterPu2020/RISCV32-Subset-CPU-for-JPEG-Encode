//----------------------------------------------------------------
// RISCV core of minimal RISCV subset for JEPG encoding
// Version: 1.0
// Last Modified Date: 2023/7/16
// Piepline stage: 2
// Bus protocal: Write back
// Author: Clark Pu
//----------------------------------------------------------------

module core #(parameter WIDTH = 32) (
  input wire clock, nreset,
  input wire [31:0] programdata,
  input wire [WIDTH-1:0] readramdata,
  output wire writeram,
  output wire [WIDTH-1:0] programaddress,
  output wire [WIDTH-1:0] ramaddress,
  output wire [WIDTH-1:0] writeramdata
);

  // instruction truncation
  wire [6:0] function7;
  wire [2:0] function3;
  wire [6:0] operation;
  wire [4:0] rs1, rs2, rd;
  assign function7 = programdata[31:25];
  assign function3 = programdata[14:12];
  assign operation = programdata[6:0];
  assign rs2 = programdata[24:20];
  assign rs1 = programdata[19:15];
  assign rd  = programdata[11:7];

  // program counter
  wire [WIDTH-1:0] newpc;
  pc #(WIDTH) pc(.clk(clock), .nrst(nreset), .addressin(newpc), .addressout(programaddress));

  // main decoder
  wire memload, memstore, regwrite, aluimm;
  control control(.op(operation), .meml(memload), .mems(memstore), .regw(regwrite), .aluimm);
  assign writeram = memstore;

  // ALU operation decoder
  wire [13:0] aluoperation;
  alucontrol alucontrol(.funct7(function7), .funct3(function3), .op(operation), .aluop(aluoperation));

  // immediate number generator
  wire [WIDTH-1:0] imm;
  immextend #(WIDTH) immextend(.inst(programdata), .imm);

  // register file
  wire [WIDTH-1:0] readdata1, readdata2, writebackdata;
  regfile #(WIDTH) regfile(.clk(clock), .nrst(nreset), .enw(regwrite), 
    .rs1addr(rs1), .rs2addr(rs2), .rdaddr(rd), 
    .rddata(writebackdata), .rs1data(readdata1), .rs2data(readdata2));
  
  // ALU immediate number mutilpexer
  wire [WIDTH-1:0] aludata2;
  mux #(WIDTH) immmux(.data1(imm), .data2(readdata2), .sel(aluimm), .datao(aludata2));

  // Arithmetic Logic Unit
  wire [WIDTH-1:0] result;
  wire zero;
  alu #(WIDTH) alu(.aluop(aluoperation), .datain1(readdata1), .datain2(aludata2), .result, .zero);

  // PC branch controller
  pccontrol #(WIDTH) pccontrol(.flag(zero), .pcoffset(imm), .pcin(programaddress), .pcout(newpc));

  // write back multiplexer
  mux #(WIDTH) wbmux(.data1(readramdata), .data2(result), .sel(memload), .datao(writebackdata));

  // read and write RAM address
  assign ramaddress = result;
  assign writeramdata = readdata2;

endmodule