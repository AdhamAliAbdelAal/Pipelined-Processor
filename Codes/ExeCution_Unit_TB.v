`include "ID_EX.v"
`include "ExecutionUnit.v"
`include "EX_MEM.v"
/*ID/EX Buffer 141 bit*/
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
16: Immediate_Value                   |  106:91
2: Forwarding_Unit_Selectors          |  108:107
16: Data_From_Forwarding_Unit1        |  124:109
16: Data_From_Forwarding_Unit2        |  140:125
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

    wire [40:0] ID_EX_input;
    wire [40:0] IDEXBuffer;

    wire [53:0] EX_MEM_input;
    wire [53:0] EXMEMBuffer;

    reg clk;
    reg [2:0]Flags,Flags_From_Memory;
    reg [15:0] INPUT_PORT;
    reg [31:0] Stack_Pointer;

    wire [2:0] Flags_Out;
    wire [31:0] Stack_Pointer_Out;

    wire JMP;

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
    .Immediate_Value(IDEXBuffer[106:91]),
    .PC(IDEXBuffer[83:52]),

    /*Signals*/
    .Forwarding_Unit_Selectors(IDEXBuffer[108:107]), // 1-bit To be changed in the design

    /*Asynchronous Inputs*/
    .Data_From_Forwarding_Unit1(IDEXBuffer[124:109]),
    .Data_From_Forwarding_Unit2(IDEXBuffer[140:125]),

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
    .Data(EX_MEM_input[31:0]),Address,

    /*Flags Outputs*/
    /*NF|CF|ZF*/
    .Final_Flags(Flags_Out),

    /*Stack Pointer Out*/
    .Stack_Pointer_Out(Stack_Pointer_Out),

    /*For Jumps*/
    .Taken_Jump(JMP), 

    /* Output Signals */
    /*PC Selectors*/
    To_PC_Selector
);

    /*EX/MEM Buffer*/
    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(EXMEMBuffer), .clk(clk));


    initial begin
        $monitor("IDEXBuffer=%b,EXMEMBuffer=%b",IDEXBuffer,EXMEMBuffer);


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

        /*LDM R6,65535*/
        Write_Address=Write_Address+1;
        Instruction={8'b00101000,3'b110,3'b000,2'b00};
        #MEMDELAY
        Write_Address=Write_Address+1;
        Instruction=16'd65535;
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b110,3'b110,2'b00};
        #MEMDELAY

        /*NOP*/
        Write_Address=Write_Address+1;
        Instruction={8'b10101000,3'b110,3'b110,2'b00};
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