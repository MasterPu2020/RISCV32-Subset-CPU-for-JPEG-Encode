//----------------------------------------------------------------
// RISCV core of minimal RISCV subset for JEPG encoding
// Version: 1.2 adjust for synchronous RAM
// Last Modified Date: 2023/8/7
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
  wire stall;
  pc #(WIDTH) pc(.clk(clock), .nrst(nreset), .stall, .addressin(newpc), .addressout(programaddress));

  // main decoder
  wire memload, memstore, regwrite, aluimm;
  control control(.clk(clock), .nrst(nreset), .op(operation), .meml(memload), .mems(memstore), .regw(regwrite), .aluimm, .stall);
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
  wire signed [WIDTH-1:0] result;
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

module pc #(WIDTH = 32) (
  input wire clk, nrst, stall,
  input wire [WIDTH-1:0] addressin,
  output reg [WIDTH-1:0] addressout
);

  always_ff @(posedge clk, negedge nrst)
    if (~nrst)
      addressout <= 0;
    else if (~stall)
      addressout <= addressin;

endmodule

module control (
  input wire clk, nrst,
  input wire [6:0] op,
  output wire meml, mems, regw, aluimm, stall
);

  assign meml = op[6:4] == 3'b000;
  assign mems = op[6:4] == 3'b010;
  assign regw = (op[5:4] != 2'b10);
  assign aluimm = (~op[6]) & (op[5:4] != 2'b11);

  // pipeline stall for synchronous RAM read logic:
  // pc   : 0 | 1 | 1 | 2 |
  // meml : 0 | 1 | 1 | 0 |
  // state: F | F | S | F |
  // stall: 0 | 1 | 0 | 0 |
  //               or | 2 | 2 |
  //                  | 1 | 1 |
  //                  | F | S |
  //                  | 1 | 0 |

  enum {STALL, FLOW} state;

  assign stall = (meml && state == FLOW) ? 1 : 0;

  always_ff @(posedge clk, negedge nrst) begin
    if (~nrst)
      state <= FLOW;
    else
      case (state)
        FLOW:  if (meml) state <= STALL;
        STALL: state <= FLOW;
        default: state <= FLOW;
      endcase
  end

endmodule

module alucontrol (
  input wire [6:0] funct7,
  input wire [2:0] funct3,
  input wire [6:0] op,
  output wire [13:0] aluop
);

  logic ADD, SLL, SRA, XOR, AND, OR, MUL, MULH, RBUS0;
  logic EQ, NE, LT, GE, BBUS0;

  // B type
  assign EQ = op[6] & ~funct3[2] & ~funct3[0];
  assign NE = op[6] & ~funct3[2] &  funct3[0];
  assign LT = op[6] &  funct3[2] & ~funct3[0];
  assign GE = op[6] &  funct3[2] &  funct3[0];
  assign BBUS0 = ~op[6];

  // ALU
  assign RBUS0 = op[6];
  always_comb begin
    ADD  = 0;
    SLL  = 0;
    SRA  = 0;
    XOR  = 0;
    AND  = 0;
    OR   = 0;
    MUL  = 0;
    MULH = 0;
    if (~op[6])
      if (op[5:4] == 2'b11) // R type
        case (funct3)
          3'b000 : begin ADD  = ~funct7[0]; MUL  = funct7[0]; end
          3'b111 : AND  = 1;
          3'b110 : OR   = 1;
          3'b001 : begin SLL  = ~funct7[0]; MULH = funct7[0]; end
          3'b101 : SRA  = 1;
        endcase
      else if (funct3 == 3'b110) // I type: only one xori
        XOR = 1;
      else // S type
        ADD = 1;
  end

  assign aluop = {
    ADD, SLL, SRA, XOR, AND, OR, MUL, MULH, RBUS0, 
    EQ, NE, LT, GE, BBUS0};

endmodule

module immextend #(WIDTH = 32) (
  input wire [31:0] inst,
  output logic [WIDTH-1:0] imm
);

  // this core doesn't contain a J type
  wire [11:0] immi, imms, immb;
  assign immb = {inst[31], inst[7], inst[30:25], inst[11:8]};
  assign imms = {inst[31:25], inst[11:7]};
  assign immi = inst[31:20];

  always_comb begin
    imm = 0;
    case (inst[6:4])
      3'b001: imm = {{(WIDTH-12){immi[11]}}, immi}; // I type
      3'b000: imm = {{(WIDTH-12){immi[11]}}, immi}; // I type
      3'b010: imm = {{(WIDTH-12){imms[11]}}, imms}; // S type
      3'b110: imm = {{(WIDTH-13){immb[11]}}, immb, 1'b0}; // B type
    endcase
  end

endmodule

module regfile #(parameter WIDTH = 32) (
  input wire clk, nrst, enw,
  input wire [4:0] rs1addr, rs2addr, rdaddr,
  input wire [WIDTH-1:0] rddata,
  output wire [WIDTH-1:0] rs1data, rs2data
);

  // register file
  reg [WIDTH-1:0] x [31:0];

  // read
  assign rs1data = x[rs1addr];
  assign rs2data = x[rs2addr];

  // write
  always_ff @(posedge clk, negedge nrst) begin
    if (~nrst)
      for(int addr = 0; addr < 32; addr = addr + 1)
        x[addr] <= 0;
    else begin
      if (rdaddr != 0 && enw)
        x[rdaddr] <= rddata;
    end
  end

endmodule

module mux #(parameter WIDTH = 32) (
  input wire [WIDTH-1:0] data1, data2,
  input wire sel,
  output wire [WIDTH-1:0] datao
);

  assign datao = sel ? data1 : data2;

