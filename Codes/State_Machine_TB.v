module State_Machine_TB ();

    localparam CLK=5;
	localparam DELAY=2*CLK;
	reg clk;

    reg Stack_PC,Stack_Flags,MR,MW;
    wire [1:0] State_Machine_Out,Machine_Stack;
    wire Stall_Signal;

State_Machine stateMachine(.clk(clk),.Stack_PC(Stack_PC),.Stack_Flags(Stack_Flags),
                            .MR(MR),.MW(MW),.State_Machine_Out(State_Machine_Out),
                            .Machine_Stack(Machine_Stack),.Stall_Signal(Stall_Signal)); 


    initial begin
        $monitor("Stack_PC = %b Stack_Flags = %b MR = %b MW = %b stateMachine = %b  MachineStack = %b  stallSiganl = %b",
                Stack_PC,Stack_Flags,MR,MW,State_Machine_Out,Machine_Stack,Stall_Signal);
        clk=0;
        Stack_PC=1;
        Stack_Flags=1;
        MR=1;
        MW=0;
        #DELAY;
        #DELAY;
        #DELAY;
        #DELAY;
        $display("---------------------------------------------------------");
        Stack_PC=1;
        Stack_Flags=0;
        MR=0;
        MW=1;
        #DELAY;
        #DELAY;
        #DELAY;
        $display("---------------------------------------------------------");
        Stack_PC=0;
        Stack_Flags=0;
        MR=0;
        MW=0;
        #DELAY;
        #DELAY;
        #DELAY;
        $display("---------------------------------------------------------");
        Stack_PC=0;
        Stack_Flags=1;
        MR=1;
        MW=0;
        #DELAY;
        #DELAY;
        #DELAY;
        $display("---------------------------------------------------------");

    end
    
    always begin
        #CLK;
        clk=~clk;
    end
    
endmodule