module flags #(parameter
  COND_LEN = 4,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire [COND_LEN-1:0] cond_code,
  input wire comp,
  input wire carry,
  input wire overflow,
  input wire [REG_SIZE-1:0] data,
  output wire cond_met
  );

  reg N;
  reg Ze;
  reg V;
  reg C;

  reg ff;

  initial begin
    N = 1'b0;
    Ze = 1'b0;
    V = 1'b0;
    C = 1'b0;
  end

  always @(*) begin
    case (cond_code)
      4'b0000: ff = Ze;
      4'b0001: ff = ~Ze;
      4'b0010: ff = C;
      4'b0011: ff = ~C;
      4'b0100: ff = N;
      4'b0101: ff = ~N;
      4'b0110: ff = V;
      4'b0111: ff = ~V;
      4'b1000: ff = C & ~Ze;
      4'b1001: ff = ~C | Ze;
      4'b1010: ff = N ^ V;
      4'b1011: ff = N ^~ V;
      4'b1100: ff = ~Ze & (N ^ V);
      4'b1101: ff = Ze | (N ^~ V);
      default: ff = 1;
    endcase
  end

  always @(posedge clk) begin
    if (comp) begin
      N <= data[31];
      Ze <= ~|data;
      V <= overflow;
      C <= carry;
    end
    cond_met <= ff;
  end

endmodule
