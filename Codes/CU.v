module CU (Opcode,INT, WB, ALU, ALU_Ops, Imm, Selector, MR, MW, Jmp, Flag_Selector,
		FD, IOR, IOW, IsStackOp, StackOp,
		Stack_PC, Stack_Flags, JWSP);

//Input is opcode, INT
input [7:0] Opcode;
input INT;

output WB, ALU,Imm,Selector,MR,MW,Jmp,IOR,IOW,Stack_PC,Stack_Flags,IsStackOp,StackOp,JWSP;
output [1:0] Flag_Selector;
output [2:0] ALU_Ops;
output [1:0] FD ; 

wire Call;
wire IsCarryOp,CarryOp;
wire Load;
wire Store;
wire Mov;

assign ALU = (!Opcode[5] && !Opcode[4] && !Opcode[3]) && !INT; 

assign ALU_Ops = {Opcode[2],Opcode[1],Opcode[0]};

assign Imm = (!Opcode[7] && Opcode[6]) && !INT;

assign Selector = ALU && Opcode[7] && !Opcode[6];

assign Load = !Opcode[5] && !Opcode[4] && Opcode[3]; 

assign Store = !Opcode[5] && Opcode[4] && !Opcode[3]; 

assign Call = Opcode[7] && !Opcode[6] && Opcode[5] 
	   && Opcode[4] && !Opcode[3] ;

assign Mov = !Opcode[7] && !Opcode[6] && Opcode[5] 
	   && !Opcode[4] && !Opcode[3] ;

assign Jmp = ( !Opcode[5] && Opcode[4] && Opcode[3] || Call ) && !INT;

assign Flag_Selector = {Opcode[1]|| Call, Opcode[0] || Call};

assign IOR = ( Opcode[5] && !Opcode[4] && Opcode[3] && !Opcode[0] ) && !INT ;

assign IOW = ( Opcode[5] && !Opcode[4] && Opcode[3] && Opcode[0] ) && !INT ;

assign IsCarryOp = ( Opcode[7] && Opcode[6] && Opcode[5] 
	        && !Opcode[4] && !Opcode[3] && !Opcode[2] && !Opcode[1] ) && !INT;

assign CarryOp = Opcode[0];



assign JWSP = ( Opcode[7] && Opcode[6] && Opcode[5] 
	   && Opcode[4] && !Opcode[3] ) && !INT ;

assign IsStackOp = ( (Opcode[5] && Opcode[4] && Opcode[3]) || JWSP ) || INT;

//1-> pop , 0->push
assign StackOp = ( Opcode[0] || JWSP ) && !INT ;

assign Stack_PC = ( JWSP || Call ) || INT;

assign Stack_Flags = ( (JWSP && Opcode[0]) ) || INT;

assign WB = ( Load || ALU || IOR || (IsStackOp&&StackOp) || Imm || Mov) && !INT ;

assign MR = ( Load || (IsStackOp&&StackOp) || JWSP ) && !INT;

assign MW = ( Store || Call || (IsStackOp&&!StackOp) ) || INT;

assign FD = ({IsCarryOp,CarryOp}==2'b10)?2'b00:
			({IsCarryOp,CarryOp}==2'b11)?2'b01:
			(ALU)?2'b11:2'b10;

endmodule
