`include "ID_EX.v"
`include "ExecutionUnit.v"
`include "EX_MEM.v"
`include "FlagRegister.v"
`include "OUTPUTPORT.v"
`include "StackPointer.v"
`include "ForwardingUnit.v"
`include "Program_Counter.v"
`include "CU.v"
`include "Inst_Memory.v"
`include "DecodingStage.v"
`include "IF_ID.v"
/*ID/EX Buffer 91 bit*/
/*
1: IOR                                |  0 
1: IOW                                |  1
1: OPS                                |  2
3: ALU_OP                             |  5:3
1: ALU                                |  6
2: FD                                 |  8:7
16: Data1                             |  24:9
16: Data2                             |  40:25
3: WB_Address                         |  43:41
1: MR                                 |  44
1: MW                                 |  45
1: WB                                 |  46
1: JMP                                |  47
1: SP                                 |  48
1: SPOP                               |  49
2: FGS                                |  51:50
32: PC                                |  83:52
1: JWSP                               |  84
3: SRC_Address                        |  87:85
1: IMM                                |  88
1: Stack_PC                           |  89
1: Stack_Flags                        |  90
*/

/*EX/MEM Buffer 76*/
/*
32: Data                    | 31:0
3: WB_Address_Out           | 34:32         
1: MR_Out                   | 35
1: MW_Out                   | 36
1: WB_Out                   | 37
32: Address                 | 69:38
1: JWSP_Out                 | 70
1: Stack_PC_Out             | 71
1: Stack_Flags_Out          | 72
3: Final_Flags              | 75:73
*/

