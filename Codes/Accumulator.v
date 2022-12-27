module Accumulator (clk,flags,State_Machine_Out,in,Stack_PC,Stack_Flags,outPC); 
input clk; 
input [1:0] State_Machine_Out;
input  [15:0] in;
input Stack_PC,Stack_Flags; 
output [31:0] outPC; 
output reg [2:0]flags;
reg [31:0] tmp; 
 


  always @(posedge clk) 
    begin 
      if(State_Machine_Out==2'b11 )
      begin
        tmp[15:0] = in; 
      end
      else if(State_Machine_Out==2'b10)
      begin
        if({Stack_PC,Stack_Flags}==2'b11)
        begin
          tmp[31:16] = in;
        end
        else begin
          tmp[15:0] = in;
        end 
      end
      else if(State_Machine_Out==2'b01 )
      begin
        if({Stack_PC,Stack_Flags}==2'b11)
        begin
        tmp = tmp;
         flags=in[2:0];
        end
        else begin
          tmp[31:16] = in;
        end
      end
      else 
      begin
        tmp = tmp; 
      end
    end 
  assign outPC = tmp; 
endmodule