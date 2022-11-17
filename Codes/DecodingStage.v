
`include "RegFile.v"
`include "Mux2Inputs.v"

module  DecodingStage(immediate, write_back, read_data1, alu_input2,  write_data, clk,
src_addr,dst_addr,write_addr, category);

input  write_back;       
input [15:0] write_data;
input  clk;
input  [2:0]src_addr;   	//Source Address
input  [2:0] dst_addr;  	//Destination Address
input  [2:0] write_addr; //Write_back Address
output wire [15:0] read_data1; //Data1
wire [15:0] read_data2; //Data2
wire [15:0] src_mux_input; //Data2
input  [15:0] immediate;
input  category;
output wire [15:0] alu_input2;


RegFile file(write_back, read_data1, read_data2, write_data, clk, src_addr, dst_addr, write_addr);
assign src_mux_input = read_data2;
Mux2inputs mux (src_mux_input, immediate, category, alu_input2);

    
endmodule