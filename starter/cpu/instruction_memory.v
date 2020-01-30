module instruction_memory #(parameter PC_LEN = 10,
          parameter INSTR_LEN = 31,
          parameter MEM_SIZE = (2 ** 10))
          (input wire clk,
          input wire nreset,
          input pc,
          output instr);

  logic [MEM_SIZE:0][INSTR_LEN:0] mem;

  always_ff @(posedge clk) begin
    if (nreset) begin
      instr <= 0;
    end else begin
      instr <= mem[pc]
    end
  end
endmodule
