module CU (In,clk, WB, Alu, MR, MW, AluOp,Imm);
input clk;
input [2:0] In; 
output reg WB, Alu, MR, MW, AluOp,Imm;
always @(posedge clk )begin
//load immediate
if(In == 3'b001)begin
{WB, Imm} = 2'b11;
{Alu, MR, MW, AluOp}= 4'b0000;
end
//store value
else if(In == 3'b010)begin
{WB, Imm, Alu, AluOp, MR} = 5'b00000;
MW= 1'b1;
end
//Add 
else if(In == 3'b011)begin
{WB,Alu, AluOp} = 3'b110;
{MW,MR,Imm }= 3'b000;
end

//NOT
else if(In == 3'b100)begin
{WB,Alu, AluOp} = 3'b111;
{MW,MR,Imm }= 3'b000;
end

else begin
{WB, Alu, MR, MW, AluOp,Imm} = 6'b000000;
end

end

endmodule
