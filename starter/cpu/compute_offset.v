module compute_offset #(parameter
  REG_SIZE = 32
  )
  (
  input wire [REG_SIZE-1:0] instr,
  output wire signed [REG_SIZE-1:0] offset
  );

  wire signed [23:0] offs;
  always @(*) begin
    case (instr[27:25])
      3'b101: offs = (instr[23:0] << 2) - 4;
      default: offs = 0;
    endcase
    offset = {{8{offs[23]}}, offs};
  end

endmodule
