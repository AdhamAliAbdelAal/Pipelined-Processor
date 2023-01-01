module InterruptStateMachine_TB(
);
    localparam CLK=5;
    localparam DELAY=2*CLK;
    reg Stall,INT,clk,reset;
    wire INT_OUT;
    InterruptStateMachine INT_Machine (
    .INT_IN(INT),.INT_OUT(INT_OUT),.Stall(Stall),.reset(reset),.clk(clk)
    );
    initial 
    begin
        clk=0;
        reset=1'b1;
        #DELAY;
        reset=1'b0;
        
        Stall=1'b1;
        INT=1'b1;
        #DELAY;

        Stall=1'b1;
        INT=1'b0;
        #DELAY;
        #DELAY;

        Stall=1'b0;
        INT=1'b0;
        #DELAY;

        Stall=1'b1;
        INT=1'b0;
        #DELAY;

        Stall=1'b0;
        INT=1'b0;
        #DELAY;

        Stall=1'b0;
        INT=1'b1;
        #DELAY;

        Stall=1'b0;
        INT=1'b0;
        #DELAY;
    end
    always begin
        #CLK;
        clk=~clk;
    end
endmodule