module register_file #(parameter
  REG_SIZE = 32,
  ADDR_SIZE = 4
  )
  (
  input wire clk,
  input wire nreset,
  input wire [1:0] phase,
  input wire [ADDR_SIZE-1:0] select1,
  input wire [ADDR_SIZE-1:0] select2,
  input wire [ADDR_SIZE-1:0] wselect,
  input wire [ADDR_SIZE-1:0] shft_reg,
  input wire signed [REG_SIZE-1:0] offset,
  input wire we,
  input wire from_mem,
  input wire [REG_SIZE-1:0] data_in,
  input wire [REG_SIZE-1:0] mem_in,
  output wire [REG_SIZE-1:0] d1_out,
  output wire [REG_SIZE-1:0] d2_out,
  output wire [3:0] shft_byte,
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
      case (phase)
        2'b01: begin // reg read
                 d1_out <= registers [select1];
                 d2_out <= registers [select2];
               end
        2'b11: begin // write back
                 if (we)
                   if (from_mem)
                     registers[wselect] <= mem_in;
                   else
                     registers[wselect] <= data_in;
                 if (offset[31]) begin // offset negative
                   registers[15] <= registers[15] + 4 - ~offset + 1; //program counter
                 end else begin
                   registers[15] <= registers[15] + 4 + offset;
                 end
               end
        default: ;
      endcase
      shft_byte <= registers[shft_reg][3:0];
    end
  end
endmodule
