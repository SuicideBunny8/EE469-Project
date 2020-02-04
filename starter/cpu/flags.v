module flags #(parameter
  COND_LEN = 4,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire [COND_LEN-1:0] cond_code,
  input wire [COND_LEN-1:0] opcode,
  input wire comp,
  input wire [REG_SIZE-1:0] r0,
  input wire [REG_SIZE-1:0] r1,
  output wire cond_met
  );

  reg [(2 ** COND_LEN)-1:0] flags;
  initial begin
    flags[4'b1110] <= 1'b1;
  end

  always @(posedge clk) begin
    if (comp) begin
      
    end
      cond_met <= flags[cond_code];
  end

endmodule
