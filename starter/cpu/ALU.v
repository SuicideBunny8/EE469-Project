module ALU #(parameter
  REG_SIZE = 32,
  ADDR_SIZE = 4
  )
  (
  input wire [3:0] opcode,
  input wire [REG_SIZE-1:0] d0,
  input wire [REG_SIZE-1:0] d1,
  input wire [7:0] Imm,
  input wire [7:0] shift,
  input wire [3:0] rot,
  input wire [3:0] shift_byte,
  input wire b_imm,
  output wire [REG_SIZE-1:0] data_out,
  output wire overflow,
  output wire carry,
  output wire we
  );

  reg [REG_SIZE-1:0] op2;
  reg [REG_SIZE:0] int_dout;
  reg [REG_SIZE-1:0] ext_imm;
  reg prev_carry;

  always @(*) begin
    case (b_imm)
      1'b0: begin
              case (shift[2:1])
                2'b00: begin // logical left shift
                          if (shift[0])
                            op2 = d1 << shift_byte;
                          else
                            op2 = d1 << shift[7:3];
                       end
                2'b01: begin // logical right shift
                          if (shift[0])
                            op2 = d1 >> shift_byte;
                          else
                            op2 = d1 >> shift[7:3];
                       end
                2'b10: begin // arithmetic right shift
                          if (shift[0])
                            op2 = d1 >>> shift_byte;
                          else
                            op2 = d1 >>> shift[7:3];
                       end
                2'b11: begin // rotate right shift
                          if (shift[0])
                            op2 = {d1[shift[7:3]-1:0], d1[REG_SIZE-1:shift[7:3]]};
                          else
                            op2 = {d1[shift_byte-1:0], d1[REG_SIZE-1:shift_byte]};
                       end
              endcase
            end
      1'b1: begin
              ext_imm = {24'h000000, Imm};
              op2 = {ext_imm[rot-1:0], ext_imm[REG_SIZE-1:rot]};
            end
    endcase

    case (opcode)
      4'b0000: begin
                  int_dout = d0 & op2;
                  we = 1'b1;
               end // AND - Rd:= Op1 AND Op2
      4'b0001: begin
                  int_dout = d0 ^ op2;
                  we = 1'b1;
               end // EOR - Rd:= Op1 EOR Op2
      4'b0010: begin
                  int_dout = d0 - op2;
                  we = 1'b1;
               end // SUB - Rd:= Op1 - Op2
      4'b0011: begin
                  int_dout = op2 - d0;
                  we = 1'b1;
               end // RSB - Rd:= Op2 - Op1
      4'b0100: begin
                  int_dout = d0 + op2;
                  we = 1'b1;
               end // ADD - Rd:= Op1 + Op2
      4'b0101: begin
                  int_dout = d0 + op2 + prev_carry;
                  we = 1'b1;
               end // ADC - Rd:= Op1 + Op2 + C
      4'b0110: begin
                  int_dout = d0 - op2 + prev_carry - 1;
                  we = 1'b1;
               end // SBC - Rd:= Op1 - Op2 + C - 1
      4'b0111: begin
                  int_dout = op2 - d0 + prev_carry - 1;
                  we = 1'b1;
               end // RSC - Rd:= Op2 - Op1 + C - 1
      4'b1000: begin
                  int_dout = d0 & op2;
                  we = 1'b0;
               end // TST - set condition codes on Op1 AND Op2
      4'b1001: begin
                  int_dout = d0 ^ op2;
                  we = 1'b0;
               end // TEQ - set condition codes on Op1 EOR Op2
      4'b1010: begin
                  int_dout = d0 - op2;
                  we = 1'b0;
               end // CMP - set condition codes on Op1 - Op2
      4'b1011: begin
                  int_dout = d0 + op2;
                  we = 1'b0;
               end // CMN - set condition codes on Op1 + Op2
      4'b1100: begin
                  int_dout = d0 | op2;
                  we = 1'b1;
               end // ORR - Rd:= Op1 OR Op2
      4'b1101: begin
                  int_dout = op2;
                  we = 1'b1;
               end // MOV - Rd:= Op2
      4'b1110: begin
                  int_dout = d0 & ~(op2);
                  we = 1'b1;
               end // BIC - Rd:= Op1 AND NOT Op2
      4'b1111: begin
                  int_dout =  ~(op2);
                  we = 1'b1;
               end // MVN - Rd:= NOT Op2
    endcase
    prev_carry = int_dout[32];
    carry = prev_carry;
    overflow = ~d0[31] & ~op2[31] & int_dout[31];
    data_out = int_dout[REG_SIZE-1:0];
  end
endmodule
