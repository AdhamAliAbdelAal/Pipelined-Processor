// WB|MW|MR|ALU|ALUOperation|Data1|Data2
module IF_ID(
    DataIn, Buffer, clk, reset, stall
);
    input [47:0] DataIn;
    input clk,reset, stall;
    output reg [47:0] Buffer;
    always @(posedge clk) begin
        if(reset==1'b1)
            Buffer=48'b0;
        else if (stall===1'b0)
            Buffer = DataIn;
    end
endmodule