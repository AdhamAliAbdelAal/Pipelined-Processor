// Rdst|WB|MW|MR|Data|Address
module EX_MEM(
    DataIn, Buffer, clk, reset
);
    input [75:0] DataIn;
    input clk,reset;
    output reg [75:0] Buffer;
    always @(posedge clk) begin
        if(reset==1'b1)
            Buffer=76'b0;
        else
            Buffer = DataIn;
    end
endmodule