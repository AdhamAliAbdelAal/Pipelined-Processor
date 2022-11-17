// data[15:0] , 3 bit dist, 1 bit WB, 
module MEM_WB(
    DataIn, Buffer, clk
);
    input [19:0] DataIn;
    input clk;
    output reg [19:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule