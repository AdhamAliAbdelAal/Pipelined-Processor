//`timescale 1 ns / 10 ps

module CU_tb();
localparam PERIOD = 6;

reg[2:0] In;
reg clk;

wire WB, Alu, MR, MW, AluOp,Imm;

CU cu(In, clk, WB, Alu, MR, MW, AluOp,Imm);

always 
#(PERIOD/2) clk=~clk;


initial 
begin
clk = 0;

In = 3'b001;
#5
$display("In = %b WB = %b  Alu = %b MR = %b  MW = %b AluOp = %b  Imm = %b "
	 ,In ,WB, Alu, MR, MW, AluOp,Imm );

In = 3'b010;
#10
$display("In= %b WB = %b  Alu = %b MR = %b  MW = %b AluOp = %b  Imm = %b "
	 ,In ,WB, Alu, MR, MW, AluOp,Imm );

In = 3'b011;
#5
$display("In= %b WB = %b  Alu = %b MR = %b  MW = %b AluOp = %b  Imm = %b "
	 ,In ,WB, Alu, MR, MW, AluOp,Imm );

In = 3'b100;
#5
$display("In = %b WB = %b  Alu = %b MR = %b  MW = %b AluOp = %b  Imm = %b "
	 ,In ,WB, Alu, MR, MW, AluOp,Imm );

In = 3'b101;
#5
$display("In = %b WB = %b  Alu = %b MR = %b  MW = %b AluOp = %b  Imm = %b "
	 ,In ,WB, Alu, MR, MW, AluOp,Imm );

In = 3'b111;
#5
$display("In = %b WB = %b  Alu = %b MR = %b  MW = %b AluOp = %b  Imm = %b "
	 ,In ,WB, Alu, MR, MW, AluOp,Imm );

end






endmodule
