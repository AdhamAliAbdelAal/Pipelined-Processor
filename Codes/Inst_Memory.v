module Inst_Memory(PC_Address,OP_Code,Write_Address,Write_Enable,Instruction,reset);

input [31:0]PC_Address,Write_Address;
input [15:0]OP_Code;
output [15:0]Instruction;
input Write_Enable,reset;
reg [15:0]Instruction_memory[0:1048575];
integer i;

assign Instruction=Instruction_memory[PC_Address[19:0]];

always @(*)
begin
  if(reset==1'b1)
  begin
    for (i=0; i<1048576; i=i+1) begin
	  Instruction_memory[i]={8'b11_100_010,8'd0};
  end
  end
  else
  begin
    Instruction_memory[Write_Address[19:0]]=(Write_Enable===1'b1)?
    OP_Code[15:0]:Instruction_memory[Write_Address[19:0]];
  end

end


endmodule
