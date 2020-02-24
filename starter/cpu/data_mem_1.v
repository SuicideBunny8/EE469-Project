module data_mem #(parameter
  MEM_ADDR_SIZE = 5,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire [1:0] phase,
  input wire [REG_SIZE-1:0] din,
  input wire [MEM_ADDR_SIZE-1:0] addr,
  input wire en,
  input wire read_not_write,
  output reg [REG_SIZE-1:0] dout
  );
  
  // phase 00 = instr fetch
  // phase 01 = reg read
  // phase 10 = execute and mem
  // phase 11 = write back

  reg [31:0] mem [31:0];  //creat a 32*32 memory
  


  always @(posedge clk) begin
    if (en) begin
      case (phase)
        2'b10: begin						//phase 10 = execute and mem
                 if (~read_not_write) begin
                   mem[addr] <= din;
                 end
					  dout <= mem[addr];
                 /*dout <= {mem[addr[MEM_ADDR_SIZE-1:0]], mem[addr[MEM_ADDR_SIZE-1:0]+1],
                          mem[addr[MEM_ADDR_SIZE-1:0]+2], mem[addr[MEM_ADDR_SIZE-1:0]+3]};*/	  
               end
        default: ;
      endcase
    end
  end
endmodule


`timescale 1ps/1ps		//set time scale
module data_mem_testbench();

reg clk;
reg [1:0] phase;
reg [31:0] din;
reg [5:0] addr;
reg en;
reg read_not_write;
wire [31:0] dout;

data_mem dut (clk, phase, din, addr, en, read_not_write, dout);     

parameter CLOCK_PERIOD=100;

initial begin
 clk <= 0;
 forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
initial begin 
//check phase  
assign phase = 2'b00; en = 1; read_not_write = 0;din = 32'b00000000000000000000000001010101;addr = 5'b00000; @(posedge clk); @(posedge clk);
assign phase = 2'b01; en = 1; read_not_write = 0;din = 32'b00000000000000000000000001010101;addr = 5'b00000; @(posedge clk); @(posedge clk);
assign phase = 2'b11; en = 1; read_not_write = 0;din = 32'b00000000000000000000000001010101;addr = 5'b00000; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 0;din = 32'b00000000000000000000000001010101;addr = 5'b00000; @(posedge clk); @(posedge clk);
//check write
assign phase = 2'b10; en = 0; read_not_write = 1;din = 32'b00000000000000000000000001111111;addr = 5'b00001; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 0;din = 32'b00000000000000000000000000000010;addr = 5'b00010; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 0;din = 32'b00000000000000000000000000000011;addr = 5'b00011; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 0;din = 32'b00000000000000000000000000000100;addr = 5'b00100; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 0;din = 32'b00000000000000000000000000000101;addr = 5'b00101; @(posedge clk); @(posedge clk);
//check read
assign phase = 2'b10; en = 1; read_not_write = 1;din = 32'b00000000000000000000000001111111;addr = 5'b00001; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 1;din = 32'b00000000000000000000000001111111;addr = 5'b00010; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 1;din = 32'b00000000000000000000000001111111;addr = 5'b00011; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 1;din = 32'b00000000000000000000000001111111;addr = 5'b00100; @(posedge clk); @(posedge clk);
assign phase = 2'b10; en = 1; read_not_write = 1;din = 32'b00000000000000000000000001111111;addr = 5'b00101; @(posedge clk); @(posedge clk);
		  
 
$stop; // End the simulation.


  
end  
endmodule 