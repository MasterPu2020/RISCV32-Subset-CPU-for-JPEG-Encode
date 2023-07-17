module tb_uart;

  `timescale 1ns/10ps

  logic clk, nrst, datai, datao, wram, enw1;
  logic [31:0] rramdata, ramaddress, wramdata;
  logic [31:0] address1, wdata1, rdata1;

  uart uart(.clk, .nrst, .datai, 
    .rramdata, 
    .datao, .wram,
    .ramaddress, .wramdata
  );
  ram #(32, 32'h00070002) ram(.address1, .address2(ramaddress), 
    .wdata1, .wdata2(wramdata),
    .enw1, .enw2(wram),
    .rdata1, .rdata2(rramdata)
  );

  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk = ~clk;
  initial begin
    datai = 1;
    enw1 = 1; wdata1 = 0; address1 = 32'h00070000;
    nrst<=1; clk<=0;
    #1 nrst<=0; #1 nrst<=1;
  end

  // test start
  initial begin
    #CLK_PERIOD;
    repeat(8) begin // load data 32'hF0F0F0F0 x2
      #CLK_PERIOD datai = 0;
      // enter receive state
      repeat(4) #CLK_PERIOD datai = 1;
      repeat(4) #CLK_PERIOD datai = 0;
      #CLK_PERIOD datai = 1;
    end
    // enter idle state
    #(CLK_PERIOD) enw1 = 1; wdata1 = 0; address1 = 2;
    #(CLK_PERIOD) enw1 = 1; wdata1 = 1; address1 = 32'h00070000;
    $display("mem[0]: %h", ram.memory[0],
      "\nmem[1]: %h", ram.memory[1],
      "\nmem[2]: %h", ram.memory[2]);
    // enter send and post send state
    #(CLK_PERIOD*10*8);
    // return idle state
    #(CLK_PERIOD*2) $finish(2);
  end

endmodule