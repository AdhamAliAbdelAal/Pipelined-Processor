
module TB_Inst_Meemory();
    localparam CLK=5;
    localparam DELAY=2*CLK;
  reg clk;
  reg rst;
 reg [31:0]PC_Address,Write_Address,Intial_PC;
 reg [31:0]OP_Code;
wire [31:0]Instruction;
wire [31:0]PC_Address2;
 reg Write_Enable;
Inst_Meemory InstMeemory(.PC_Address(PC_Address),.OP_Code(OP_Code),.Write_Address(Write_Address),
.Write_Enable(Write_Enable),.Instruction(Instruction));
Program_Couter PC ( rst,clk, PC_Address2);
//Inc_PC IncPC(clk,PC_Address2);
/*always  begin 
	#DELAY
	Intial_PC = PC_Address2 +2;
end*/
  initial begin
        $monitor("PC_Address = %b",PC_Address2);
rst = 1;
#1
	clk=0;

        Write_Enable=1'b1;

	#DELAY
	rst=0;
	Intial_PC={{26{1'b0}},6'b10_0000};

	#DELAY
	Write_Address=32'b11111111010101010100010101010101;
	OP_Code=32'b01011101010001010111010111011111;

	#DELAY
	Write_Address=32'b11111100010101010111010101010101;
	OP_Code=32'b01011101010001010111010111011100;
	#DELAY
	Write_Address=32'b11111111010101010100010101110111;
	OP_Code=32'b01011101010001010111010111010000;
	#DELAY
	Write_Enable=1'b0;
	PC_Address=32'b11111111010101010100010101010101;
	#DELAY
	if(Instruction===32'b01011101010001010111010111011111)
	begin
 		$display("sucess %b",Instruction);
	end
	else
	begin
		 $display("failed %b",Instruction);
	end
	
	PC_Address=32'b11111100010101010111010101010101;
	#DELAY
	if(Instruction===32'b01011101010001010111010111011100)
			     //01011101110001010100010111011111
	begin
 		$display("sucess %b",Instruction);
	end
	else
	begin
		  $display("failed %b",Instruction);
	end

	PC_Address=32'b11111111010101010100010101110111;
	#DELAY
	if(Instruction===32'b01011101010001010111010111010000)
			 
	begin
 		$display("sucess %b",Instruction);
	end
	else
	begin
		 $display("failed %b",Instruction);
	end


    end
 always begin
        #CLK
        clk=~clk;
    end



endmodule

