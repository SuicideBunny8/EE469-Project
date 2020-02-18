module instruction_memory #(parameter
  INSTR_LEN = 32,
  MEM_ADDR_SIZE = 10,
  PC_SIZE = 32
  )
  (
  input wire clk,
  input wire nreset,
  input wire [1:0] phase,
  input wire [PC_SIZE-1:0] pc,
  output wire [INSTR_LEN-1:0] instr
  );

  reg [7:0] mem [(2 ** MEM_ADDR_SIZE)-1:0];
  integer i;

  initial begin
    //$readmemh("data.hex", mem);
    for (i=0;i<(2 ** MEM_ADDR_SIZE);i++)
      mem[i] = 0;
  end

  always @(posedge clk) begin
    if (~nreset) begin
      instr <= 0;
    end else begin
      case (phase)
        2'b00: instr <= {mem[pc[MEM_ADDR_SIZE-1:0]], mem[pc[MEM_ADDR_SIZE-1:0]+1],
                mem[pc[MEM_ADDR_SIZE-1:0]+2], mem[pc[MEM_ADDR_SIZE-1:0]+3]};
        default: ;
      endcase
    end
  end
endmodule
