module flags #(parameter
  COND_LEN = 4,
  REG_SIZE = 32
  )
  (
  input wire clk,
  input wire [1:0] phase,
  input wire [COND_LEN-1:0] cond_code,
  input wire comp,
  input wire carry,
  input wire overflow,
  input wire [REG_SIZE-1:0] data,
  output reg cond_met
  );

  // phase 00 = instr fetch
  // phase 01 = reg read
  // phase 10 = execute and mem
  // phase 11 = write back
  reg N;
  reg Ze;
  reg V;
  reg C;

  reg ff;

  initial begin
    N = 1'b0; //negative
    Ze = 1'b0;//zero
    V = 1'b0;//(signed) overflow
    C = 1'b0;//(unsigned overflow) carry 
  end

  always @(*) begin
    case (cond_code)
      4'b0000: ff = Ze;
      4'b0001: ff = ~Ze;
      4'b0010: ff = C;
      4'b0011: ff = ~C;
      4'b0100: ff = N;
      4'b0101: ff = ~N;
      4'b0110: ff = V;
      4'b0111: ff = ~V;
      4'b1000: ff = C & ~Ze;
      4'b1001: ff = ~C | Ze;
      4'b1010: ff = N ^ V;
      4'b1011: ff = N ^~ V;
      4'b1100: ff = ~Ze & (N ^ V);
      4'b1101: ff = Ze | (N ^~ V);
      default: ff = 1;
    endcase
  end

  always @(posedge clk) begin
    if (comp) begin
      N <= data[31];
      if (data==32'b00000000000000000000000000000000) begin Ze <= 1; end
		else Ze <= 0;
		
      V <= overflow;
      C <= carry;
    end
	 case (phase)
	 2'b11: begin cond_met <= ff; end
	 default: ;
	 endcase
  end

endmodule


`timescale 1ps/1ps		//set time scale
module flags_testbench();
reg clk;
reg [1:0] phase;
reg [3:0] cond_code;
reg comp;
reg carry;
reg overflow;
reg [31:0] data;
wire cond_met;
flags dut (clk, phase, cond_code, comp, carry, overflow, data, cond_met);     

parameter CLOCK_PERIOD=100;

initial begin
 clk <= 0;
 forever #(CLOCK_PERIOD/2) clk <= ~clk;
 end
initial begin    
 assign cond_code = 4'b0000; phase = 2'b00; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0001; phase = 2'b00; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0010; phase = 2'b00; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0011; phase = 2'b00; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0100; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0101; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0110; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0111; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1000; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1001; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1010; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1011; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1100; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1101; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1110; phase = 2'b11; comp = 0; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 
 assign cond_code = 4'b0000; phase = 2'b11; comp = 1; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0001; phase = 2'b11; comp = 1; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0010; phase = 2'b11; comp = 1; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0011; phase = 2'b11; comp = 1; carry = 0; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0100; phase = 2'b11; comp = 0; carry = 1; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0101; phase = 2'b11; comp = 0; carry = 1; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0110; phase = 2'b11; comp = 0; carry = 1; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b0111; phase = 2'b11; comp = 0; carry = 1; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1000; phase = 2'b11; comp = 0; carry = 0; overflow = 1; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1001; phase = 2'b11; comp = 0; carry = 0; overflow = 1; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1010; phase = 2'b11; comp = 0; carry = 0; overflow = 1; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1011; phase = 2'b11; comp = 0; carry = 0; overflow = 1; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1100; phase = 2'b11; comp = 0; carry = 0; overflow = 1; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1101; phase = 2'b11; comp = 0; carry = 0; overflow = 1; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
 assign cond_code = 4'b1110; phase = 2'b11; comp = 0; carry = 1; overflow = 0; data = 32'b00000000000000000000000001010101; @(posedge clk); @(posedge clk);
$stop; // End the simulation.


  
end  
endmodule 

