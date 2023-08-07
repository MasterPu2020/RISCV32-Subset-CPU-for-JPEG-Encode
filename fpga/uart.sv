//----------------------------------------------------------------
// SoC UART interface test
// Last Modified Date: 2023/8/3
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module uart (
  input wire clk,
  input wire vdd, gnd,
  inout wire data_i,
  output logic data_o,
  output logic [3:0] led
);

  // set_location_assignment PIN_AF14 -to clk   # 50MHz clock
  // set_location_assignment PIN_V16  -to led[0]
  // set_location_assignment PIN_W16  -to led[1]
  // set_location_assignment PIN_V17  -to led[2]
  // set_location_assignment PIN_V18  -to led[3]
  // set_location_assignment PIN_AF18 -to data_i # GPIO_0[D32] : GPIO[37]   |...          |
  // set_location_assignment PIN_AG20 -to data_o # GPIO_0[D33] : GPIO[38]   |data_i data_o|
  // set_location_assignment PIN_AG18 -to vdd    # GPIO_0[D34] : GPIO[39]   |vdd       gnd|
  // set_location_assignment PIN_AJ21 -to gnd    # GPIO_0[D35] : GPIO[40]   +-------------+ GPIO0
  
  assign led = {vdd, gnd, data_i, data_o};
  assign data_i = data_o ? 'z : 0;

  logic [8:0] cnt; // 511 * 20 ns

  always_ff @(posedge clk) begin
    if(vdd == 1 && gnd == 0) begin
      if (cnt != '1) begin
        cnt <= cnt + 1;
        data_o <= 0;
      end
      else
        data_o <= 1;
    end
    else begin
      cnt <= 0;
      data_o <= 0;
    end
  end

endmodule