//----------------------------------------------------------------
// JPEG encoding system on chip top module stimulus
// Last Modified Date: 2023/8/8
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

`timescale 1ns/10ps

// Use program monitor, this will reduce the simulation speed
// `define ProgramMonitor

module stim_soc;
  
  initial $timeformat(0, 4, "s", 0);

  // wiring and param
  logic clk, nrst;
  logic [2:0] button;
  logic [6:0] seg [0:5];
  logic [9:0] led;
  localparam CLK_PERIOD = 20;

  // SoC
  always #(CLK_PERIOD/2) clk = ~ clk;
  soc soc(.clock(clk), .nreset(nrst), .button, .seg, .led);

  // write mem.log
  task memlog(input string fdir, bit showinfor);
    integer fd, error;
    string errinfor;
    logic signed [31:0] data;
    fd = $fopen(fdir, "w+");
    error = $ferror(fd, errinfor);
    assert (error == 0) else begin
      $display(" [System]: Error: File descriptor: %h.", fd );
      $display(" [System]: Error number:    %0d.", error );
      $display(" [System]: Error info:      %s.", errinfor );
      $stop(1);
    end
    if (showinfor)
      $display(" [System]: Write log start, file opened.");
    $fdisplay(fd, "[RAM Data Log]: created by system verilog testbench.");
    for (int w = 0; w <= 100000; w ++) begin
      data = soc.panel.ram.memory[w];
      $fdisplay(fd, "[%0d] : %0d", w, $signed(data));
    end
    $fdisplay(fd, "[100001] : %0d", $signed(soc.panel.enter_main));
    $fclose(fd);
    if (showinfor)
      $display(" [System]: Write log finished, file closed.");
  endtask

  // from ROM program file get program length 
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
      // $write(c); // debug
    end
    $fclose(fd);
    $display(" [System]: Program length: %0d lines.", get_program_len);
  endfunction

  `ifdef ProgramMonitor
    // program monitor
    task moni;
      logic [31:0] inst;
      logic signed [31:0] imm, rs1data, rs2data, rddata;
      logic [31:0] pc, newpc;
      logic [6:0] opcode, funct7;
      logic [2:0] funct3;
      logic [4:0] rd, rs1, rs2;
      inst = soc.rom.rdata;
      opcode = soc.core.operation;
      funct7 = soc.core.function7;
      funct3 = soc.core.function3;
      pc = soc.core.programaddress;
      newpc = soc.core.newpc;
      rd  = soc.core.rd;
      rs1 = soc.core.rs1;
      rs2 = soc.core.rs2;
      imm = soc.core.immextend.imm;
      rs1data = soc.core.readdata1;
      rs2data = soc.core.readdata2;
      rddata = soc.core.writebackdata;
      if (opcode == 7'b0110011)
        case (funct7)
          7'b0000000:
            case (funct3)
              3'b000: $display(" [Core] x%0d + x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d + %0d = %0d", rs1data, rs2data, rddata);
              3'b111: $display(" [Core] x%0d & x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d & %0d = %0d", rs1data, rs2data, rddata);
              3'b110: $display(" [Core] x%0d | x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d | %0d = %0d", rs1data, rs2data, rddata);
              3'b001: $display(" [Core] x%0d << x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d << %0d = %0d", rs1data, rs2data, rddata);
              default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
            endcase
          7'b0100000: 
            if (funct3 == 3'b101) $display(" [Core] x%0d >> x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d >> %0d = %0d", rs1data, rs2data, rddata);
            else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
          7'b0000001: 
            if (funct3 == 3'b000) $display(" [Core] x%0d *l x%0d -> x%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> %0d * %0d = %0d", rs1data, rs2data, rddata);
            else if (funct3 == 3'b001) $display(" [Core] r%0d *h r%0d -> r%0d. pc=%0d", rs1, rs2, rd, pc>>2, " ----------> (%0d * %0d)>>>31 = %0d", rs1data, rs2data, rddata);
            else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
          default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
        endcase
      else if (opcode == 7'b0010011)
        if (funct3 == 3'b000) 
          $display(" [Core] x%0d + %0d -> x%0d. pc=%0d", rs1, imm, rd, pc>>2, " ----------> %0d + %0d = %0d", rs1data, imm, rddata);
        else if (funct3 == 3'b110) 
          $display(" [Core] x%0d ^ %0d -> x%0d. pc=%0d", rs1, imm, rd, pc>>2, " ----------> %0d ^ %0d = %0d", rs1data, imm, rddata);
        else
          $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
      else if (opcode == 7'b0000011)
        if (funct3 == 3'b010) 
          $display(" [Core] mem[x%0d + %0d] -> x%0d. pc=%0d", rs1, imm, rd, pc>>2, " ----------> %0d = mem[%0d]", rddata, rs1data + imm);
        else
          $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
      else if (opcode == 7'b0100011)
        if (funct3 == 3'b010) 
          $display(" [Core] x%0d -> mem[x%0d + %0d]. pc=%0d", rs2, rs1, imm, pc>>2, " ---------->  mem[%0d] = %0d", rs1data + imm, rs2data);
        else
          $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
      else if (opcode == 7'b1100011)
        case (funct3)
          3'b000: $display(" [Core] x%0d == x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d == %0d ?", rs1data, rs2data);
          3'b001: $display(" [Core] x%0d != x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d != %0d ?", rs1data, rs2data);
          3'b100: $display(" [Core] x%0d < x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d < %0d ?", rs1data, rs2data);
          3'b101: $display(" [Core] x%0d >= x%0d ? pc(%0d) + %0d = %0d. pc=%0d", rs1, rs2, pc>>2, imm>>>2, newpc>>2, pc>>2, " ----------> %0d >= %0d ?", rs1data, rs2data);
          default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
        endcase
      else if (inst != 'x) $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%0d", opcode, funct7, funct3, pc>>2);
    endtask
  `endif

  // Prgram counter wave
  logic [31:0] program_line;
  assign program_line = soc.programaddress >> 2;

  //----------------------------------------------------------------
  // test process
  //----------------------------------------------------------------

  // Monitors
  initial fork
    // Program monitor
    `ifdef ProgramMonitor
      forever @(posedge soc.clk_core) moni;
    `endif
    // sim time
    forever #0.05s $display(" [System] Time: %t, PC: %0d", $time, program_line);
  join

  integer block_index = 0, program_end;

  // test start
  initial begin
    // system test init and stop
    nrst=1; clk=0; 
    button[0]=1;
    button[1]=1;
    button[2]=1;
    #1 nrst=0; #1 nrst=1; #1;
    program_end = get_program_len("../fpga/system.v");

    @(program_line == 1873) // system.dust---line:1901
    $display("\n [Stim infor] Initiation Finished. \n");
    $stop(1);

    $display("\n [Stim infor] Press button[0]. \n");
    button[0] = 0;
    # 0.3s;
    $display("\n [Stim infor] Release button[0]. \n");
    button[0] = 1;

    fork
      forever @(posedge (program_line == 2371)) begin  // system.dust---line:2566
        block_index ++;
        $display("\n [Stim infor] %0d block encode finished. \n", block_index);
      end
    join_none

    @(program_line == (program_end-1))
    $display("\n [Stim report] Program end, total %0d blocks encoded. \n", block_index);
    memlog("../fpga/hdl_sim.log", 1);
    # 0.1s
    $finish(2);
  end

endmodule