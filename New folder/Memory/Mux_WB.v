module Mux_WB( Read_Data, MR,data, Out);

input [15:0] Read_Data,data;
input MR;
output  [15:0] Out;

assign Out=(MR===1'b1)?Read_Data:data;

endmodule

