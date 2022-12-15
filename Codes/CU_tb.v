module CU_tb();
	localparam CLK=5;
	localparam DELAY=2*CLK;
	reg clk;
	
	// inputs
	reg [7:0] Opcode;
	reg INT;

	// outputs
	wire WB, ALU,Imm,Selector,MR,MW,Jmp,IOR,IOW,Stack_PC,Stack_Flags,
		 IsCarryOp,CarryOp,IsStackOp,StackOp,JWSP,Call;
	wire [1:0] Flag_Selector,Data_To_Use;
	wire [2:0] ALU_Ops;

	// instance module
	CU cu(.Opcode(Opcode),.INT(INT),.WB(WB),.ALU(ALU),.Imm(Imm),.Selector(Selector),.MR(MR),.MW(MW),
		.Jmp(Jmp),.IOR(IOR),.IOW(IOW),.Stack_PC(Stack_PC),.Stack_Flags(Stack_Flags),.IsCarryOp(IsCarryOp),.CarryOp(CarryOp),
		.IsStackOp(IsStackOp),.StackOp(StackOp),.JWSP(JWSP),.Call(Call),.Flag_Selector(Flag_Selector),.ALU_Ops(ALU_Ops),.Data_To_Use(Data_To_Use)
		);
	initial begin
		$monitor("****************************************************************
	Opcode = %b, INT = %b  
	WB = %b ALU = %b  Imm = %b   Selector = %b MR = %b  MW = %b   Jmp = %b
	IOR = %b  IOW = %b   Stack_PC = %b Stack_Flags = %b  IsCarryOp = %b   CarryOp = %b
	IsStackOp = %b  StackOp = %b   JWSP = %b Call = %b  Flag_Selector = %b   ALU_Ops = %b  Data_To_Use=%b
****************************************************************",
		Opcode,INT,WB,ALU,Imm,Selector,MR,MW,
		Jmp,IOR,IOW,Stack_PC,Stack_Flags,IsCarryOp,CarryOp,
		IsStackOp,StackOp,JWSP,Call,Flag_Selector,ALU_Ops,Data_To_Use);
		clk=0;
		

		// LDD
		#DELAY
		$display("		LDD");
		Opcode=8'b00_001_000;
		INT=1'b0;

		// STD
		#DELAY
		$display("		STD");
		Opcode=8'b00_010_000;
		INT=1'b0;

		// MOV
		#DELAY
		$display("		MOV");
		Opcode=8'b00_100_000;
		INT=1'b0;

		// ADD
		#DELAY
		$display("		ADD");
		Opcode=8'b00_000_000;
		INT=1'b0;

		// SUB
		#DELAY
		$display("		SUB");
		Opcode=8'b00_000_001;
		INT=1'b0;

		// AND
		#DELAY
		$display("		AND");
		Opcode=8'b00_000_010;
		INT=1'b0;

		// LDM
		#DELAY
		$display("		LDM");
		Opcode=8'b01_100_000;
		INT=1'b0;

		// SHL
		#DELAY
		$display("		SHL");
		Opcode=8'b01_000_100;
		INT=1'b0;

		// SHR
		#DELAY
		$display("		SHR");
		Opcode=8'b01_000_101;
		INT=1'b0;

		// JZ
		#DELAY
		$display("		JZ");
		Opcode=8'b10_011_000;
		INT=1'b0;
		
		// JN
		#DELAY
		$display("		JN");
		Opcode=8'b10_011_001;
		INT=1'b0;
		
		// JC
		#DELAY
		$display("		JC");
		Opcode=8'b10_011_010;
		INT=1'b0;

		// JMP
		#DELAY
		$display("		JMP");
		Opcode=8'b10_011_011;
		INT=1'b0;

		// CALL
		#DELAY
		$display("		CALL");
		Opcode=8'b10_110_000;
		INT=1'b0;

		// INC
		#DELAY
		$display("		INC");
		Opcode=8'b10_000_000;
		INT=1'b0;

		// DEC
		#DELAY
		$display("		DEC");
		Opcode=8'b10_000_001;
		INT=1'b0;

		// POP
		#DELAY
		$display("		POP");
		Opcode=8'b10_111_001;
		INT=1'b0;

		// PUSH
		#DELAY
		$display("		PUSH");
		Opcode=8'b10_111_000;
		INT=1'b0;

		// IN
		#DELAY
		$display("		IN");
		Opcode=8'b10_101_000;
		INT=1'b0;

		// OUT
		#DELAY
		$display("		OUT");
		Opcode=8'b10_101_001;
		INT=1'b0;

		// NOT
		#DELAY
		$display("		NOT");
		Opcode=8'b10_000_111;
		INT=1'b0;

		// NOP
		#DELAY
		$display("		NOP");
		Opcode=8'b11_100_010;
		INT=1'b0;

		// SETC
		#DELAY
		$display("		SETC");
		Opcode=8'b11_100_001;
		INT=1'b0;

		// CLRC
		#DELAY
		$display("		CLRC");
		Opcode=8'b11_100_000;
		INT=1'b0;

		// RET
		#DELAY
		$display("		RET");
		Opcode=8'b11_110_000;
		INT=1'b0;

		// RTI
		#DELAY
		$display("		RTI");
		Opcode=8'b11_110_001;
		INT=1'b0;
		
		// INT
		#DELAY
		$display("		INT");
		Opcode=8'b00_000_000;
		INT=1'b1;
	end



  always begin
        #CLK;
        clk=~clk;

    end


endmodule
