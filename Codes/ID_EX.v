// Immediate|Rdst|WB|MW|MR|ALU|ALUOperation|Data1|Data2
module ID_EX(
    DataIn, Buffer, clk
);
    input [40:0] DataIn;
    input clk;
    output reg [40:0] Buffer;
    always @(posedge clk) begin
        if(Buffer[40]==1'b1) begin
            Buffer<=41'd0;
        end
        else begin
            Buffer<=DataIn;
        end
    end
endmodule