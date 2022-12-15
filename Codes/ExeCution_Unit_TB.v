`include "ID_EX.v"
`include "ExecutionUnit.v"
`include "EX_MEM.v"
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

    reg [90:0] ID_EX_input;
    wire [90:0] IDEXBuffer;

    wire [75:0] EX_MEM_input;
    wire [75:0] EXMEMBuffer;

    reg clk;
    reg [15:0] IF_Buffer;
    reg [2:0]Flags,Flags_From_Memory;
    reg [15:0] INPUT_PORT;
    reg [31:0] Stack_Pointer;
    reg [1:0] Selectors_Forwarding_Unit;
    reg [15:0] Forwarding_Unit_Data1, Forwarding_Unit_Data2;
    wire [2:0] Flags_in;
    wire [31:0] Stack_Pointer_Out;
    wire JMP,To_PC_Selector;

    assign Flags_in =EX_MEM_input[75:73];

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
    .To_PC_Selector(To_PC_Selector)
);

    /*EX/MEM Buffer*/
    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(EXMEMBuffer), .clk(clk));


    initial begin
        $monitor("IDEXBuffer=%b,EXMEMBuffer=%b",IDEXBuffer,EXMEMBuffer);
        /*MOV*/
        Flags=3'b000;
        Flags_From_Memory=3'b000;
        INPUT_PORT=16'd12;
        Stack_Pointer=32'd10;
        IF_Buffer=16'd12;
        Forwarding_Unit_Data1=16'd55;
        Forwarding_Unit_Data2=16'd127;
        Selectors_Forwarding_Unit=2'b00;
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd127,16'd10,2'b10,7'd0};
        clk=0;

        #DELAY;
        /*ADD*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd7,2'b10,1'b1,3'd0,3'd0};

        #DELAY;

        /*SUB*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'd8,16'd23,2'b10,1'b1,3'd1,3'd0};

        #DELAY;

        /*AND*/
        ID_EX_input={3'd0,3'b101,1'b0,32'd15,5'd0,1'b1,2'd0,3'b111,16'b1010,16'b0101,2'b10,1'b1,3'd2,3'd0};

        #DELAY;
    end

    always begin
        #CLK;
        clk=~clk;
    end


endmodule