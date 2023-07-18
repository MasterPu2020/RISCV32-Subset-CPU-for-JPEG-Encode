//----------------------------------------------------------------
// JPEG encoding system on chip top module testbench
// Verification Methodolog: Universal Verification Methodolog (UVM)
// Last Modified Date: 2023/7/18
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

class simPC;
  static bit datao; // uart data output
  static int BPS_PERIOD = 1000;
  function new(int bps_period);
    datao = 1;
    BPS_PERIOD = bps_period;
  endfunction
  // uart send data
  task automatic send(input bit[31:0] word, bit showinfor);
    byte databuffer;
    if (showinfor)
      $write(" [PC]: UART send: %h", word);
    repeat(4) begin
      databuffer = word[31:24];
      word = word << 8;
      #BPS_PERIOD datao = 0;
      repeat(8) begin
        #BPS_PERIOD datao = databuffer[0];
        databuffer = databuffer >> 1;
      end
      #BPS_PERIOD datao = 1;
    end
    if (showinfor)
      $display("  [Finished] %t", $time);
  endtask
  // recieve uart, always on
  task automatic receive(input bit datai);
    byte databuffer;
    bit[31:0] word;
    int counter = 0;
    forever begin
      #BPS_PERIOD;
      if (datai == 0) begin
        #BPS_PERIOD;
        repeat(8) begin
          databuffer[7] = datai;
          databuffer = databuffer >> 1;
          #BPS_PERIOD;
        end
        assert (datai == 1) else begin
          $display(" [PC]: WARNING: Uart package stop bit error.");
          $stop(1);
        end
        #BPS_PERIOD;
        word[7:0] = databuffer;
        word = word << 8;
        counter ++;
      end
      if (counter >= 4) begin
        $display(" [PC]: New word recived: %h", word);
        word = 0;
        counter = 0;
        databuffer = 0;
      end
    end
  endtask
  // uart send whole file
  task automatic sendfile(input string fdir, bit showinfor);
    integer fd, error, flen;
    real usetime;
    bit [31:0] word;
    string errinfor;
    fd = $fopen(fdir, "rb");
    error = $ferror(fd, errinfor);
    assert (error == 0) else begin
      $display(" [System]: Error: File descriptor: %h.", fd );
      $display(" [System]: Error number:    %d.", error );
      $display(" [System]: Error info:      %s.", errinfor );
      $stop(1);
    end
    if (showinfor)
      $display(" [System]: File opened.");
    error = $fseek(fd, 0, 2);
    flen = $ftell(fd);
    error = $fseek(fd, 0, 0);
    assert (error == 0) else begin
      $display(" [System]: Error with system $fseek(), code: %d.", error);
      $stop(1);
    end
    flen = flen / 4;
    if (showinfor)
      $display(" [System]: File length: %d words.", flen);
    usetime = $time;
    for (int w = 0; w < flen; w ++) begin
      repeat(4) begin
        // $display(" [debug]: byte id: %d", $ftell(fd));
        word = word << 8;
        word[7:0] = $fgetc(fd);
      end
      send(word, showinfor);
    end
    $fclose(fd);
    usetime = $time - usetime;
    if (showinfor)
      $display(" [System]: File closed.");
      $display(" [PC]: Realtime using: %t", usetime);
    #(BPS_PERIOD);
  endtask
endclass // simulated Personal Computer uart port

