module data_mem #(parameter
  MEM_ADDR_SIZE = 16,,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire [1:0] phase,
  input wire [REG_SIZE-1:0] din,
  input wire [REG_SIZE-1:0] addr,
  input wire en,
  input wire read_not_write,
  output wire [REG_SIZE-1:0] dout
  );

  reg [7:0] mem [(2 ** MEM_ADDR_SIZE)-1:0];

  always @(posedge clk) begin
    if (~nreset) begin
      dout <= 0;
    end else if (en) begin
      case (phase)
        2'b10: begin
                 if (~read_not_write) begin
                   mem[addr] <= din;
                 end
                 dout <= {mem[addr[MEM_ADDR_SIZE-1:0]], mem[addr[MEM_ADDR_SIZE-1:0]+1],
                          mem[addr[MEM_ADDR_SIZE-1:0]+2], mem[addr[MEM_ADDR_SIZE-1:0]+3]};
               end
        default: ;
      endcase
    end
  end
endmodule
