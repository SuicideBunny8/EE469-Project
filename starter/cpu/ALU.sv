module ALU (InData1, InData2, sel, Outdata);

input logic [7:0] InData1, InData2;
input logic [3:0] sel;
output logic [7:0] Outdata; 

logic flag = 8'b00000000;

always_comb begin

case (sel)
4'b0000: Outdata = InData1 + InData2;
4'b0001: Outdata = InData1 - InData2;
4'b0010: Outdata = InData1 * InData2;
4'b0011: Outdata = InData1 / InData2;
4'b0100: Outdata = InData1 << 1;
4'b0101: Outdata = InData1 >> 1;
4'b0110: Outdata = {InData1[6:0], InData1[7]};
4'b0111: Outdata = {InData1[0], InData1[7:1]};
4'b1000: Outdata = InData1 & InData2;
4'b1001: Outdata = InData1 | InData2;
4'b1010: Outdata = InData1 ^ InData2;
4'b1011: Outdata = ~(InData1 | InData2);
4'b1100: Outdata = ~(InData1 & InData2);
4'b1101: Outdata = ~(InData1 ^ InData2);
4'b1110: begin 
				if(InData1 - InData2 >=0) Outdata = 1; 
				else  Outdata = 0;
			end

4'b1111: begin 
				if(InData1 == InData2) Outdata = 1; 
				else  Outdata = 0;
			end

endcase

end

endmodule

module ALU_testbench(); //testbench
   
logic [7:0] InData1, InData2;
logic [3:0] sel;
logic [7:0] Outdata;
 integer i;
 ALU dut (InData1, InData2, sel, Outdata);
assign InData1 = 8'b10100011;
assign InData2 = 8'b10101100;

 // Set up the inputs to the design. Each line is a clock cycle.
 initial begin
 sel = 4'b0000;
 for (i = 0; i<16; i++) begin
sel = sel + 1; #10;
 end
 $stop; // End the simulation.
 end
endmodule