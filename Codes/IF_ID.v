// WB|MW|MR|ALU|ALUOperation|Data1|Data2
module IF_ID(
    DataIn, Buffer, clk
);
    input [15:0] DataIn;
    input clk;
    output reg [15:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule