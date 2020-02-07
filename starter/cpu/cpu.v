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

  parameter PC_LEN = 32;
  parameter INSTR_LEN = 32;
  parameter MEM_SIZE = (2 ** 10);
  parameter REG_SIZE = 32;
  parameter REG_ADDR = 4;

  reg [PC_LEN-1:0] pc;

  wire [REG_SIZE-1:0] d0;
  wire [REG_SIZE-1:0] d1;
  wire [REG_ADDR-1:0] r0;
  wire [REG_ADDR-1:0] r1;
  wire [REG_SIZE-1:0] din;
  wire [24:0] offset;
  wire ws;
  wire inst;


  // Controls the LED on the board.
  assign led = 1'b1;

  // These are how you communicate back to the serial port debugger.
  assign debug_port1 = pc[7:0];
  assign debug_port2 = 8'h02;
  assign debug_port3 = 8'h03;
  assign debug_port4 = 8'h04;
  assign debug_port5 = 8'h05;
  assign debug_port6 = 8'h06;
  assign debug_port7 = 8'h07;

  instruction_memory im (clk, nreset, pc, inst);
  register_file rf (clk, nreset, r0, r1, ws, din, d0, d1);
  compute_offset of (clk, inst, offset);

  always @(posedge clk) begin
    if (~nreset)
      pc <= 0;
    else
      pc <= pc + 4 + offset;
  end

endmodule
