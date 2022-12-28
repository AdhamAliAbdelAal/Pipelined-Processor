// WB|MW|MR|ALU|ALUOperation|Data1|Data2
module IF_ID(
    DataIn, Buffer, clk, reset, stall,flush
);
    input [47:0] DataIn;
    input clk,reset, stall,flush;
    output reg [47:0] Buffer;
    always @(posedge clk) begin
        if (flush==1'b1) begin
            Buffer={32'd0,8'b11_100_010,8'd0};
        end
        else if(reset==1'b1)
            Buffer={32'd0,8'b11_100_010,8'd0};
        else if (stall===1'b0)
            Buffer = DataIn;
    end
endmodule