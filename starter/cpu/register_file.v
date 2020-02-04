module register_file #(parameter
  REG_SIZE = 32,
  ADDR_SIZE = 4
  )
  (
  input wire clk,
  input wire nreset,
  input wire [ADDR_SIZE-1:0] select1,
  input wire [ADDR_SIZE-1:0] select2,
  input wire read_not_write,
  input wire [REG_SIZE-1:0] data_in,
  output wire [REG_SIZE-1:0] d1_out,
  output wire [REG_SIZE-1:0] d2_out
  );

  reg [REG_SIZE-1:0] registers [(2 ** ADDR_SIZE)-1:0];

  always @(posedge clk) begin
    if (nreset) begin
      d1_out <= 0;
      d2_out <= 0;
    end else begin
      if (~read_not_write)
        registers[select1] <= data_in;
      d1_out <= registers [select1];
      d2_out <= registers [select2];
    end
  end
endmodule
