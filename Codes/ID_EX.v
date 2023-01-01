/*ID/EX Buffer 91 bit*/
/*
1: IOR                                |  0 
1: IOW                                |  1
1: OPS                                |  2
3: ALU_OP                             |  5:3
1: ALU                                |  6
2: FD                                 |  8:7
16: Data1                             |  24:9
16: Data2                             |  40:25
3: WB_Address                         |  43:41
1: MR                                 |  44
1: MW                                 |  45
1: WB                                 |  46
1: JMP                                |  47
1: SP                                 |  48
1: SPOP                               |  49
2: FGS                                |  51:50
32: PC                                |  83:52
1: JWSP                               |  84
3: SRC_Address                        |  87:85
1: IMM                                |  88
1: Stack_PC                           |  89
1: Stack_Flags                        |  90
1: INT                                |  91
*/

module ID_EX(
    DataIn, Buffer, clk, reset, flush,stall
);
    input [91:0] DataIn;
    input clk,reset,flush,stall;
    output reg [91:0] Buffer;
    always @(posedge clk) begin
        if(reset==1'b1||flush==1'b1)
            Buffer=92'b0;
        else if (stall===1'b0)
            Buffer = DataIn;
    end
endmodule