module Program_Counter(reset ,clk, PC_Out, stall,INT,JMP,JWSP,accPC,Dst);
input clk, reset, stall,INT,JMP,JWSP;
input [31:0] accPC,Dst;
output reg[31:0]PC_Out;

always @(posedge clk)
begin
if(INT===1'b1)
begin
    PC_Out=32'd0;
end
else if(reset ==1)
begin
PC_Out = {{26{1'b0}},6'b10_0000};
end
else if (stall===1'b1)
begin
  PC_Out=PC_Out;
end
else if(JMP==1'b1)
begin
    PC_Out = Dst;
end
else if(JWSP==1'b1)
begin
    PC_Out = accPC;
end
else if (PC_Out<32'd50 && stall===1'b0)begin
PC_Out=PC_Out + 1;
end
end

endmodule


