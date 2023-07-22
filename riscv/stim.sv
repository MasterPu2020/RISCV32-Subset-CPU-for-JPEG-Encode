
// out of date warning: never been updatad since its first stim test

// `define enable_monitor

module stim;
  logic clk;
  logic nrst;
  `timescale 1ns/10ps

  riscv32s riscv32s(.clock(clk), .nreset(nrst));

  localparam CLK_PERIOD = 10;
  always #(CLK_PERIOD/2) clk = ~clk;

  `ifdef enable_monitor
    initial $monitor(
      "\ndata ram[0] is: %0d", $signed(riscv32s.ram.memory[0]),
      "\ndata x1 is: %0d", $signed(riscv32s.riscvcore.regfile.x[1]),
      "\ndata x2 is: %0d", $signed(riscv32s.riscvcore.regfile.x[2]),
      "\ndata x3 is: %0d", $signed(riscv32s.riscvcore.regfile.x[3]),
      "\ndata x4 is: %0d", $signed(riscv32s.riscvcore.regfile.x[4])
    );
  `endif

  // write mem.log
  task memlog(input string fdir, bit showinfor);
    integer fd, error, memlen;
    string errinfor;
    memlen = riscv32s.RAMDEPTH; // from hierachy get data
    fd = $fopen(fdir, "w+");
    error = $ferror(fd, errinfor);
    assert (error == 0) else begin
      $display(" [System]: Error: File descriptor: %h.", fd );
      $display(" [System]: Error number:    %0d.", error );
      $display(" [System]: Error info:      %s.", errinfor );
      $stop(1);
    end
    if (showinfor)
      $display(" [System]: Write log start, file opened. %0d words", memlen);
    $fdisplay(fd, "\n[RAM DATA LOG]: created by system verilog testbench.\n");
    for (int w = 0; w <= memlen; w ++)
      $fdisplay(fd, "[%0d] : %0d", w, $signed(riscv32s.ram.memory[w]));
    $fclose(fd);
    if (showinfor)
      $display(" [System]: Write log finished, file closed.");
  endtask

  // program monitor
  task moni();
    logic [31:0] inst;
    logic signed [31:0] imm;
    logic [31:0] pc, newpc;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic [4:0] rd, rs1, rs2;
    inst = riscv32s.rom.rdata;
    opcode = riscv32s.riscvcore.operation;
    funct7 = riscv32s.riscvcore.function7;
    funct3 = riscv32s.riscvcore.function3;
    pc = riscv32s.riscvcore.programaddress;
    newpc = riscv32s.riscvcore.newpc;
    rd  = riscv32s.riscvcore.rd;
    rs1 = riscv32s.riscvcore.rs1;
    rs2 = riscv32s.riscvcore.rs2;
    imm = riscv32s.riscvcore.immextend.imm;
    if (opcode == 7'b0110011)
      case (funct7)
        7'b0000000:
          case (funct3)
            3'b000: $display(" [Core] r%0d + r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
            3'b111: $display(" [Core] r%0d & r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
            3'b110: $display(" [Core] r%0d | r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
            3'b001: $display(" [Core] r%0d << r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
            default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
          endcase
        7'b0100000: 
          if (funct3 == 3'b101) $display(" [Core] r%0d >> r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
          else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
        7'b0000001: 
          if (funct3 == 3'b000) $display(" [Core] r%0d *l r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
          else if (funct3 == 3'b001) $display(" [Core] r%0d *h r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>4);
          else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
        default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
      endcase
    else if (opcode == 7'b0010011)
      if (funct3 == 3'b000) 
        $display(" [Core] r%0d + %0d-> r%0d. pc=%0d", rs1, imm, rd, pc>>4);
      else if (funct3 == 3'b110) 
        $display(" [Core] r%0d ^ %0d-> r%0d. pc=%0d", rs1, imm, rd, pc>>4);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
    else if (opcode == 7'b0000011)
      if (funct3 == 3'b010) 
        $display(" [Core] mem[ r%0d + %0d ] -> r%0d. pc=%0d", rs1, imm, rd, pc>>4);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
    else if (opcode == 7'b0100011)
      if (funct3 == 3'b010) 
        $display(" [Core] r%0d -> mem[ r%0d + %0d ]. pc=%0d", rs2, rs1, imm, pc>>4);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
    else if (opcode == 7'b1100011)
      case (funct3)
        3'b000: $display(" [Core] r%0d == r%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>4, imm>>>2, newpc>>4, pc>>4);
        3'b001: $display(" [Core] r%0d != r%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>4, imm>>>2, newpc>>4, pc>>4);
        3'b100: $display(" [Core] r%0d <  r%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>4, imm>>>2, newpc>>4, pc>>4);
        3'b101: $display(" [Core] r%0d >= r%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>4, imm>>>2, newpc>>4, pc>>4);
        default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
      endcase
    else if (inst != 'x) $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>4);
  endtask

  initial begin
    nrst<=1; clk<=0;
    #1 nrst<=0; #1 nrst<=1;
    forever @(posedge clk) moni();
  end
  
  initial begin
    #(CLK_PERIOD * 50);
    memlog("../riscv/mem.log", 1);
    $finish(2);
  end

endmodule