module tb_soc;
  
  `timescale 1ns/10ps
  initial $timeformat(0, 4, "s", 0);

  // wiring and param
  logic clk, nrst, key, datai, datao;
  localparam CLK_PERIOD = 20, BPS_PERIOD = 104166; // Baud rate: 9600bps

  // simulated PC
  simPC PC = new(BPS_PERIOD);
  assign datai = PC.datao;

  // SoC
  soc soc(.clk, .nrst, .key, .datai, .datao);

  // write mem.log
  task memlog(input string fdir, bit showinfor);
    integer fd, error, memlen;
    string errinfor;
    memlen = soc.RAMDEPTH; // from hierachy get data
    fd = $fopen(fdir, "w+");
    error = $ferror(fd, errinfor);
    assert (error == 0) else begin
      $display(" [System]: Error: File descriptor: %h.", fd );
      $display(" [System]: Error number:    %d.", error );
      $display(" [System]: Error info:      %s.", errinfor );
      $stop(1);
    end
    if (showinfor)
      $display(" [System]: Write log start, file opened. %d words", memlen);
    $fdisplay(fd, "\n[RAM DATA LOG]: created by system verilog testbench.\n");
    for (int w = 0; w <= memlen; w ++)
      $fdisplay(fd, "[%d] : %d", w, $signed(soc.ram.memory[w]));
    $fdisplay(fd, "[buttom] : %d", $signed(soc.buttom.data));
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
    inst = soc.rom.rdata;
    opcode = soc.riscvcore.operation;
    funct7 = soc.riscvcore.function7;
    funct3 = soc.riscvcore.function3;
    pc = soc.riscvcore.programaddress;
    newpc = soc.riscvcore.newpc;
    rd  = soc.riscvcore.rd;
    rs1 = soc.riscvcore.rs1;
    rs2 = soc.riscvcore.rs2;
    imm = soc.riscvcore.immextend.imm;
    if (opcode == 7'b0110011)
      case (funct7)
        7'b0000000:
          case (funct3)
            3'b000: $display(" [Core] r%d + r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
            3'b111: $display(" [Core] r%d & r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
            3'b110: $display(" [Core] r%d | r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
            3'b001: $display(" [Core] r%d << r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
            3'b101: $display(" [Core] r%d >> r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
            default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
          endcase
        7'b0100000: 
          if (funct3 == 3'b000) $display(" [Core] r%d *l r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
          else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
        7'b0000001: 
          if (funct3 == 3'b001) $display(" [Core] r%d *h r%d -> r%d. pc=%d", rs1, rs2, rd, pc>>4);
          else $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
        default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
      endcase
    else if (opcode == 7'b0010011)
      if (funct3 == 3'b000) 
        $display(" [Core] mem[ r%d + %d ]-> r%d. pc=%d", rs1, imm, rd, pc>>4);
      else if (funct3 == 3'b000) 
        $display(" [Core] mem[ r%d ^ %d ]-> r%d. pc=%d", rs1, imm, rd, pc>>4);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
    else if (opcode == 7'b0000011)
      if (funct3 == 3'b010) 
        $display(" [Core] mem[ r%d + %d ]-> r%d. pc=%d", rs1, imm, rd, pc>>4);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
    else if (opcode == 7'b0100011)
      if (funct3 == 3'b010) 
        $display(" [Core] r%d -> mem[ r%d + %d ]. pc=%d", rs2, rs1, imm, pc>>4);
      else
        $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
    else if (opcode == 7'b1100011)
      case (funct3)
        3'b000: $display(" [Core] r%d == r%d ? pc(%d) + %d = %d. pc=%d", rs1, rs2, pc>>4, imm, newpc>>4, pc>>4);
        3'b001: $display(" [Core] r%d != r%d ? pc(%d) + %d = %d. pc=%d", rs1, rs2, pc>>4, imm, newpc>>4, pc>>4);
        3'b100: $display(" [Core] r%d <  r%d ? pc(%d) + %d = %d. pc=%d", rs1, rs2, pc>>4, imm, newpc>>4, pc>>4);
        3'b101: $display(" [Core] r%d >= r%d ? pc(%d) + %d = %d. pc=%d", rs1, rs2, pc>>4, imm, newpc>>4, pc>>4);
        default: $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
      endcase
    else if (inst != 'x) $display(" [Core] Inst unknow: op %b funct7 %b funct3 %b. pc=%d", opcode, funct7, funct3, pc>>4);
  endtask

  //----------------------------------------------------------------
  // test process
  //----------------------------------------------------------------

  // system test init
  always #(CLK_PERIOD/2) clk=~clk;
  initial begin
    nrst=1; clk=0; key=1;
    #1 nrst=0; #1 nrst=1;
  end

  string 
    logdir = "D:/iCloud/iCloudDrive/Southampton/Research Project/Code/riscv/soc/mem.log",
    imgdir = "D:/iCloud/iCloudDrive/Southampton/Research Project/Code/riscv/algorithm/test.row";

  // test start
  initial begin
    
    repeat(100) begin
      @(posedge soc.clkcore) moni();
    end
    $stop(1);

    // program reset data memory file
    #(0.68s);
    memlog(logdir, 1);
    // image row uart send
    PC.sendfile(imgdir, 1);
    memlog(logdir, 1);
    $display("\n [Test Process]: Ready for image process.\n");
    $stop(1);
    // wait for soc finish init
    #(1s);
    // start receive data
    fork PC.receive(datai); join_none
    // press key to execute encoding
    key = 0; #(0.3s) key = 1;
    $display("\n [Test Process]: Buttom key press.\n");
    // check the program is entering main function
    #(0.1s);
    if (soc.riscvcore.programaddress > 3280)
      $display("\n [Core]: In main function.\n");
    else begin
      $display("\n [Core]: Warning: NOT in main function.\n");
      memlog(logdir, 1);
      $stop(1);
    end
    // wait for image encode
    @(negedge datao)
    $display("\n [Test Process]: Image data sending to PC.\n");
    $stop(1);

  end

endmodule