module Mux2inputs(in0,in1,sel,out);
input [15:0] in0;
input [15:0] in1;
input [1:0] sel;
output [15:0] out;

assign out = 
sel==00?in0:in1;
endmodule
