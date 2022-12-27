module stackPointer #(parameter N=32) (in, clk, data);
  input  clk; 
  input  [N-1:0] in;
  output reg [N-1:0] data;

  initial begin
    data <= 2047;
  end

  always @ (posedge clk) begin
        data <= in;
  end


endmodule