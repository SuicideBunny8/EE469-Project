module decode #(parameter
  PC_LEN = 32,
  REG_ADDR = 4,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire instr,
  input wire [REG_SIZE-1:0] d0,
  input wire [REG_SIZE-1:0] d1,
  inout wire [PC_LEN-1:0] pc,
  output wire [REG_ADDR-1:0] r0,
  output wire [REG_ADDR-1:0] r1,
  output wire [REG_SIZE-1:0] wd,
  output wire ws
  );

  wire [3:0] cond;
  wire [3:0] branch;
  wire signed [23:0] branch_offset;
  wire [3:0] opcode;
  wire cond_met;

  assign cond = instr[31:28];
  assign branch = instr[27:24];
  assign branch_offset = {{8{instr[23]}}, instr[23:0]};

  flags f (clk, cond, opcode, ~(branch[3:1] & 3'b101), d0, d1, cond_met);

  always @(posedge clk) begin
    case (branch)
      4'b1010: begin
                 if (cond_met)
                   pc <= pc + offset;
               end
      4'b1011: begin // Branch with link
                 if (cond_met) begin
                   ws <= 1'b1;
                   r0 <= 4'b1110;
                   wd <= pc;
                   pc <= pc + offset - 1'b1;
                 end
               end
      default: ;
    endcase
  end

endmodule
