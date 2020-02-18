module RegisterFile(OutData1, OutData2, OutAddr1, OutAddr2, InData, InAddr, En, Clock);
output logic [31:0] OutData1, OutData2;
input  logic En, Clock;
input  logic [4:0] OutAddr1, OutAddr2, InAddr;
input  logic [31:0] InData;

logic [31:0] memory_array [31:0];		//creat a 32*32 Array

always_ff @(posedge Clock) begin
	
	if (En) begin		//write
		memory_array[InAddr] <= InData;
	end	
	
end

assign OutData1 = memory_array[OutAddr1];

assign OutData2 = memory_array[OutAddr2];
endmodule

`timescale 1ps/1ps		//set time scale
module RegisterFile_testbench();
logic [31:0] OutData1, OutData2;
logic En, Clock;
logic [4:0] OutAddr1, OutAddr2, InAddr;
logic [31:0] InData;       
RegisterFile dut (OutData1, OutData2, OutAddr1, OutAddr2, InData, InAddr, En, Clock);     

parameter CLOCK_PERIOD=100;
initial begin
 Clock <= 0;
 forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
 end
 
integer i, j, k;

initial begin    

for (k = 0; k < 32; k++) begin
	InAddr = k; InData = k; En =1; @(posedge Clock); @(posedge Clock);
end

for (i = 0; i < 32; i++) begin
	OutAddr1 = i; @(posedge Clock); @(posedge Clock);
end

for (j = 0; j < 32; j++) begin
	OutAddr2 = j; @(posedge Clock); @(posedge Clock);
end
$stop; // End the simulation.


  
end  
endmodule 