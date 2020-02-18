module flags #(parameter
  COND_LEN = 4,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire [COND_LEN-1:0] cond_code,
  input wire comp,
  input wire carry,
  input wire [REG_SIZE-1:0] d0,
  input wire [REG_SIZE-1:0] d1,
  output wire cond_met
  );

  reg [(2 ** COND_LEN)-1:0] flags;
  reg EQ; // 0000
  reg NE; // 0001
  reg CS; // 0010
  reg CC; // 0011
  reg MI; // 0100
  reg PL; // 0101
  reg VS; // 0110
  reg VC; // 0111
  reg HI; // 1000
  reg LS; // 1001
  reg GE; // 1010
  reg LT; // 1011
  reg GT; // 1100
  reg LE; // 1101

  initial begin
    flags <= 16'hC000; // 1100 0000 0000 0000
  end

  always @(*) begin
    if (comp) begin
      EQ = d0 == d1; // equal
      NE = d0 != d1; // not equal
      //CS;
      //CC;
      //MI;
      //PL;
      VS = carry & 1'b1; // overflow
      VC = carry ~& 1'b1; // no overflow
      //HI;
      //LS;
      //GE;
      //LT;
      //GT;
      //LE;
    end
  end

  always @(posedge clk) begin
    flags[0000] <= EQ;
    flags[0001] <= NE;
    flags[0010] <= 1'b0;
    flags[0011] <= 1'b0;
    flags[0100] <= 1'b0;
    flags[0101] <= 1'b0;
    flags[0110] <= VS;
    flags[0111] <= VC;
    flags[1000] <= 1'b0;
    flags[1001] <= 1'b0;
    flags[1010] <= 1'b0;
    flags[1011] <= 1'b0;
    flags[1100] <= 1'b0;
    flags[1101] <= 1'b0;
    cond_met <= flags[cond_code];
  end

endmodule
