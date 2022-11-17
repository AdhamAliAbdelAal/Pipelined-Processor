// WB|MW|MR|ALU|ALUOperation|Data1|Data2
module IF_ID(
    DataIn, Buffer, clk
);
    input [31:0] DataIn;
    input clk;
    output reg [31:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule