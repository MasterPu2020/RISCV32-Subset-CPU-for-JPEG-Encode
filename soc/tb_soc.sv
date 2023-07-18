//----------------------------------------------------------------
// JPEG encoding system on chip top module testbench
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
  task automatic send(input bit[31:0] word, input bit showinfor);
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
  task automatic sendfile(string fdir, bit showinfor);
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

  // system test init
  always #(CLK_PERIOD/2) clk=~clk;
  initial begin
    nrst=1; clk=0; key=1;
    #1 nrst=0; #1 nrst=1;
  end

  // test start
  initial begin
    #BPS_PERIOD;
    // image row uart send
    PC.sendfile("D:/iCloud/iCloudDrive/Southampton/Research Project/Code/riscv/algorithm/test.row", 1);
    // wait for soc finish init
    #(1s);
    // start receive data
    fork PC.receive(datai); join_none
    // press key to execute encoding
    key = 0; #(0.3s) key = 1;
    // wait for image encode

  end

endmodule