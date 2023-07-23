//----------------------------------------------------------------
// ALU behavioural
// Last Modified Date: 2023/7/23
// Version: 1.1 : higher bit multiplier bug fixed
// Author: Clark Pu
//----------------------------------------------------------------

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