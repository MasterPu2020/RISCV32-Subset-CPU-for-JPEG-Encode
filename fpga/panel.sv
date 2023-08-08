//----------------------------------------------------------------
// FPGA signal debugging panel intergrating the bus function
// Last Modified Date: 2023/8/7
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module panel 
#(parameter
  WIDTH = 32, 
  DEPTH = 100_000, 
  CLKRATE = 25000000, 
  DBMSEC = 150
)(
  input  wire clk, nrst, enw,
  input  wire [2:0] button,
  input  wire [WIDTH-1:0] address,
  input  wire [WIDTH-1:0] wdata,
  output logic [WIDTH-1:0] rdata,
  output logic [6:0] seg [0:5]
);

  // button debounce
  localparam DBMAX = (1000_000 * DBMSEC) / (1000_000_000 / CLKRATE) / 2;
  logic [$clog2(DBMAX):0] dbcnt [0:2];
  // button[0] : enter main function & debounce
  logic enter_main;  
  // button[1,2] : panel control
  logic switch;
  logic half_word;
  always_ff @(posedge clk, negedge nrst) 
    if (~nrst) begin
      enter_main <= 0;
      switch <= 0;
      half_word <= 0;
      dbcnt[0] <= 0;
      dbcnt[1] <= 0;
      dbcnt[2] <= 0;
    end
    else begin
      // button[0] : enter main function & debounce
      if (~button[0]) begin // button press
        if (dbcnt[0] <= DBMAX)
          dbcnt[0] <= dbcnt[0] + 1;
      end
      else if (dbcnt[0] >= DBMAX) begin // execute once
        enter_main <= 1; // button interface: 100,001
        dbcnt[0] <= 0;
      end
      else
        dbcnt[0] <= 0;
      // button[1] debounce and function
      if (~button[1]) begin // button press
        if (dbcnt[1] <= DBMAX)
          dbcnt[1] <= dbcnt[1] + 1;
      end
      else if (dbcnt[1] >= DBMAX) begin // execute once
        switch <= ~ switch;
        dbcnt[1] <= 0;
      end
      else begin
        dbcnt[1] <= 0;
      end
      // button[2] debounce and function
      if (~button[2]) begin // button press
        if (dbcnt[2] <= DBMAX)
          dbcnt[2] <= dbcnt[2] + 1;
      end
      else if (dbcnt[2] >= DBMAX) begin // execute once
        half_word <= ~ half_word;
        dbcnt[2] <= 0;
      end
      else begin
        dbcnt[2] <= 0;
      end
    end

  // bus
  wire bus_enw;
  wire [WIDTH-1:0] bus_address;
  wire [WIDTH-1:0] bus_wdata;
  wire [WIDTH-1:0] bus_rdata;

  ram #(WIDTH, DEPTH) ram(.clk, .enw(bus_enw), .address(bus_address), .wdata(bus_wdata), .rdata(bus_rdata));

  // panel bus switch
  logic [WIDTH-1:0] panel_address;
  assign bus_enw     = switch ?             0 : enw;
  assign bus_address = switch ? panel_address : address;
  assign bus_wdata   = switch ?             0 : wdata;
  assign rdata       = switch ?             0 : ((bus_address == 100_001) ? enter_main : bus_rdata);
  
  // seven segment display
  function [6:0] segment;
    input [3:0] number;
    case (number)
       0: segment = 8'hc0;
       1: segment = 8'hf9;
       2: segment = 8'ha4;
       3: segment = 8'hb0;
       4: segment = 8'h99;
       5: segment = 8'h92;
       6: segment = 8'h82;
       7: segment = 8'hf8;
       8: segment = 8'h80;
       9: segment = 8'h90;
      10: segment = 8'h84; // A
      11: segment = 8'h83; // b
      12: segment = 8'hc6; // C
      13: segment = 8'ha1; // d
      14: segment = 8'h86; // E
      15: segment = 8'h8e; // F
    endcase
  endfunction

  logic [15:0] panel_data;

  assign seg[0] = segment(panel_data[ 3: 0]);
  assign seg[1] = segment(panel_data[ 7: 4]);
  assign seg[2] = segment(panel_data[11: 8]);
  assign seg[3] = segment(panel_data[15:12]);
  assign seg[4] = segment(panel_address[3:0]);
  assign seg[5] = segment(panel_address[7:4]);

  // panel read data
  always_comb begin
    panel_data = 0;
    if (half_word && switch)
      panel_data = bus_rdata[31:16];
    else if (switch)
      panel_data = bus_rdata[15:0];
  end

  // panel read address control
  logic last_half_word;
  always_ff @(posedge clk, negedge nrst) 
    if (~nrst) begin
      panel_address <= 0;
      last_half_word <= 0;
    end
    else begin
      last_half_word <= half_word;
      if (last_half_word == 1 && half_word == 0) // falling edge of half_word : word address increase
        panel_address <= panel_address + 1;
    end

endmodule