`include "ID_EX.v"
`include "ExecutionUnit.v"
`include "EX_MEM.v"
/*ID/EX Buffer 192 bit*/
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
16: Immediate_Value                   |  106
2: Forwarding_Unit_Selectors          |  108:107
3: Flags                              |  111:109
16: Data_From_Forwarding_Unit1        |  127:112
16: Data_From_Forwarding_Unit2        |  143:128
16: INPUT_PORT                        |  159:144
32: Stack_Pointer                     |  191:160
*/

/*EX/MEM Buffer 110*/
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
1: Taken_Jump               | 73
1: To_PC_Selector           | 74
3: Final_Flags              | 77:75
32: Stack_Pointer_Out       | 109:78
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

    /*ID/EX Buffer*/
    ID_EX IDEX(.DataIn(ID_EX_input), .Buffer(IDEXBuffer), .clk(clk));

    /*Execution Unit*/
    ExecutionUnit EXUNIT (.ALU(IDEXBuffer[33]), .ALUOperation(IDEXBuffer[32]), .Data1(IDEXBuffer[31:16]),
    .Data2((IDEXBuffer[40]==1'b0)?IDEXBuffer[15:0]:IFIDBuffer), .DataOut(EX_MEM_input[47:32]), .Address(EX_MEM_input[31:0]));

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