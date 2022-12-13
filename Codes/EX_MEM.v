// Rdst|WB|MW|MR|Data|Address
module EX_MEM(
    DataIn, Buffer, clk
);
    input [75:0] DataIn;
    input clk;
    output reg [75:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule