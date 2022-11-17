module Program_Counter(reset ,clk, PC_Out);
input clk, reset;
output reg[31:0]PC_Out;

always @(posedge clk)
begin
if(reset ==1)
begin
PC_Out = {{26{1'b0}},6'b10_0000};
end
else begin
PC_Out=PC_Out +2;
end
end

endmodule


