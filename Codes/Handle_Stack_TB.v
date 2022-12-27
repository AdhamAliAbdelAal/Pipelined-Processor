module Handle_Stack_TB ();

  localparam CLK=5;
  localparam DELAY=2*CLK;
  reg clk;

  wire [31:0] NewSP;
  reg IsStackOp,StackOp;
  wire [31:0] Stack_Pointer_Out;
  wire [31:0] spResult;

stackPointer sp(.in(NewSP), .clk(clk),.data(spResult));

Handle_Stack  HSP(
    .Stack_Pointer(spResult),.IsStackOp(IsStackOp),.StackOp(StackOp),.Stack_Pointer_Out(Stack_Pointer_Out),.NewSP(NewSP)
);

  initial begin
    $monitor("Stack_Pointer_Out = %b NewSP = %b IsStackOp = %b StackOp = %b spResult = %b ",
            Stack_Pointer_Out,NewSP,IsStackOp,StackOp,spResult);
    
    


    clk=0;
    #CLK;
    IsStackOp = 1'b1;
    StackOp = 1'b0;
    
    

  end

  always begin
        #CLK;
        clk=~clk;
    end
endmodule