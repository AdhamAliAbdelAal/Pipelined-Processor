`include "Mux_WB.v"
`include "MEM_WB.v"
`include "Memory.v"
module MemoryUnit(EX_MEM_input,clk,MEM_Output);
    input [69:0]  EX_MEM_input;
    output [19:0] MEM_Output;

    wire [31:0] MR_Data;
    input clk;

    Memory MEM (.Address(EX_MEM_input[31:0]),.Write_Data(EX_MEM_input[63:32]),.Read_Data(MR_Data),.MW(EX_MEM_input[65])
 	,.MR(EX_MEM_input[64]),.clk(clk));

    Mux_WB Mux(.Read_Data(MR_Data[15:0]),.data(EX_MEM_input[47:32]),.Out(MEM_Output[15:0]),.MR(EX_MEM_input[64]));

    assign MEM_Output[18:16] = EX_MEM_input[69:67];
    assign MEM_Output[19] = EX_MEM_input[66];
endmodule