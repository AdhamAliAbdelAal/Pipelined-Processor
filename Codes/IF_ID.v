// WB|MW|MR|ALU|ALUOperation|Data1|Data2
module IF_ID(
    DataIn, Buffer, clk, reset
);
    input [47:0] DataIn;
    input clk,reset;
    output reg [47:0] Buffer;
    always @(posedge clk) begin
        if(reset==1'b1)
            Buffer=48'b0;
        else
            Buffer = DataIn;
    end
endmodule