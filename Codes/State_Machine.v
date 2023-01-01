module State_Machine (
    clk,Stack_PC,Stack_Flags,MR,MW,State_Machine_Out,Machine_Stack,Stall_Signal
);
    input Stack_PC,Stack_Flags,MR,MW,clk;
    output reg [1:0] State_Machine_Out,Machine_Stack;
    output reg Stall_Signal;
    reg [1:0] State_Next,State_Reg;
    
    initial begin
        State_Reg=2'b00;
        State_Next=2'b00;
        Machine_Stack = 2'b00;
        Stall_Signal=1'b0;
    end

    // assign {Stack_PC,Stack_Flags} = (State_Machine_Out===2'b01 )?2'b00:{Stack_PC,Stack_Flags};
    

    always @(negedge clk) begin
        if(State_Reg==2'b00 && Stack_PC==1'b1 && Stack_Flags==1'b1)
        begin
            State_Reg=2'b11;
            Stall_Signal=1'b1;
        end
        else if(State_Reg==2'b00 && Stack_PC==1'b1 && Stack_Flags==1'b0)
        begin
            State_Reg=2'b10;
            Stall_Signal=1'b1;
        end
        else
        begin
            State_Reg=State_Next;
        end
    end

    always @(State_Reg) begin
        if(State_Reg== 2'b11)
        begin
            State_Next=2'b10;
            State_Machine_Out= 2'b11;
            if(MR)
                Machine_Stack=2'b11;
            else if(MW)
                Machine_Stack=2'b10;
            else
                Machine_Stack=2'b00;
        end
        else if(State_Reg== 2'b10)
        begin
            State_Next=2'b01;
            State_Machine_Out= 2'b10;
             if(MR)
                Machine_Stack=2'b11;
            else if(MW)
                Machine_Stack=2'b10;
            else
                Machine_Stack=2'b00;
        end
        else if(State_Reg== 2'b01)
        begin
          
            State_Next=2'b00;
            State_Machine_Out= 2'b01;
              if(MR)
                Machine_Stack=2'b11;
            else if(MW)
                Machine_Stack=2'b10;
            else
                Machine_Stack=2'b00;
        end
        else
        begin
            Stall_Signal=1'b0;
             State_Machine_Out= 2'b00;
             Machine_Stack=2'b00;
             State_Next = 2'b00;
        end
    end

endmodule
