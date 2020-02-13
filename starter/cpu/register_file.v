module register_file #(parameter
  REG_SIZE = 32,
  ADDR_SIZE = 4
  )
  (
  input wire clk,
  input wire nreset,
  input wire [ADDR_SIZE-1:0] select1,
  input wire [ADDR_SIZE-1:0] select2,
  input wire [ADDR_SIZE-1:0] wselect,
  input wire [23:0] offset,
  input wire read_not_write,
  input wire [REG_SIZE-1:0] data_in,
  output wire [REG_SIZE-1:0] d1_out,
  output wire [REG_SIZE-1:0] d2_out,
  output wire [REG_SIZE-1:0] pc
  );

  reg [REG_SIZE-1:0] registers [(2 ** ADDR_SIZE)-1:0];

  always @(*) begin
    pc = registers[15];
  end

  always @(posedge clk) begin
    if (~nreset) begin
      d1_out <= 0;
      d2_out <= 0;
      registers[15] <= 0;
    end else begin
      if (~read_not_write)
        registers[wselect] <= data_in;
      d1_out <= registers [select1];
      d2_out <= registers [select2];

      registers[15] <= registers[15] + 4 + offset; //program counter
    end
  end
endmodule
