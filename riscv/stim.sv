
// out of date warning: never been updatad since its first stim test

`define enable_monitor

module stim;
  logic clk;
  logic nrst;
  `timescale 1ns/10ps

  riscv32s riscv32s(.clock(clk), .nreset(nrst));

  int clkcycle = 0, error = 0;
  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk = ~clk;

  `ifdef enable_monitor
    initial $monitor(
      "\ndata ram[0] is: %d", $signed(riscv32s.ram.memory[0]),
      "\ndata x1 is: %d", $signed(riscv32s.riscvcore.regfile.x[1]),
      "\ndata x2 is: %d", $signed(riscv32s.riscvcore.regfile.x[2]),
      "\ndata x3 is: %d", $signed(riscv32s.riscvcore.regfile.x[3]),
      "\ndata x4 is: %d", $signed(riscv32s.riscvcore.regfile.x[4])
    );
  `endif

  initial begin
    nrst<=1; clk<=0;
    #1 nrst<=0; #1 nrst<=1;
  end

  initial begin
    #(CLK_PERIOD * 19);
    assert (riscv32s.ram.memory[0] == 100) else error ++;
    assert ($signed(riscv32s.riscvcore.regfile.x[1]) == -9) else error ++;
    assert ($signed(riscv32s.riscvcore.regfile.x[2]) == 1) else error ++;
    assert ($signed(riscv32s.riscvcore.regfile.x[3]) == 3) else error ++;
    assert ($signed(riscv32s.riscvcore.regfile.x[4]) == 100) else error ++;
    assert ($signed(riscv32s.riscvcore.regfile.x[5]) == 100) else error ++;
    if (error == 0)
      $display("\n [Simulation passed]\n");
    else
      $display("\n [Simulation failed]: error(s) = %d", error, "\n");
    $finish(2);
  end

endmodule
