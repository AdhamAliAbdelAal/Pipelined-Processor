`include "ID_EX.v"
`include "ExecutionUnit.v"
`include "EX_MEM.v"
`include "DecodingStage.v"
`include "DecodingStage.v"
`include "CU.v"
`include "MemoryUnit.v"
`include "MEM_WB.v"
`include "Program_Counter.v"
`include "Inst_Memory.v"

/*

ID/EX
Immediate|Rdst|WB|MW|MR|ALU|ALUOperation|Data1|Data2
--------------------------------------------
EX/MEM
Rdst|WB|MW|MR|Data|Address

*/


module Processor();
    localparam CLK=5;
    localparam DELAY=2*CLK;
    localparam MEMDELAY=5;

    wire [15:0] IF_ID_input;
    wire [15:0] IFIDBuffer;

    wire [40:0] ID_EX_input;
    wire [40:0] IDEXBuffer;

    wire [53:0] EX_MEM_input;
    wire [53:0] EXMEMBuffer;

    wire [19:0] MEM_WB_input;
    wire [19:0] MEMWBBuffer;

    reg clk;

    wire [31:0] PC_OUT;

    reg reset;
    reg [15:0] Instruction;
    reg [31:0] Write_Address;
    reg Write_Enable;
    
    /*PC*/
    Program_Counter PC(.reset(reset) ,.clk(clk), .PC_Out(PC_OUT));

    /*Instruction Memory*/
    Inst_Memory INSMEM(.PC_Address(PC_OUT),.OP_Code(Instruction),.Write_Address(Write_Address),.Write_Enable(Write_Enable),.Instruction(IF_ID_input));
    
    /*IF/ID Buffer*/
    IF_ID IFID (.DataIn(IF_ID_input), .Buffer(IFIDBuffer), .clk(clk));

    /*Control Unit*/
    CU CTRLUNIT (.In(IFIDBuffer[15:13]), .WB(ID_EX_input[36]), .Alu(ID_EX_input[33]), .MR(ID_EX_input[34]), .MW(ID_EX_input[35]), .AluOp(ID_EX_input[32]),.Imm(ID_EX_input[40]));

    /*Decoding Stage*/
    DecodingStage DECSTAGE (.write_back(MEMWBBuffer[19]), .read_data1(ID_EX_input[31:16]), .alu_input2(ID_EX_input[15:0]),  .write_data(MEMWBBuffer[15:0]), .clk(clk),
    .src_addr(IFIDBuffer[4:2]),.dst_addr(IFIDBuffer[7:5]),.write_addr(MEMWBBuffer[18:16]));

    /*ID/EX Buffer*/
    ID_EX IDEX(.DataIn(ID_EX_input), .Buffer(IDEXBuffer), .clk(clk));

    /*Execution Unit*/
    ExecutionUnit EXUNIT (.ALU(IDEXBuffer[33]), .ALUOperation(IDEXBuffer[32]), .Data1(IDEXBuffer[31:16]),
    .Data2((IDEXBuffer[40]==1'b0)?IDEXBuffer[15:0]:IFIDBuffer), .DataOut(EX_MEM_input[47:32]), .Address(EX_MEM_input[31:0]));

    /*EX/MEM Buffer*/
    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(EXMEMBuffer), .clk(clk));

    /*Memory Unit*/
    MemoryUnit MEMUNIT(.EX_MEM_input(EXMEMBuffer),.clk(clk),.MEM_Output(MEM_WB_input));
    
    /*MEM/WB Buffer*/
    MEM_WB MEMWB(.DataIn(MEM_WB_input), .Buffer(MEMWBBuffer), .clk(clk));

    assign EX_MEM_input[50:48] = IDEXBuffer[36:34];
    assign ID_EX_input[39:37]=IFIDBuffer[7:5];
    assign EX_MEM_input[53:51]=IDEXBuffer[39:37];

    initial begin
        $monitor("IFIDBuffer=%b,IDEXBuffer=%b,EXMEMBuffer=%b,MEMWBBuffer=%b",IFIDBuffer,IDEXBuffer,EXMEMBuffer,MEMWBBuffer);

        Write_Enable=1'b1;

        /*LDM R0,15*/
        Write_Address=32'd32;
        Instruction={8'b00101000,3'b000,3'b000,2'b00};
        #MEMDELAY
        Write_Address=Write_Address+1;
        Instruction=16'd15;
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b000,3'b000,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b000,3'b000,2'b00};
        #MEMDELAY

        /*LDM R7,13*/
        Write_Address=Write_Address+1;
        Instruction={8'b00101000,3'b111,3'b000,2'b00};
        #MEMDELAY
        Write_Address=Write_Address+1;
        Instruction=16'd13;
        #MEMDELAY
        
        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b111,3'b111,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b111,3'b111,2'b00};
        #MEMDELAY

        /*ADD R7,R0*/
        Write_Address=Write_Address+1;
        Instruction={8'b01101000,3'b111,3'b000,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b000,3'b000,2'b00};
        #MEMDELAY

        /*LDM R1,0*/
        Write_Address=Write_Address+1;
        Instruction={8'b00101000,3'b001,3'b000,2'b00};
        #MEMDELAY
        Write_Address=Write_Address+1;
        Instruction=16'd0;
        #MEMDELAY

        /*NOT R7*/
        Write_Address=Write_Address+1;
        Instruction={8'b10001000,3'b111,3'b111,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b000,3'b000,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b001,3'b001,2'b00};
        #MEMDELAY

        /*STD R1,R7*/
        Write_Address=Write_Address+1;
        Instruction={8'b01001000,3'b001,3'b111,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b111,3'b001,2'b00};
        #MEMDELAY



        Write_Enable=1'b0;

        reset=1'b1;
        clk=0;
        #DELAY;
        reset=1'b0;
    end

    always begin
        #CLK;
        clk=~clk;
    end


endmodule