module cpu(
  input wire clk,
  input wire nreset,
  output wire led,
  output wire [7:0] debug_port1,
  output wire [7:0] debug_port2,
  output wire [7:0] debug_port3,
  output wire [7:0] debug_port4,
  output wire [7:0] debug_port5,
  output wire [7:0] debug_port6,
  output wire [7:0] debug_port7
  );

  parameter INSTR_LEN = 32;
  parameter MEM_SIZE = (2 ** 10);
  parameter REG_SIZE = 32;
  parameter REG_ADDR = 4;

  reg [REG_SIZE-1:0] d0;
  reg [REG_SIZE-1:0] d1;
  reg [REG_ADDR-1:0] r0;
  reg [REG_ADDR-1:0] r1;
  reg [REG_ADDR-1:0] ws;
  reg [REG_SIZE-1:0] din;
  reg [REG_SIZE-1:0] pc;
  reg [REG_SIZE-1:0] mem_dat;
  reg [INSTR_LEN-1:0] inst;
  reg signed [REG_SIZE-1:0] offset;
  reg [3:0] opcode;
  reg [3:0] cond_code;
  reg [7:0] shift;
  reg [3:0] rot;
  reg [7:0] imm;
  reg [3:0] shift_reg;
  reg [3:0] shift_byte;
  reg b_imm;
  reg we;
  reg set_cond;
  reg carry;
  reg overflow;
  reg cond_met;
  reg mem_en;
  reg ld_st;

  // phase 00 = instr fetch
  // phase 01 = reg read
  // phase 10 = execute and mem
  // phase 11 = write back
  reg [1:0] phase;

  initial begin
    phase <= 0;
  end
  // Controls the LED on the board.
  assign led = 1'b1;

  always @* begin
    // These are how you communicate back to the serial port debugger.
    debug_port1 = pc[7:0];
    debug_port2 = {6'b000000, phase};
    debug_port3 = 8'h03;
    debug_port4 = 8'h04;
    debug_port5 = 8'h05;
    debug_port6 = 8'h06;
    debug_port7 = 8'h07;

    cond_code = inst[31:28];
    b_imm = inst[27:24]; //b_imm[1] means op 2 is register
    mem_en = (inst[27:26] == 2'b01);
    set_cond = inst[20];
    ld_st = inst[20];
    r0 = inst[19:16];
    ws = inst[15:12];
    //op 2 if b_imm == 0
    shift = inst[11:4];
    shift_reg = inst[11:8];
    if (mem_en) begin
      opcode = 4'b1101;
      r1 = inst[15:12];
    end else begin
      opcode = inst[24:21];
      r1 = inst[3:0];
    end
    //op 2 is b_imm == 1
    rot = inst[11:8];
    imm = inst[7:0];
  end

  instruction_memory im (clk, nreset, phase, pc, inst);
  register_file rf (clk, nreset, phase, r0, r1, ws, shift_reg, offset, we, mem_en, din, mem_dat, d0, d1, shift_byte, pc);
  compute_offset of (inst, offset);
  flags f (clk, cond_code, set_cond, carry, overflow, din, cond_met);
  ALU alu (opcode, d0, d1, imm, shift, rot, shift_byte, b_imm, din, overflow, carry, we);
  data_mem dm (clk, phase, din, d0, mem_en, ld_st, mem_dat);

  always @(posedge clk) begin
    if (~nreset) begin
      phase <= 0;
    end else begin
      phase <= phase + 1;
    end
  end

endmodule
