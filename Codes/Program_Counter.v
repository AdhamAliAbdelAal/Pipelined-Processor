module Program_Counter(reset ,clk, PC_Out, stall);
input clk, reset, stall;
output reg[31:0]PC_Out;

always @(posedge clk)
begin
if(reset ==1)
begin
PC_Out = {{26{1'b0}},6'b10_0000};
end
else if (stall===1'b1)
begin
  PC_Out=PC_Out;
end
else if (PC_Out<32'd50 && stall===1'b0)begin
PC_Out=PC_Out + 1;
end
end

endmodule


