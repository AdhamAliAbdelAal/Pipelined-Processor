module OUTPUTPORT(
    DataIn, Buffer, clk, reset
);
    input [15:0] DataIn;
    input clk,reset;
    output reg [15:0] Buffer;
    always @(posedge clk) begin
        if(reset==1'b1)
            Buffer=16'b0;
        else
            Buffer = DataIn;
    end
endmodule