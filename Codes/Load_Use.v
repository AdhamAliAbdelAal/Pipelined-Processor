/*MR|SP*/
module Load_Use_Case(
    MR,EXEC_Dst, DEC_Src1, DEC_Src2, Load_Use
);
    input MR;
    input [2:0] EXEC_Dst, DEC_Src;
    output Load_Use;

    assign Load_Use = (MR==1'b1 && (EXEC_Dst===DEC_Src1 || EXEC_Dst===DEC_Src2))? 1'b1: 1'b0;

endmodule