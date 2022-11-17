

`include "Immediate or rSrc.v"

module Imm_Src_tb();

reg [15:0] immediate;
reg write_back;       
reg [15:0] write_data;
reg clk;
reg [2:0]src_addr;   	//Source Address
reg [2:0] dst_addr;  	//Destination Address
reg [2:0] write_addr; //Write_back Address
wire [15:0] read_data1; //Data1
wire [15:0] read_data2;  //After Choosing between Src, and Immediate Value
reg [1:0] category;     //Category for Choosing Src, Immediate Value


Immediate_Or_Src test(immediate, write_back, read_data1, read_data2, write_data, clk, src_addr, dst_addr, write_addr, category);

initial
begin
 clk = 1;
write_back = 1; write_data = 16'b1110; src_addr = 011; dst_addr = 100; write_addr = 100; category=10; immediate = 16'b1001;
#198
if(read_data2==16'b1001 && read_data1 === 16'b1110)
 $display("Test#1 SUCCESS with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);
else
 $display("Test#1 Failure with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);

write_back = 1; write_data = 16'b1111; src_addr = 011; dst_addr = 100; write_addr = 011; category=00; immediate = 16'b1011;
#198
if(read_data2==16'b1111 && read_data1 === 16'b1110)
 $display("Test#2 SUCCESS with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);
else
 $display("Test#2 Failure with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);

write_back = 0; write_data = 16'b1110; src_addr = 011; dst_addr = 100; write_addr = 100; category=10; immediate = 16'b0001;
#198
if(read_data2==16'b0001 && read_data1 === 16'b1110)
 $display("Test#3 SUCCESS with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);
else
 $display("Test#3 Failure with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);

write_back = 1; write_data = 16'b1110; src_addr = 011; dst_addr = 100; write_addr = 100; category=00; immediate = 16'b1111;
#198
if(read_data2==16'b1111 && read_data1 === 16'b1110)
 $display("Test#4 SUCCESS with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);
else
 $display("Test#4 Failure with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);

write_back = 0; write_data = 16'b1110; src_addr = 011; dst_addr = 100; write_addr = 011; category=10; immediate = 16'b1011;
#198
if(read_data2==16'b1011 && read_data1 === 16'b1110)
 $display("Test#5 SUCCESS with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);
else
 $display("Test#5 Failure with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);

write_back = 1; write_data = 16'b0001; src_addr = 010; dst_addr = 100; write_addr = 010; category=00; immediate = 16'b1011;
#198
if(read_data2==16'b0001 && read_data1 === 16'b1110)
 $display("Test#6 SUCCESS with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);
else
 $display("Test#6 Failure with Src = %b, Dst = %b and write_data =  %b",read_data2,read_data1,write_data);




end

always #100 clk = !clk;

endmodule