module instruction_memory #(parameter
  INSTR_LEN = 32,
  MEM_ADDR_SIZE = 32
  )
  (
  input wire clk,
  input wire nreset,
  input wire [MEM_ADDR_SIZE-1:0] pc,
  output wire [INSTR_LEN-1:0] instr
  );

  reg [INSTR_LEN-1:0] mem [(2 ** MEM_ADDR_SIZE)-1:0];

  initial begin
    //$readmemh("data.hex", mem);
    mem[0] <= 32'hEB000002;
    mem[1] <= 32'hEA000000;
    mem[10] <= 32'hEAFFFFF6;
  end

  always @(posedge clk) begin
    if (nreset) begin
      instr <= 0;
    end else begin
      instr <= mem[pc];
    end
  end
endmodule
