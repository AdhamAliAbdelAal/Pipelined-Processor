module InterruptStateMachine(
    INT_IN,INT_OUT,Stall,reset,clk
);
    localparam state0=1'b0;
    localparam state1=1'b1;

    input INT_IN,Stall,reset,clk;
    output reg INT_OUT;
    reg state,next_state;

    always @(posedge clk) begin
        if(reset==1'b1)
        begin
            state<=state0;
        end
        else begin
            state<=next_state;
        end
    end
    always @(INT_IN,Stall,state) begin
        case (state)
            state0:
                if({INT_IN,Stall}==2'b10)
                begin
                    next_state<=state0;
                    INT_OUT<=1'b1;
                end
                else if ({INT_IN,Stall}==2'b11) begin
                    next_state<=state1;
                    INT_OUT<=1'b0;
                end
                else begin
                    next_state<=state0;
                    INT_OUT<=1'b0;
                end
            state1:
                if(Stall==1'b0)
                begin
                    next_state<=state0;
                    INT_OUT<=1'b1;
                end
                else begin
                    next_state<=state1;
                    INT_OUT<=1'b0;
                end
            default:
                next_state<=state0;
        endcase
    end
endmodule