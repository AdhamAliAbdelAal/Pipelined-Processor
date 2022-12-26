module RegFile(write_back, read_data1, read_data2, write_data, clk,
src_addr,dst_addr,write_addr,reset);

input write_back;       
input [15:0] write_data;
input clk,reset;
input [2:0]src_addr;   	//Source Address
input [2:0] dst_addr;  	//Destination Address
input [2:0] write_addr; //Write_back Address
output [15:0] read_data1; //Data1
output [15:0] read_data2; //Data2
reg [15:0] registers[0:7];
integer i;

/*Sync*/
always@(negedge clk)
begin
if(reset)
begin
  for (i=0; i<16; i=i+1) begin
	registers[i]=8'd0;
  end
end
else if(write_back) 
	registers[write_addr] = write_data;
end   //End of Always Module

/*Async*/
// Assign Source and Destination
assign read_data1 = registers[dst_addr];
assign read_data2 = registers[src_addr];
endmodule

