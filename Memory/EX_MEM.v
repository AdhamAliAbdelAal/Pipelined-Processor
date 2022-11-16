// data[31:0] , 3 bit dist, 1 bit MR , 1 bit MW, 1 bit WB, Address[31:0] ,1 bit jwsp
module EX_MEM(
    DataIn, Buffer, clk
);
    input [70:0] DataIn;
    input clk;
    output reg [70:0] Buffer;
    always @(posedge clk) begin
        Buffer = DataIn;
    end
endmodule