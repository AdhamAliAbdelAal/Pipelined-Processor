// Rdst|WB|MW|MR|Data|Address
module EX_MEM(
    DataIn, Buffer, clk, reset, flush,stall
);
    input [77:0] DataIn;
    input clk,reset, flush,stall;
    output reg [77:0] Buffer;
    always @(posedge clk) begin
        if(reset===1'b1 || flush===1'b1)
            Buffer=76'b0;
        else if (stall===1'b0)
            Buffer = DataIn;
    end
endmodule