module Inst_Memory(PC_Address,OP_Code,Write_Address,Write_Enable,Instruction);

input [31:0]PC_Address,Write_Address;
input [15:0]OP_Code;
output [15:0]Instruction;
input Write_Enable;
reg [15:0]Instruction_memory[0:1048575];


assign Instruction=Instruction_memory[PC_Address[19:0]];

always @(*)
begin
Instruction_memory[Write_Address[19:0]]=(Write_Enable===1'b1)?
OP_Code[15:0]:Instruction_memory[Write_Address[19:0]];
end


endmodule
