// Immediate|Rdst|WB|MW|MR|ALU|ALUOperation|Data1|Data2
module ID_EX(
    DataIn, Buffer, clk
);
    input [40:0] DataIn;
    input clk;
    output reg [40:0] Buffer;
    always @(posedge clk) begin
        //Buffer = (Buffer[40]==1'b1) ? 41'd0 : DataIn;
        Buffer = DataIn;
    end
endmodule