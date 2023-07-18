//----------------------------------------------------------------
// SoC UART interface behavioural
// Support: Single way data interchange.
// Infor: Data must be the times of 32-bit.Yet no parity check
// Last Modified Date: 2023/7/17
// Version: 1.0
// Author: Clark Pu
//----------------------------------------------------------------

module uart (
  input wire clk, nrst, datai,
  input wire [31:0] rramdata,
  output logic datao, wram,
  output logic [31:0] ramaddress,
  output reg [31:0] wramdata
);

  // customized state machine
  enum logic [5:0] {IDLE, RECEIVE, POSTRECEIVE, SEND, POSTSEND, EXCEPTION} state;
  // bit counter
  reg [7:0] bitcnt;
  // byte counter
  reg [2:0] bytecnt;
  // read ram byte data for sending
  reg [8:0] bytedata;
  // read ram address
  reg [31:0] rramaddr;
  // write ram address
  reg [31:0] wramaddr;

  // end of package data
  `ifdef ParityCheck
    localparam EOP = 9, CHECKBIT = EOP - 1;
  `else
    localparam EOP = 8;
  `endif

  always_comb begin
    ramaddress = 411699; // busy reading, CPU write
    wram = 0;
    datao = 1;
    case (state)
      RECEIVE: ramaddress = wramaddr;
      POSTRECEIVE: begin
        ramaddress = wramaddr;
        if (bytecnt == 0)
          wram = 1;
      end
      SEND: begin
        ramaddress = rramaddr;
        datao = bytedata[0];
      end
      POSTSEND: begin
        ramaddress = rramaddr; // power saving
        if (rramdata == 0 || rramdata == 'x)
          wram = 1;
      end
      EXCEPTION: begin 
        ramaddress = 411698; // write interruption code
        wram = 1;
      end
    endcase
  end

  always_ff @(posedge clk, negedge nrst) begin : statemachine
    if (~nrst) begin
      state <= IDLE;
      bitcnt <= 0;
      bytecnt <= 0;
      wramdata <= 0;
      wramaddr <= 206800;
      rramaddr <= 0;
      bytedata <= 0;
    end
    else 
      case (state)
        IDLE: begin
          if (rramdata == 1) begin // program write
            state <= POSTSEND;
            wramdata <= 0; // clear data in &411699
            rramaddr <= 206800; // send restart at image row start address
          end
          else if (datai == 0)
            state <= RECEIVE;
        end
        RECEIVE: begin
          if (bitcnt == EOP) begin
            if (datai == 0) // next state
              state <= EXCEPTION;
            else
              state <= POSTRECEIVE;
            if (bytecnt == 3) begin // next byte count
              bytecnt <= 0;
            end
            else
              bytecnt <= bytecnt + 1;
            case (bytecnt)
              0: wramdata[31:24] <= bytedata[8:1];
              1: wramdata[23:16] <= bytedata[8:1];
              2: wramdata[15: 8] <= bytedata[8:1];
              3: wramdata[ 7: 0] <= bytedata[8:1];
            endcase
          end
          else begin
            bitcnt <= bitcnt + 1;
            bytedata <= {datai, bytedata[7:1]};
          end
        end
        POSTRECEIVE: begin
          bitcnt <= 0;
          if (bytecnt == 0)
            wramaddr <= wramaddr + 1;
          if (datai) // next state
            if (bytecnt == 0)
              state <= IDLE;
            else
              state <= EXCEPTION;
          else
            state <= RECEIVE;
        end
        SEND: begin
          if (bitcnt == EOP)
            state <= POSTSEND;
          else begin
            bitcnt <= bitcnt + 1;
            bytedata <= bytedata >> 1;
          end
        end
        POSTSEND: begin
          bitcnt <= 0;
          if (rramdata == 0 || rramdata == 'x) begin // next state, 'x not synthesisable
            state <= IDLE;
            wramaddr <= 206800; // receive restart
          end
          else begin
            state <= SEND;
            case (bytecnt)
              0: bytedata <= {rramdata[31:24], 1'b0};
              1: bytedata <= {rramdata[23:16], 1'b0};
              2: bytedata <= {rramdata[15: 8], 1'b0};
              3: bytedata <= {rramdata[ 7: 0], 1'b0};
            endcase
          end
          if (bytecnt == 3) begin // next byte count
            rramaddr <= rramaddr + 1;
            bytecnt <= 0;
          end
          else
            bytecnt <= bytecnt + 1;
        end
        EXCEPTION: begin
          state <= IDLE;
          bitcnt <= 0;
          bytecnt <= 0;
          wramdata <= 1; // write exception error code
          wramaddr <= 206800;
          rramaddr <= 0;
          bytedata <= 0;
        end
      endcase
  end

endmodule