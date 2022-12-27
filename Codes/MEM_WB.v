// data[15:0] , 3 bit dist, 1 bit WB, 
module MEM_WB(
    DataIn, Buffer, clk, reset, flush
);
    input [19:0] DataIn;
    input clk, reset, flush;
    output reg [19:0] Buffer;
    always @(posedge clk) begin
        if(reset==1'b1||flush==1'b1)
            Buffer=20'b0;
        else
            Buffer = DataIn;
    end
endmodule