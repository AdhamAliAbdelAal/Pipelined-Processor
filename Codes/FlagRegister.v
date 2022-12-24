/*NF|CF|ZF*/
module FlagRegister(
    DataIn, Buffer, clk, reset
);
    input [2:0] DataIn;
    input clk,reset;
    output reg [2:0] Buffer;
    always @(posedge clk) begin
        Buffer<=(reset==1'b0)?DataIn:3'd0;
    end
endmodule