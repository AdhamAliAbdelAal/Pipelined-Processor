/*MR|EXEC_Dst|DEC_Src1|DEC_Src2*/
module Load_Use_Case(
    MR,EXEC_Dst, DEC_Src1, DEC_Src2, Keep_Fetched_Instruction, Keep_PC, Flush_MUX_Selector , JWSP
);
    input MR,JWSP;
    input [2:0] EXEC_Dst, DEC_Src1, DEC_Src2;
    output Keep_Fetched_Instruction, Keep_PC, Flush_MUX_Selector;

    assign {Flush_MUX_Selector, Keep_PC, Keep_Fetched_Instruction} = 
        ((MR==1'b1&&!JWSP) && (EXEC_Dst===DEC_Src1 || EXEC_Dst===DEC_Src2))? 3'd7: 3'd0;

endmodule