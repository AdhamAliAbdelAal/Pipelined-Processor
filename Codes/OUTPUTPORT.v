module OUTPUTPORT(
    DataIn, Buffer, clk
);
    input [15:0] DataIn;
    input clk;
    output reg [15:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule