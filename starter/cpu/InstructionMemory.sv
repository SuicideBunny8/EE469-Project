module InstructionMemory(Addr, DataOut, Clock);

output logic [31:0] DataOut;
input logic Clock;
input logic [4:0] Addr; 

logic [31:0] memory_array [31:0];		//creat a 32*32 Array

assign memory_array[0] = 32'b00000000000000000000000000000000; //
assign memory_array[1] = 32'b01010100111111111111111101100000; //B.EQ -5		//if(Equal) PC = PC + 4*-5
assign memory_array[2] = 32'b01010100111111111111111101100001;	//B.NE -5		//if(notEqual) PC = PC + 4*-5
assign memory_array[3] = 32'b01010100111111111111111101101010;	//B.GE -5		//if(graterOrEqualThan) PC = PC + 4*-5
assign memory_array[4] = 32'b01010100111111111111111101101011;	//B.LT -5		//if(lessThan) PC = PC + 4*-5
assign memory_array[5] = 32'b01010100111111111111111101101100;	//B.GT -5		//if(greaterThan) PC = PC + 4*-5
assign memory_array[6] = 32'b01010100111111111111111101101101;	//B.LE -5		//if(lessOrEqualThan) PC = PC + 4*-5
assign memory_array[7] = 32'b00000000000000000000000000000000;

assign memory_array[8] = 32'b11111000010000001100000111100110; //LDUR X6, [X15, #12]	//X6 = [X15, #12]
assign memory_array[9] = 32'b10001011000001000000000001100010;	//ADD X2, X3, X4			//X2 = X3 + X4
assign memory_array[10] = 32'b11001011000001110000000011000101;//SUB X5, X6, X7			//X5 = X6 + X7
assign memory_array[11] = 32'b11001010000010100000000100101000;//EOR X8, X9, X10			//X8 = X9 + X10
assign memory_array[12] = 32'b10101010000011010000000110001011;//ORR X11, X12, X13		//X11 = X12 + X13
assign memory_array[13] = 32'b00010111111111111111111111101100;//B -13			//PC = PC + 4*-13
assign memory_array[14] = 32'b00000000000000000000000000000000;
assign memory_array[15] = 32'b00000000000000000000000000000000;

assign memory_array[16] = 32'b00000000000000000000000000000000; //
assign memory_array[17] = 32'b00000000000000000000000000000000; 
assign memory_array[18] = 32'b00000000000000000000000000000000;
assign memory_array[19] = 32'b00000000000000000000000000000000;
assign memory_array[20] = 32'b00000000000000000000000000000000;
assign memory_array[21] = 32'b00000000000000000000000000000000;
assign memory_array[22] = 32'b00000000000000000000000000000000;
assign memory_array[23] = 32'b00000000000000000000000000000000;

assign memory_array[24] = 32'b00000000000000000000000000000000;
assign memory_array[25] = 32'b00000000000000000000000000000000; //
assign memory_array[26] = 32'b00000000000000000000000000000000;
assign memory_array[27] = 32'b00000000000000000000000000000000;
assign memory_array[28] = 32'b00000000000000000000000000000000;
assign memory_array[29] = 32'b00000000000000000000000000000000;
assign memory_array[30] = 32'b00000000000000000000000000000000;
assign memory_array[31] = 32'b00000000000000000000000000000000; //

assign DataOut = memory_array[Addr];

endmodule

`timescale 1ps/1ps		//set time scale
module InstructionMemory_testbench();

logic [31:0] DataOut;
logic Clock;
logic [4:0] Addr; 

InstructionMemory dut (Addr, DataOut, Clock);    

parameter CLOCK_PERIOD=100;
initial begin
 Clock <= 0;
 forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
 end
 
integer i;

initial begin    

for (i = 0; i < 32; i++) begin
	Addr = i; @(posedge Clock); @(posedge Clock);
end

$stop; // End the simulation.


  
end  
endmodule 

