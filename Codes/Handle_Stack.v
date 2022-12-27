module Handle_Stack (
    Stack_Pointer,IsStackOp,StackOp,Stack_Pointer_Out,NewSP
);
    input [31:0] Stack_Pointer;
    input IsStackOp,StackOp;
    output [31:0]Stack_Pointer_Out;
    output [31:0]NewSP ;
    
    assign Stack_Pointer_Out=(IsStackOp==1'b0)?Stack_Pointer:(StackOp==1'b1)?Stack_Pointer+32'd1:Stack_Pointer;
    assign NewSP=(IsStackOp==1'b0)?Stack_Pointer:(StackOp==1'b1)?Stack_Pointer+32'd1:Stack_Pointer-32'd1;
    
endmodule