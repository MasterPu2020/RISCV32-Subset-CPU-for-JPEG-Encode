//----------------------------------------------------------------
// Asynchronous single port read-only memory behavioural
// Support: 32-bit read
// Last Modified Date: 2023/7/16
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module rom #(parameter WIDTH = 32, DEPTH = 2048) (
  input wire [WIDTH-1:0] address,
  output wire [WIDTH-1:0] rdata
);

  wire [WIDTH-1:0] memory [DEPTH-1:0];
  assign rdata = memory[address[WIDTH-1:2]];
  assign memory[ 0] = 32'b11111111011100000101000010010011; // x1 = -9 
  assign memory[ 1] = 32'b00000000101000001101000100010011; // x2 = 1 
  assign memory[ 2] = 32'b00000000001100000101000110010011; // x3 = 3 
  assign memory[ 3] = 32'b00000000001000001000001000110011; // x4 = -8 
  assign memory[ 4] = 32'b00000000001100010001001000110011; // x4 = 8 
  assign memory[ 5] = 32'b00000010001100001000001000110011; // x4 = -27 
  assign memory[ 6] = 32'b00000010001100001001001000110011; // x4 = -1 
  assign memory[ 7] = 32'b00000000001000001111001000110011; // x4 = 1 
  assign memory[ 8] = 32'b00000000001000001110001000110011; // x4 = -9 
  assign memory[ 9] = 32'b11111111111100010110001000010011; // x4 = -2
  assign memory[10] = 32'b01000000001000001101001000110011; // x4 = -5
  assign memory[11] = 32'b00000000000000000000010001100011;
  assign memory[12] = 32'b00111110011100000101111110010011;
  assign memory[13] = 32'b00000000000000100001010001100011;
  assign memory[14] = 32'b00110111100000000101111100010011;
  assign memory[15] = 32'b00000000000000100100010001100011;
  assign memory[16] = 32'b00110000100100000101111010010011;
  assign memory[17] = 32'b00000000010000000101010001100011;
  assign memory[18] = 32'b00101001101000000101111000010011;
  assign memory[19] = 32'b00000110010000000101001010010011; // x5 = 100
  assign memory[20] = 32'b00000000010100000010000000100011; // mem[0] = 100
  assign memory[21] = 32'b00000000000000000010001000000011; // x4 = 100
  assign memory[22] = 32'b11111010000000000000010011100011;

endmodule