module instruction_memory #(parameter
  INSTR_LEN = 32,
  MEM_ADDR_SIZE = 5,
  PC_SIZE = 5
  )
  (
  input wire clk,
  input wire reset,
  input wire [1:0] phase,
  input wire [PC_SIZE-1:0] pc,
  output reg [INSTR_LEN-1:0] instr
  );

  
  // phase 00 = instr fetch
  // phase 01 = reg read
  // phase 10 = execute and mem
  // phase 11 = write back
  
  //reg [7:0] mem [(2 ** MEM_ADDR_SIZE)-1:0];
  reg [31:0] mem [31:0];  //creat a 32*32 memory

  initial begin
	mem [0] = 32'b00000000000000000000000000000000;
	mem [1] = 32'b00000000000000000000000000000001;
	mem [2] = 32'b00000000000000000000000000000010;
	mem [3] = 32'b00000000000000000000000000000011;
  end

  always @(posedge clk) begin
    if (reset) begin
      instr <= 0;
    end else begin
      case (phase)			//read only instr fetch
        2'b00: /*instr <= {mem[pc[MEM_ADDR_SIZE-1:0]], mem[pc[MEM_ADDR_SIZE-1:0]+1],
                mem[pc[MEM_ADDR_SIZE-1:0]+2], mem[pc[MEM_ADDR_SIZE-1:0]+3]};*/
					instr <= mem[pc];
        default: ;
      endcase
    end
  end
endmodule

`timescale 1ps/1ps		//set time scale
module instruction_memory_testbench();

reg clk;
reg reset;
reg [1:0] phase;
reg [4:0] pc;
wire [31:0] instr;

instruction_memory dut (clk, reset, phase, pc, instr);     

parameter CLOCK_PERIOD=100;

initial begin
 clk <= 0;
 forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
initial begin 
assign reset = 0; phase = 2'b00; pc = 5'b00011; @(posedge clk); @(posedge clk);
assign reset = 1; phase = 2'b00; pc = 5'b00000; @(posedge clk); @(posedge clk);
assign reset = 0; phase = 2'b01; pc = 5'b00011; @(posedge clk); @(posedge clk);
assign reset = 0; phase = 2'b10; pc = 5'b00011; @(posedge clk); @(posedge clk);
assign reset = 0; phase = 2'b00; pc = 5'b00000; @(posedge clk); @(posedge clk);
assign reset = 0; phase = 2'b00; pc = 5'b00001; @(posedge clk); @(posedge clk);
assign reset = 0; phase = 2'b00; pc = 5'b00010; @(posedge clk); @(posedge clk);
 
$stop; // End the simulation.


  
end  
endmodule 