endmodule

module alu #(parameter WIDTH = 32)(
  input wire [13:0] aluop,
  input wire signed [WIDTH-1:0] datain1, datain2,
  output wire signed [WIDTH-1:0] result,
  output wire zero
);

  wire signed [2*WIDTH-1:0] databus;
  wire signed [2*WIDTH-1:0] data1, data2;
  // extend signed bit
  assign data1 = {{WIDTH{datain1[WIDTH-1]}}, datain1};
  assign data2 = {{WIDTH{datain2[WIDTH-1]}}, datain2};
  // result: aluop[13:5] = {13:ADD, 12:SLL, 11:SRA, 10:XOR, 9:AND, 8:OR, 7:MUL, 6:MULH, 5:RBUS0} 
  assign databus = aluop[13] ? datain1 + datain2 : 'z;
  assign databus = aluop[12] ? datain1 << datain2[4:0] : 'z;
  assign databus = aluop[11] ? {{WIDTH{datain1[WIDTH-1]}}, (datain1 >>> datain2[4:0])} : 'z; // arithmetic shift doesn't works, don't know why
  assign databus = aluop[10] ? datain1 ^ datain2 : 'z;
  assign databus = aluop[ 9] ? datain1 & datain2 : 'z;
  assign databus = aluop[ 8] ? datain1 | datain2 : 'z;
  assign databus = (aluop[7] | aluop[6]) ? data1 * data2 : 'z;
  assign databus = aluop[ 5] ? '0 : 'z;
  assign result[WIDTH-2:0]  = aluop[6] ? databus[2*WIDTH-1:WIDTH-1] : databus[WIDTH-2:0]; // bug located
  assign result[WIDTH-1]  = aluop[7] | aluop[6] ? databus[2*WIDTH-1] : databus[WIDTH-1];
  // branch flag: aluop[4:0] = {4:EQ, 3:NE, 2:LT, 1:GE, 0:BBUS0}
  wire equal, less;
  assign equal = data1 == data2;
  assign less = data1 < data2;
  assign zero = aluop[ 4] ?  equal : 'z;
  assign zero = aluop[ 3] ? ~equal : 'z;
  assign zero = aluop[ 2] ?   less : 'z;
  assign zero = aluop[ 1] ? ~less | equal : 'z;
  assign zero = aluop[ 0] ? 0 : 'z;

endmodule

module pccontrol #(parameter WIDTH = 32) (
  input wire flag,
  input wire [WIDTH-1:0] pcoffset,
  input wire [WIDTH-1:0] pcin,
  output wire [WIDTH-1:0] pcout
);

  assign pcout = flag ? pcin + pcoffset : pcin + 4;

endmodule