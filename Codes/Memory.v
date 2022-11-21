
module Memory(Address, Write_Data,Read_Data,MW,MR,clk);

input [31:0]Address;
input  MW,MR,clk;
input [15:0]Write_Data;
output reg [15:0]Read_Data;
reg [15:0]memory[0:2047];

always @(posedge clk ) begin
	if( MW ==1)
	begin
	memory[Address[10:0]]=Write_Data[15:0];
	end
end
always @(*) begin
	if( MR ==1)
	begin
	Read_Data=memory[Address[10:0]];
	end
end
endmodule

