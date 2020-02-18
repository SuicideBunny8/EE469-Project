module compute_offset #(parameter
  PC_LEN = 32
  )
  (
  input wire clk,
  input wire instr,
  output wire signed offset
  );

  wire signed offs;
  always @(*) begin
    case (instr[27:25])
      3'b101: offs = (instr[23:0] << 2) - 4;
      default: offs = 0;
    endcase
  end

  always @(posedge clk) begin
    offset <= offs;
  end

endmodule
