
`timescale 1ns/10ps

module stim;
  logic clk;
  logic nrst;

  riscv32s riscv32s(.clock(clk), .nreset(nrst));

  localparam CLK_PERIOD = 20;
  always #(CLK_PERIOD/2) clk = ~clk;

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

  function [31:0] get_program_len;
    input string fdir;
    integer fd, error, memlen;
    string errinfor, c;
    get_program_len = 0;
    fd = $fopen(fdir, "r");
    error = $ferror(fd, errinfor);
    assert (error == 0) else begin
      $display(" [System]: Error: File descriptor: %h.", fd );
      $display(" [System]: Error number:    %0d.", error );
      $display(" [System]: Error info:      %s.", errinfor );
      $stop(1);
    end
    while(!$feof(fd)) begin
      c = $fgetc(fd);
      if ( c == ";")
        get_program_len ++;
      $write(c); // debug
    end
    $fclose(fd);
    $display(" [System]: Program length: %0d lines.", get_program_len);
  endfunction

  // program monitor
  task moni();
    logic [31:0] inst;
    logic signed [31:0] imm;
    logic [31:0] pc, newpc;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic [4:0] rd, rs1, rs2;
    logic signed [31:0] rs1data, rs2data, rddata;
    inst = riscv32s.rom.rdata;
    opcode = riscv32s.core.operation;
    funct7 = riscv32s.core.function7;
    funct3 = riscv32s.core.function3;
    pc = riscv32s.core.programaddress;
    newpc = riscv32s.core.newpc;
    rd  = riscv32s.core.rd;
    rs1 = riscv32s.core.rs1;
    rs2 = riscv32s.core.rs2;
    imm = riscv32s.core.immextend.imm;
    rs1data = riscv32s.core.readdata1;
    rs2data = riscv32s.core.readdata2;
    rddata = riscv32s.core.writebackdata;
    if (opcode == 7'b0110011)
      case (funct7)
        7'b0000000:
          case (funct3)
            3'b000: $display(" [Core] x%0d + x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d + %0d = %0d\n", rs1data, rs2data, rddata);
            3'b111: $display(" [Core] x%0d & x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d & %0d = %0d\n", rs1data, rs2data, rddata);
            3'b110: $display(" [Core] x%0d | x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d | %0d = %0d\n", rs1data, rs2data, rddata);
            3'b001: $display(" [Core] x%0d << x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d << %0d = %0d\n", rs1data, rs2data, rddata);
            default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
          endcase
        7'b0100000: 
          if (funct3 == 3'b101) $display(" [Core] x%0d >> x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d >> %0d = %0d\n", rs1data, rs2data, rddata);
          else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
        7'b0000001: 
          if (funct3 == 3'b000) $display(" [Core] x%0d *l x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d * %0d = %0d\n", rs1data, rs2data, rddata);
          else if (funct3 == 3'b001) $display(" [Core] r%0d *h r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> (%0d * %0d)>>>31 = %0d\n", rs1data, rs2data, rddata);
          else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
        default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
      endcase
    else if (opcode == 7'b0010011)
      if (funct3 == 3'b000) 
        $display(" [Core] x%0d + %0d -> x%0d. pc=%0d", rs1, imm, rd, pc>>2, " ----------> %0d + %0d = %0d\n", rs1data, imm, rddata);
      else if (funct3 == 3'b110) 
        $display(" [Core] x%0d ^ %0d -> x%0d. pc=%0d", rs1, imm, rd, pc>>2, " ----------> %0d ^ %0d = %0d\n", rs1data, imm, rddata);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
    else if (opcode == 7'b0000011)
      if (funct3 == 3'b010) 
        $display(" [Core] mem[x%0d + %0d] -> x%0d. pc=%0d", rs1, imm, rd, pc>>2, " ----------> %0d = mem[%0d]\n", rddata, rs1data + imm);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
    else if (opcode == 7'b0100011)
      if (funct3 == 3'b010) 
        $display(" [Core] x%0d -> mem[x%0d + %0d]. pc=%0d", rs2, rs1, imm, pc>>2, " ---------->  mem[%0d] = %0d\n", rs1data + imm, rs2data);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
    else if (opcode == 7'b1100011)
      case (funct3)
        3'b000: $display(" [Core] x%0d == x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d == %0d ?\n", rs1data, rs2data);
        3'b001: $display(" [Core] x%0d != x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d != %0d ?\n", rs1data, rs2data);
        3'b100: $display(" [Core] x%0d < x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d < %0d ?\n", rs1data, rs2data);
        3'b101: $display(" [Core] x%0d >= x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d >= %0d ?\n", rs1data, rs2data);
        default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
      endcase
    else if (inst != 'x) $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
  endtask

  logic [31:0] pc, maxpc;
  assign pc = riscv32s.core.programaddress;

  initial begin
    nrst<=1; clk<=0;
    #1 nrst<=0; #1 nrst<=1;
    maxpc = get_program_len("../fpga/test.v");
    fork
      forever @(posedge clk) moni();
      forever @(posedge clk)
        if (pc>>2 >= maxpc) begin // core stopped
          memlog("../fpga/mem.log", 1);
          for (int i = 0; i < 32; i ++)
            $display("x%0d = %0d", i, riscv32s.core.regfile.x[i]);
          $finish(2);
        end
    join
  end

endmodule