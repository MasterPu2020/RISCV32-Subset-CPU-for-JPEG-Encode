//----------------------------------------------------------------
// JPEG encoding system on chip top module testbench
// Verification Methodolog: Universal Verification Methodolog (UVM)
// Last Modified Date: 2023/7/18
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

`timescale 1ns/10ps

// Use program monitor, this will reduce the simulation speed
`define ProgramMonitor
// Use UART input monitor
// `define UARTinputMonitor

class simPC;
  static bit datao; // uart data output
  static real BPS_PERIOD = 1000;
  function new(real bps_period);
    datao = 1;
    BPS_PERIOD = bps_period;
  endfunction
  // uart send data
  task automatic send(input bit[31:0] word, bit showinfor);
    byte databuffer;
    if (showinfor)
      $display(" [PC]: UART send: %h. %t", word, $time);
    repeat(4) begin
      databuffer = word[31:24];
      // $display(" Byte: %h", databuffer);
      word = word << 8;
      #BPS_PERIOD datao = 0;
      repeat(8) begin
        #BPS_PERIOD datao = databuffer[0];
        databuffer = databuffer >> 1;
      end
      #BPS_PERIOD datao = 1;
    end
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
      $display(" [System]: Error number:    %0d.", error );
      $display(" [System]: Error info:      %s.", errinfor );
      $stop(1);
    end
    if (showinfor)
      $display(" [System]: File opened.");
    error = $fseek(fd, 0, 2);
    flen = $ftell(fd);
    error = $fseek(fd, 0, 0);
    assert (error == 0) else begin
      $display(" [System]: Error with system $fseek(), code: %0d.", error);
      $stop(1);
    end
    flen = flen / 4;
    if (showinfor)
      $display(" [System]: File length: %0d words.", flen);
    usetime = $time;
    for (int w = 0; w < flen; w ++) begin
      repeat(4) begin
        // $display(" [debug]: byte id: %0d", $ftell(fd));
        word = word << 8;
        word[7:0] = $fgetc(fd);
      end
      send(word, showinfor);
      if (w % 100 == 0 && w != 0) begin
        $display("\n [PC]: UART Sending File Stop Gap, %0d words. %t\n", w, $time);
        #(BPS_PERIOD*100); // seperate by 100 words, to avoid clock mismatch
      end
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
  
  initial $timeformat(0, 4, "s", 0);

  // wiring and param
  logic clk, nrst, key, datai, datao;
  localparam CLK_PERIOD = 20, BPS_PERIOD = 104160; // Baud rate: 9600bps -> 104160

  // simulated PC
  simPC PC = new(BPS_PERIOD);
  assign datai = PC.datao;

  // SoC
  soc soc(.clk, .nrst, .key, .datai, .datao);

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
    $fdisplay(fd, "\n[RAM DATA LOG]: created by system verilog testbench.\n");
    for (int w = 0; w < 206800; w ++) begin
      data = soc.ram.memory[w];
      $fdisplay(fd, "[%0d] : %0d", w, $signed(data));
    end
    for (int w = 0; w < 204900; w ++) begin
      data = soc.dualram.memory[w];
      $fdisplay(fd, "[%0d] : %0d", w+206800, $signed(data));
    end
    $fdisplay(fd, "[buttom] : %0d", $signed(soc.button.data));
    $fclose(fd);
    if (showinfor)
      $display(" [System]: Write log finished, file closed.");
  endtask

  // from ROM program file get program length 
  function get_program_len(input string fdir, input bit showinfor, output integer flen);
    integer fd, error, memlen;
    string errinfor, c;
    flen = 0;
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
        flen ++;
      if (showinfor)
        $write(c);
    end
    $fclose(fd);
    $display(" [System]: Program length: %0d lines.", flen);
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
      opcode = soc.riscvcore.operation;
      funct7 = soc.riscvcore.function7;
      funct3 = soc.riscvcore.function3;
      pc = soc.riscvcore.programaddress;
      newpc = soc.riscvcore.newpc;
      rd  = soc.riscvcore.rd;
      rs1 = soc.riscvcore.rs1;
      rs2 = soc.riscvcore.rs2;
      imm = soc.riscvcore.immextend.imm;
      rs1data = soc.riscvcore.readdata1;
      rs2data = soc.riscvcore.readdata2;
      rddata = soc.riscvcore.writebackdata;
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
  initial begin
    fork
      // Program monitor
      `ifdef ProgramMonitor
        forever begin
          @(posedge soc.clkcore)
          if (!(program_line <= 9) && !(809 <= program_line && program_line <= 829))
            moni;
        end
      `endif
      // uart data monitor
      `ifdef UARTinputMonitor
        forever
          @(posedge soc.uart.wram) 
          $display(" [Uart] Write RAM[%0d] = %h, time: %t", soc.uart.wramaddr, soc.uart.wramdata, $time);
        forever begin
          @(posedge soc.uart.wram) @(posedge soc.clkbps)
          $display(" [Dual-RAM] mem[%0d] = %h, time: %t", (soc.uart.wramaddr-206800-1), soc.dualram.memory[soc.uart.wramaddr-206800-1], $time);
        end
      `endif
      // uart exception monitor
      forever
        @(soc.uart.state)
        if (soc.uart.ramaddress == 411698) begin
          $display(" [Uart] EXCEPTION: Unexpected data package, time: %t", $time);
          $stop(1);
        end
      // sim time
      forever #1s $display(" [System] Time: %t", $time);
    join
  end
  
  // system test init and stop
  always #(CLK_PERIOD/2) clk=~clk;
  initial begin
    nrst=1; clk=0; key=1;
    #1 nrst=0; #1 nrst=1;
  end

  string 
    logdir = "./mem.log",
    imgdir = "../algorithm/test.row";

  // test start
  initial begin

    // program reset data memory file and soc init
    $display("\n [Test Process]: Program reset data memory file and soc init.\n");
    #(0.2s);
    memlog(logdir, 1);
    // image row uart send
    PC.sendfile(imgdir, 1);
    memlog(logdir, 1);
    $display("\n [Test Process]: Ready for image process.\n");
    for (int i = 0; i < 1026; i++) begin
      $display(" [Dual-RAM] Address[%0d] : Data[%h]", i, soc.dualram.memory[i]);
    end
    // CPU image process
    fork 
      // start listening to the data
      PC.receive(datao);
      // press key to execute encoding
      $display("\n [Test Process]: Button key press.\n");
      key = 0; 
      #(0.3s) key = 1;
    join_none
    // check the program is entering main function
    #(0.4s); // button press vaild
    if ((soc.programaddress >> 2) > 829)
      $display("\n [Core]: In main function.\n");
    else begin
      $display("\n [Core]: Warning: NOT in main function.\n");
      memlog(logdir, 1);
      $stop(1);
    end
    // wait for image encode
    @(negedge datao)
    memlog(logdir, 1);
    $display("\n [Test Process]: Image data sending to PC.\n");
    $stop(2);

    // End of the simulation
    @(soc.dualram.memory[204899]) // uart write sending data finished
    $display("\n [Test Process]: Simulation Finished.\n");
    $stop(2);

  end

endmodule