module Processor();
    localparam CLK=5;
    localparam DELAY=2*CLK;
    localparam MEMDELAY=5;

    wire [47:0] IF_ID_input;
    wire [47:0] IFIDBuffer;

    wire [40:0] ID_EX_input;
    wire [40:0] IDEXBuffer;

    wire [75:0] EX_MEM_input;
    wire [75:0] EXMEMBuffer;

    reg [15:0] Instruction;
    reg [31:0] Write_Address;
    reg Write_Enable;

    wire [15:0] OUTPUT_PORT_Output,OUTPUT_PORT_Register;

    reg clk;
    reg reset;
    reg [15:0] IF_Buffer;
    reg [2:0]Flags_From_Memory;
    reg [15:0] INPUT_PORT;
    wire [31:0] Stack_Pointer;
    wire [1:0] Selectors_Forwarding_Unit;
    wire [15:0] Forwarding_Unit_Data1, Forwarding_Unit_Data2;
    wire [2:0] Flags;
    wire [31:0] Stack_Pointer_Out;
    wire JMP,To_PC_Selector;

    reg WB_MEM_WB;
    reg initial_reset;

    wire [31:0] PC_OUT;
    reg [15:0] Instruction;
    reg [31:0] Write_Address;
    reg Write_Enable;

    /*PC*/
    Program_Counter PC(.reset(initial_reset) ,.clk(clk), .PC_Out(PC_OUT));

    /*Instruction Memory*/
    Inst_Memory INSMEM(.PC_Address(PC_OUT),.OP_Code(Instruction),.Write_Address(Write_Address),.Write_Enable(Write_Enable),.Instruction(IF_ID_input));

    /*IF/ID Buffer*/
    IF_ID IFID (.DataIn({PC_OUT,IF_ID_input}), .Buffer(IFIDBuffer), .clk(clk));

    /*Control Unit*/
    CU CTRLUNIT (.In(IFIDBuffer[15:13]), .WB(ID_EX_input[36]), .Alu(ID_EX_input[33]), .MR(ID_EX_input[34]), .MW(ID_EX_input[35]), .AluOp(ID_EX_input[32]),.Imm(ID_EX_input[40]));

    /*Decoding Stage*/
    DecodingStage DECSTAGE (.write_back(1'b0), .read_data1(ID_EX_input[31:16]), .alu_input2(ID_EX_input[15:0]),  .write_data(16'd15), .clk(clk),
    .src_addr(IFIDBuffer[4:2]),.dst_addr(IFIDBuffer[7:5]),.write_addr(3'd3));

    assign ID_EX_input[83:52]=IFIDBuffer[47:16];
    /*Forwarding Unit*/
    ForwardingUnit Forwarding_Unit (
    .Dst_ID_EX(IDEXBuffer[43:41]),
    .Src_ID_EX(IDEXBuffer[87:85]),
    .Dst_EX_MEM(EXMEMBuffer[34:32]),
    .WB_EX_MEM(EXMEMBuffer[37]),
    .Data_EX_MEM(EXMEMBuffer[15:0]),
    .Dst_MEM_WB(3'd3),
    .WB_MEM_WB(WB_MEM_WB),
    .Data_MEM_WB(16'd561),
    .Data_Dst(Forwarding_Unit_Data1),
    .Data_Src(Forwarding_Unit_Data2),
    .Selectors(Selectors_Forwarding_Unit)
    );

    /*Stack Pointer*/
    StackPointer Stack_Pointer_Register(.DataIn(Stack_Pointer_Out), .Buffer(Stack_Pointer), .clk(clk), .reset(reset));

    /*Flag Register*/
    FlagRegister Flag_Register(.DataIn(EX_MEM_input[75:73]), .Buffer(Flags), .clk(clk), .reset(reset));

    /*Output Port*/
    OUTPUTPORT OUTPUT_PORT(.DataIn(OUTPUT_PORT_Output), .Buffer(OUTPUT_PORT_Register), .clk(clk));
    
    /*ID/EX Buffer*/
    ID_EX IDEX(.DataIn(ID_EX_input), .Buffer(IDEXBuffer), .clk(clk));

    /*Execution Unit*/
    ExecutionUnit EXUNIT (
    /*Inputs From Buffer*/
    .IOR(IDEXBuffer[0]),
    .IOW(IDEXBuffer[1]),
    .OPS(IDEXBuffer[2]),
    .ALU(IDEXBuffer[6]),
    .MR(IDEXBuffer[44]),
    .MW(IDEXBuffer[45]),
    .WB(IDEXBuffer[46]),
    .JMP(IDEXBuffer[47]),
    .SP(IDEXBuffer[48]),
    .SPOP(IDEXBuffer[49]),
    .JWSP(IDEXBuffer[84]),
    .IMM(IDEXBuffer[88]),
    .Stack_PC(IDEXBuffer[89]),
    .Stack_Flags(IDEXBuffer[90]),

    .FD(IDEXBuffer[8:7]),
    .FGS(IDEXBuffer[51:50]),

    .ALU_OP(IDEXBuffer[5:3]),
    .WB_Address(IDEXBuffer[43:41]),
    .SRC_Address(IDEXBuffer[87:85]),

    .Data1(IDEXBuffer[24:9]),
    .Data2(IDEXBuffer[40:25]),
    .Immediate_Value(IF_Buffer),
    .PC(IDEXBuffer[83:52]),

    /*Signals*/
    .Forwarding_Unit_Selectors(Selectors_Forwarding_Unit), // 1-bit To be changed in the design

    /*Asynchronous Inputs*/
    .Data_From_Forwarding_Unit1(Forwarding_Unit_Data1),
    .Data_From_Forwarding_Unit2(Forwarding_Unit_Data2),

    /*Flags*/
    /*NF|CF|ZF*/
    .Flags(Flags),

    /*Flags From Memory*/
    /*NF|CF|ZF*/
    .Flags_From_Memory(Flags_From_Memory),

    /*Input Port*/
    .INPUT_PORT(INPUT_PORT),

    /*Output Port*/
    .OUTPUT_PORT(OUTPUT_PORT_Output),
    .OUTPUT_PORT_Input(OUTPUT_PORT_Register),

    /*Stack Pointer*/
    .Stack_Pointer(Stack_Pointer),

    /*Outputs*/
    .MR_Out(EX_MEM_input[35]),
    .MW_Out(EX_MEM_input[36]),
    .WB_Out(EX_MEM_input[37]),
    .JWSP_Out(EX_MEM_input[70]),
    .Stack_PC_Out(EX_MEM_input[71]),
    .Stack_Flags_Out(EX_MEM_input[72]),
    .WB_Address_Out(EX_MEM_input[34:32]),
    .Data(EX_MEM_input[31:0]),
    .Address(EX_MEM_input[69:38]),

    /*Flags Outputs*/
    /*NF|CF|ZF*/
    .Final_Flags(EX_MEM_input[75:73]),

    /*Stack Pointer Out*/
    .Stack_Pointer_Out(Stack_Pointer_Out),

    /*For Jumps*/
    .Taken_Jump(JMP), 

    /* Output Signals */
    /*PC Selectors*/
    .To_PC_Selector(To_PC_Selector),

     /*Data From EX/MEM Buffer*/
    .MEM_Stack_Flags(EXMEMBuffer[72]),
    .MEM_MR(EXMEMBuffer[35])
);

    /*EX/MEM Buffer*/
    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(EXMEMBuffer), .clk(clk));

    reg [8*50:1] instuction;

    initial begin
        // $monitor("IDEXBuffer=%b,EXMEMBuffer=%b",IDEXBuffer,EXMEMBuffer);
        $monitor("Instuction=%s\n,IOR=%b, IOW=%b, OPS=%b, ALU_OP=%b, ALU=%b, FD=%b, Data1=%d, Data2=%d, WB_Address=%b, MR=%b, MW=%b, WB=%b, JMP=%b, SP=%b, SPOP=%b, FGS=%b, PC=%d, JWSP=%b, SRC_Address=%b, Immediate=%b, Stack_PC=%b, Stack_Flags=%b, Data=%d, WB_Address_out=%b, MR_out=%b, MW_out=%b, WB_out=%b, Address=%d, JWSP_out=%b, Stack_PC_out=%b, Stack_Flags_out=%b, Final_Flags=%b, Flag Register=%b, OUTPUT_PORT=%d, Stack_Pointer=%d, JMP_Flag=%b",
        instuction,IDEXBuffer[0],IDEXBuffer[1],IDEXBuffer[2],IDEXBuffer[5:3],IDEXBuffer[6],IDEXBuffer[8:7],IDEXBuffer[24:9],IDEXBuffer[40:25],IDEXBuffer[43:41],IDEXBuffer[44],IDEXBuffer[45],IDEXBuffer[46],IDEXBuffer[47],IDEXBuffer[48],IDEXBuffer[49],IDEXBuffer[51:50],IDEXBuffer[83:52],IDEXBuffer[84],IDEXBuffer[87:85],IDEXBuffer[88],IDEXBuffer[89],IDEXBuffer[90],EXMEMBuffer[31:0],EXMEMBuffer[34:32],EXMEMBuffer[35],EXMEMBuffer[36],EXMEMBuffer[37],EXMEMBuffer[69:38],EXMEMBuffer[70],
        EXMEMBuffer[71],EXMEMBuffer[72],EXMEMBuffer[75:73],Flags,OUTPUT_PORT_Register,Stack_Pointer, JMP
        );
        clk=1;
        reset=1'b1;
        Flags_From_Memory=3'b000;
        INPUT_PORT=16'd12;
        
        IF_Buffer=16'd12;
        ID_EX_input=91'd0;

        #DELAY;
        reset=1'b0;

        /*MOV R7,127*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd127,16'd10,2'b10,7'd0};

        #DELAY;
        /*ADD 7,8*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd7,2'b11,1'b1,3'd0,3'd0};

        #DELAY;

        /*SUB 23,8*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd23,2'b11,1'b1,3'd1,3'd0};

        #DELAY;

        /*SUB 8,23*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd23,16'd8,2'b11,1'b1,3'd1,3'd0};

        #DELAY;

        /*AND 0101,1010*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'b1010,16'b0101,2'b11,1'b1,3'd2,3'd0};

        #DELAY;

        /*OR 0101,1010*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'b1010,16'b0101,2'b11,1'b1,3'd3,3'd0};
        
        #DELAY;

        /*Shift Left  1's, 16 [Immediate]*/
        IF_Buffer = 16'd16;
        ID_EX_input={3'd1,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd16,{16{1'b1}},2'b11,1'b1,3'd4,3'd0};

        #DELAY;

        /*Shift Right  1's, 16 [Immediate]*/
        IF_Buffer = 16'd16;
        ID_EX_input={3'd1,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd16,{16{1'b1}},2'b11,1'b1,3'd5,3'd0};

        #DELAY;

        /*Shift Left  1's, 15 [Immediate]*/
        IF_Buffer = 16'd15;
        ID_EX_input={3'd1,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd16,{16{1'b1}},2'b11,1'b1,3'd4,3'd0};

        #DELAY;

        /*Shift Right  1's, 15 [Immediate]*/
        IF_Buffer = 16'd15;
        ID_EX_input={3'd1,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd16,{16{1'b1}},2'b11,1'b1,3'd5,3'd0};

        #DELAY;

        /*INC 7*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b110,16'd66,16'd7,2'b11,1'b1,3'd0,1'b1,2'd0};

        #DELAY;

        /*DEC 7*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b110,16'd66,16'd7,2'b11,1'b1,3'd1,1'b1,2'd0};

        #DELAY;

        /*NOT 15*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b110,16'd66,16'd15,2'b11,1'b1,3'd7,1'b0,2'd0};

        #DELAY;

        /*SETC*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b0,2'd0,3'b110,16'd66,16'd15,2'b01,1'b0,3'd7,1'b0,2'd0};

        #DELAY;

        /*CLRC*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b110,16'd66,16'd15,2'b00,1'b1,3'd7,1'b0,2'd0};

        #DELAY;

        /*IN R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd0,1'b1,2'd0,3'b110,16'd66,16'd15,2'b10,1'b0,3'd000,1'b0,2'd1};

        #DELAY;

        /*OUT R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd0,1'b0,2'd0,3'b110,16'd66,16'd77,2'b10,1'b0,3'd000,1'b0,2'd2};

        #DELAY;


        /*PUSH R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd2,1'b0,2'd2,3'b110,16'd66,16'd15,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        /*POP R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd6,1'b0,2'd1,3'b110,16'd66,16'd15,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        /*POP R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd6,1'b0,2'd1,3'b110,16'd66,16'd15,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        /*PUSH R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd2,1'b0,2'd2,3'b110,16'd66,16'd15,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        /*LDM R7,525*/
        IF_Buffer = 16'd525;
        ID_EX_input={3'd1,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd127,16'd10,2'b10,7'd0};

        #DELAY;

        /*LDD R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd0,1'b1,2'd1,3'b110,16'd606,16'd11,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        /*STD R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd0,1'b0,2'd2,3'b110,16'd606,16'd11,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

                                    /*Output in Same Cycle Of JZ, JC, JN*/

        instuction="JMP R6";
        /*JMP R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b11001,1'b0,2'd0,3'b101,16'd66,16'd888,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="JZ R6";
        /*Not Taken*/
        /*JZ R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b00001,1'b0,2'd0,3'b101,16'd66,16'd888,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="SUB 8,8";
        /*SUB 8,8*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd8,2'b11,1'b1,3'd1,3'd0};

        #DELAY;

        instuction="JZ R6";
        /*Taken*/
        /*JZ R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b00001,1'b0,2'd0,3'b101,16'd66,16'd888,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="JC R6";
        /*Not Taken*/
        /*JC R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b10001,1'b0,2'd0,3'b101,16'd66,16'd444,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="Shift Left  1's, 16 [Immediate]";
        /*Shift Left  1's, 16 [Immediate]*/
        IF_Buffer = 16'd16;
        ID_EX_input={3'd1,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd16,{16{1'b1}},2'b11,1'b1,3'd4,3'd0};

        #DELAY;

        instuction="JC R6";
        /*Taken*/
        /*JC R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b10001,1'b0,2'd0,3'b101,16'd66,16'd444,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="JN R6";
        /*Not Taken*/
        /*JN R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b01001,1'b0,2'd0,3'b101,16'd66,16'd777,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="SUB 1,8";
        /*SUB 1,8*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd1,2'b11,1'b1,3'd1,3'd0};

        #DELAY;
        
        instuction="JN R6";
        /*Taken*/
        /*JN R6*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'b01001,1'b0,2'd0,3'b101,16'd66,16'd777,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="CALL R6";
        /*CALL R6*/
        ID_EX_input={3'd2,3'b111,1'b0,32'd1465,5'b11011,1'b0,2'd2,3'b101,16'd55,16'd5555,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="RET";
        /*RET*/
        ID_EX_input={3'd2,3'b111,1'b1,32'd1558,5'b11111,1'b0,2'd1,3'b101,16'd55,16'd5555,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        instuction="RTI";
        /*RET*/
        ID_EX_input={3'd6,3'b111,1'b1,32'd1558,5'b11111,1'b0,2'd1,3'b101,16'd55,16'd5555,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

        /*ADD 7,8 ADD Some Value to R7*/
        instuction="ADD 7,8 ADD Some Value to R7";
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd7,2'b11,1'b1,3'd0,3'd0};

        #DELAY;

        /*ADD 7,8 ADD Some Value to R7 Will Take 15 not 7*/
        instuction="ADD 7,8 ADD Some Value to R7 Will Take 15 not 7";
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd7,2'b11,1'b1,3'd0,3'd0};

        #DELAY;

        /*ADD 7,8 ADD Some Value to R7 Will Take 23 not 7 or 8*/
        instuction="ADD 7,8 ADD Some Value to R7 Will Take 23 not 7 or 8";
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd7,2'b11,1'b1,3'd0,3'd0};

        #DELAY;

        /*ADD 7,8 ADD Some Value to R3 Will Take 561 not 7 or 8*/
        WB_MEM_WB=1'b1;
        instuction="ADD 7,8 ADD Some Value to R3 Will Take 561 not 7 or 8";
        ID_EX_input={3'd0,3'b011,1'b0,32'd15,5'd0,1'b1,2'd0,3'b011,16'd8,16'd7,2'b11,1'b1,3'd0,3'd0};

        #DELAY;

        /*ADD 7,8 ADD Some Value to R3 Will Take 7 and 8 not 561*/
        WB_MEM_WB=1'b0;
        instuction="ADD 7,8 ADD Some Value to R3 Will Take 7 and 8 not 561";
        ID_EX_input={3'd0,3'b011,1'b0,32'd15,5'd0,1'b1,2'd0,3'b011,16'd8,16'd7,2'b11,1'b1,3'd0,3'd0};

        #DELAY;

        instuction="NOP";
        /*NOP*/
        ID_EX_input={3'd0,3'b111,1'b0,32'd15,5'd0,1'b0,2'd0,3'b110,16'd66,16'd15,2'b10,1'b0,3'd000,1'b0,2'd0};

        #DELAY;

    end

    always begin
        #CLK;
        clk=~clk;
    end


endmodule