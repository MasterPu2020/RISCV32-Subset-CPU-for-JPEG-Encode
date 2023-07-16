module testbench;
  logic clk;
  logic nrst;
  `timescale 1ns/10ps

  riscv32s riscv32s(.clock(clk), .nreset(nrst));

  int clkcycle = 0;
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk = ~clk;

  initial begin
    $monitor("data ram[0] is: %d", riscv32s.ram.memory[0]);
    $monitor("data x1 is: %d", riscv32s.riscvcore.regfile.x[1]);
    $monitor("data x2 is: %d", riscv32s.riscvcore.regfile.x[2]);
    $monitor("data x3 is: %d", riscv32s.riscvcore.regfile.x[3]);
    $monitor("data x4 is: %d", riscv32s.riscvcore.regfile.x[4]);
    #1 nrst<='x;clk<='x;
    #(CLK_PERIOD/4) nrst<=1;
    #(CLK_PERIOD/4) nrst<=0;clk<=0;
    #(CLK_PERIOD/4) nrst<=1;
    #(CLK_PERIOD * 50);
    $finish(2);
  end

endmodule
