module RegFile(write_back, read_data1, read_data2, write_data, clk,
src_addr,dst_addr,write_addr);

input write_back;       
input [15:0] write_data;
input clk;
input [2:0]src_addr;   	//Source Address
input [2:0] dst_addr;  	//Destination Address
input [2:0] write_addr; //Write_back Address
output reg [15:0] read_data1; //Data1
output reg [15:0] read_data2; //Data2
reg [15:0] registers[0:7];

/*Sync*/
always@(posedge clk)
begin
if(write_back) 
	registers[write_addr] = write_data;

end   //End of Always Module

/*Sync*/
always@(negedge clk)
begin
 read_data1 = registers[dst_addr];
 read_data2 = registers[src_addr];
end  //End of Always Module


/*Async*/
//Assign Source and Destination
// assign read_data1 = registers[dst_addr];
// assign read_data2 = registers[src_addr];
endmodule

