module Lab_1(Addr, Rd, Rn, pd, Clock, Bopcode, CBopcode, Ropcode, Dopcode, CondCode, OutData1, OutData2, InData, InAddr, En);

output logic [5:0] Bopcode;
output logic [7:0] CBopcode;
output logic [10:0] Ropcode;
output logic [10:0] Dopcode;
output logic [5:0] CondCode;
output logic [4:0] Rd;
output logic [4:0] Rn;
output logic [4:0] pd;
output logic [31:0] OutData1, OutData2;

input logic [4:0] Addr;
input logic Clock, En;
input logic [31:0] InData;
input logic [4:0] InAddr;


logic [31:0] DataOut;
InstructionMemory IM1(.Addr(Addr), .DataOut(DataOut), .Clock(Clock));


always_comb begin 
		if (DataOut[31:26] == 6'b000101) begin 
		pd = Addr;
		Bopcode = DataOut[31:26]; 
		CBopcode = 8'b00000000;
		CondCode = 5'b00000;
		Ropcode = 11'b00000000000;
		Dopcode = 11'b00000000000;
		Rd = DataOut[4:0];
		Rn = DataOut[9:5];
		end
		
		else if (DataOut[31:24] == 8'b01010100) begin 
		pd = Addr;
		CBopcode = DataOut[31:24]; 
		CondCode = DataOut[4:0];
		Bopcode = 6'b000000;
		Ropcode = 11'b00000000000;
		Dopcode = 11'b00000000000;
		Rd = DataOut[4:0];
		Rn = DataOut[9:5];
		end
		
		else if (DataOut[31:21] == 11'b11111000010) begin 
		pd = Addr;
		Dopcode = DataOut[31:21]; 
		CBopcode = 8'b00000000;
		CondCode = 5'b00000;
		Bopcode = 6'b000000;
		Ropcode = 11'b00000000000;
		Rd = DataOut[4:0];
		Rn = DataOut[9:5];
		end
		else if ((DataOut[31:21] == 11'b10001011000)||
		(DataOut[31:21] == 11'b11001011000)||
		(DataOut[31:21] == 11'b11001010000)||
		(DataOut[31:21] == 11'b10101010000)) 
		begin 
		pd = Addr;
		Ropcode = DataOut[31:21]; 
		Bopcode = 6'b000000;
		CBopcode = 8'b00000000;
		CondCode = 5'b00000;
		Dopcode = 11'b00000000000;
		Rd = DataOut[4:0];
		Rn = DataOut[9:5];
		end
		else begin
		pd = Addr;
		Ropcode = 11'b00000000000; 
		Bopcode = 6'b000000;
		CBopcode = 8'b00000000;
		CondCode = 5'b00000;
		Dopcode = 11'b00000000000;
		Rd = DataOut[4:0];
		Rn = DataOut[9:5];
		end
		
			
end
logic zero = 32'b00000000000000000000000000000000;
RegisterFile RF1(.OutData1(OutData1), .OutData2(OutData2), .OutAddr1(Rd), .OutAddr2(Rn), .InData(InData), .InAddr(InAddr), .En(En), .Clock(Clock));

endmodule

`timescale 1ps/1ps		//set time scale
module Lab_1_testbench();
logic [5:0] Bopcode;
logic [7:0] CBopcode;
logic [10:0] Ropcode;
logic [10:0] Dopcode;
logic [5:0] CondCode;
logic [4:0] Rd;
logic [4:0] Rn;
logic [4:0] pd;
logic [31:0] OutData1, OutData2;

logic [4:0] Addr;
logic Clock, En;
logic [31:0] InData;
logic [4:0] InAddr;       
Lab_1 dut (Addr, Rd, Rn, pd, Clock, Bopcode, CBopcode, Ropcode, Dopcode, CondCode, OutData1, OutData2, InData, InAddr, En);     

parameter CLOCK_PERIOD=100;
initial begin
 Clock <= 0;
 forever #(CLOCK_PERIOD/2) Clock <= ~Clock;
 end
 
integer j, k;

initial begin  

for (k = 0; k < 32; k++) begin
	InAddr = k; InData = k; En =1; @(posedge Clock); @(posedge Clock);
end  

for (j = 0; j < 32; j++) begin
	Addr = j; @(posedge Clock); @(posedge Clock);
end

$stop; // End the simulation.


  
end  
endmodule 