module ForwardingUnit (
    Dst_ID_EX,
    Src_ID_EX,
    Dst_EX_MEM,
    WB_EX_MEM,
    Data_EX_MEM,
    Dst_MEM_WB,
    WB_MEM_WB,
    Data_MEM_WB,
    Data_Dst,
    Data_Src,
    Selectors
);
    input [15:0] Data_EX_MEM,Data_MEM_WB;
    input [2:0] Dst_ID_EX,Src_ID_EX,Dst_EX_MEM,Dst_MEM_WB;
    input WB_EX_MEM,WB_MEM_WB;

    output [15:0] Data_Dst,Data_Src;
    output [1:0] Selectors;
    

    assign Selectors[0]= (Dst_ID_EX==Dst_EX_MEM&&WB_EX_MEM==1'b1)||(Dst_ID_EX==Dst_MEM_WB&&WB_MEM_WB==1'b1);
    assign Selectors[1]= (Src_ID_EX==Dst_EX_MEM&&WB_EX_MEM==1'b1)||(Src_ID_EX==Dst_MEM_WB&&WB_MEM_WB==1'b1);

    assign Data_Dst= (Dst_ID_EX==Dst_MEM_WB&&WB_MEM_WB==1'b1)?Data_MEM_WB:Data_EX_MEM;

    assign Data_Src= (Src_ID_EX==Dst_MEM_WB&&WB_MEM_WB==1'b1)?Data_MEM_WB:Data_EX_MEM;


endmodule