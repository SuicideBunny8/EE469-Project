module ALU (InData1, InData2, Instruction, Outdata);

input logic [31:0] InData1, InData2;
input logic [31:0] Instruction;
output logic [31:0] Outdata; 

logic [4:0] Cond = Instruction[31:28];
logic I = Instruction[25];
logic [4:0] OpCode = Instruction[24:21];
logic S = Instruction[20];
logic [4:0] Rn = Instruction[19:16];
logic [4:0] Rd = Instruction[15:12];
logic [11:0] Op2 = Instruction[11:0];

always_comb begin
		if (I == 1) begin
			logic [7:0] Shift = Op2[11:4];
			logic [3:0] Rm = Op2[3:0];
		end
		
		if (I == 0) begin
			logic [7:0] Rotate = Op2[11:8];
			logic [3:0] Imm = Op2[7:0];
		end
end
//*************
always_comb begin

case (sel)
4'b0000: Outdata = InData1 + InData2;//AND - Rd:= Op1 AND Op2
4'b0001: Outdata = InData1 - InData2;//EOR - Rd:= Op1 EOR Op2
4'b0010: Outdata = InData1 * InData2;//SUB - Rd:= Op1 - Op2
4'b0011: Outdata = InData1 / InData2;//RSB - Rd:= Op2 - Op1
4'b0100: Outdata = InData1 << 1;//ADD - Rd:= Op1 + Op2
4'b0101: Outdata = InData1 >> 1;//ADC - Rd:= Op1 + Op2 + C
4'b0110: Outdata = {InData1[30:0], InData1[7]};//SBC - Rd:= Op1 - Op2 + C - 1
4'b0111: Outdata = {InData1[0], InData1[31:1]};//RSC - Rd:= Op2 - Op1 + C - 1
4'b1000: Outdata = InData1 & InData2;//TST - set condition codes on Op1 AND Op2
4'b1001: Outdata = InData1 | InData2;//TEQ - set condition codes on Op1 EOR Op2
4'b1010: Outdata = InData1 ^ InData2;//CMP - set condition codes on Op1 - Op2
4'b1011: Outdata = ~(InData1 | InData2);//CMN - set condition codes on Op1 + Op2
4'b1100: Outdata = ~(InData1 & InData2);//ORR - Rd:= Op1 OR Op2
4'b1101: Outdata = ~(InData1 ^ InData2);//MOV - Rd:= Op2
4'b1110: begin 													//BIC - Rd:= Op1 AND NOT Op2
				if(InData1 - InData2 >=0) Outdata = 1; 
				else  Outdata = 0;
			end

4'b1111: begin 													//MVN - Rd:= NOT Op2
				if(InData1 == InData2) Outdata = 1; 
				else  Outdata = 0;
			end

endcase

end

endmodule

module ALU_testbench(); //testbench
   
logic [31:0] InData1, InData2;
logic [3:0] sel;
logic [31:0] Outdata;
 integer i;
 ALU dut (InData1, InData2, sel, Outdata);
assign InData1 = 32'b00000000000000000000000010100011;
assign InData2 = 32'b00000000000000000000000010101100;

 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
 sel = 4'b0000;
 for (i = 0; i<16; i++) begin
sel = sel + 1; #10;
 end
 $stop; // End the simulation.
 end
endmodule