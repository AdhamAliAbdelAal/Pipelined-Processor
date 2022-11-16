// WB|MW|MR|ALU|ALUOperation|Data1|Data2
module ID_EX(
    DataIn, Buffer, clk
);
    input [36:0] DataIn;
    input clk;
    output reg [36:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule