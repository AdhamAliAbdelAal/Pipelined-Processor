module StackPointer(
    DataIn, Buffer, clk, reset
);
    input [31:0] DataIn;
    input clk,reset;
    output reg [31:0] Buffer;
    always @(posedge clk) begin
        Buffer<=(reset==1'b0)?DataIn:32'd0;
    end
endmodule