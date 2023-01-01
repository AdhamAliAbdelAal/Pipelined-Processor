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
`include "MemoryUnit.v"
`include "Load_Use.v"
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

/*EX/MEM Buffer 78*/
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
1: SP_Out                   | 76
1: SPOP_Out                 | 77
*/

module Processor();
    localparam CLK=5;
    localparam DELAY=2*CLK;
    localparam MEMDELAY=5*DELAY;

    wire [48:0] IF_ID_input;
    wire [48:0] IFIDBuffer;

    wire [91:0] ID_EX_input;
    wire [91:0] IDEXBuffer;

    wire [77:0] EX_MEM_input;
    wire [77:0] EXMEMBuffer;

    wire [19:0] MEM_WB_input;
    wire [19:0] MEMWBBuffer;

    wire [15:0] OUTPUT_PORT_Output,OUTPUT_PORT_Register;

    reg clk;
    reg reset;
    reg [15:0] INPUT_PORT;
    wire [31:0] Stack_Pointer;
    wire [1:0] Selectors_Forwarding_Unit;
    wire [15:0] Forwarding_Unit_Data1, Forwarding_Unit_Data2;
    wire [2:0] Flags;
    wire [31:0] Stack_Pointer_Out;
    wire JMP,To_PC_Selector;


    wire [31:0] PC_OUT;
    reg [15:0] Instruction;
    reg [31:0] Write_Address;
    reg Write_Enable;

    reg INT;

    /*Load Use*/
    
    wire Keep_Fetched_Instruction, Keep_PC, Flush_MUX_Selector;

    /*Memory Outs*/
    wire [2:0] out_flags;
    wire [31:0] Accumulated_PC;
    wire Stall_Signal;
    wire MemWSP;
    wire [15:0] Data_To_Use;

    /*PC*/
    Program_Counter PC(.reset(reset) ,
    .clk(clk), 
    .PC_Out(PC_OUT), 
    .stall(Keep_PC|Stall_Signal),
    .INT(IFIDBuffer[48]),
    .To_PC_Selector(To_PC_Selector),
    .MemWSP(MemWSP),
    .accPC(Accumulated_PC),
    .Dst({{16{1'b0}},Data_To_Use}),
    .Still_INT(IDEXBuffer[91])
    );

    /*Instruction Memory*/
    reg reset_ins;
    Inst_Memory INSMEM(.PC_Address(PC_OUT),.OP_Code(Instruction),.Write_Address(Write_Address),.Write_Enable(Write_Enable),.Instruction( IF_ID_input[15:0]),.reset(reset_ins));

    assign IF_ID_input[47:16]=(INT==1'b0)?PC_OUT+1:(INT==1'b1 && To_PC_Selector==1'b1)?({{16{1'b0}},Data_To_Use}):PC_OUT;

    /*IF/ID Buffer*/
    wire stall_IF_ID;
    assign stall_IF_ID = Keep_Fetched_Instruction|Stall_Signal;
    wire flush_IF_ID;
    assign flush_IF_ID = (To_PC_Selector | EXMEMBuffer[70]) & !INT & !IDEXBuffer[91];
    assign IF_ID_input[48]=INT;
    IF_ID IFID (.DataIn(IF_ID_input), .Buffer(IFIDBuffer), .clk(clk), .reset(reset), .stall(stall_IF_ID),.flush(flush_IF_ID));

    /*Control Unit*/
    CU CTRLUNIT (
        .Opcode(IFIDBuffer[15:8]),
        .INT(IFIDBuffer[48]),
        .WB(ID_EX_input[46]),
        .ALU(ID_EX_input[6]),
        .ALU_Ops(ID_EX_input[5:3]),
        .Imm(ID_EX_input[88]),
        /*OPS Selector*/
        .Selector(ID_EX_input[2]),
        .MR(ID_EX_input[44]),
        .MW(ID_EX_input[45]),
        .Jmp(ID_EX_input[47]),
        .Flag_Selector(ID_EX_input[51:50]),
        .FD(ID_EX_input[8:7]),
        .IOR(ID_EX_input[0]),
        .IOW(ID_EX_input[1]),
        .IsStackOp(ID_EX_input[48]),
        .StackOp(ID_EX_input[49]),
		.Stack_PC(ID_EX_input[89]),
        .Stack_Flags(ID_EX_input[90]),
        .JWSP(ID_EX_input[84])
        );
    
    assign ID_EX_input[83:52]=(To_PC_Selector===1'b1 && IFIDBuffer[48]===1'b1)?({{16{1'b0}},Data_To_Use}):IFIDBuffer[47:16];
    assign ID_EX_input[43:41]=IFIDBuffer[7:5];
    assign ID_EX_input[87:85]=IFIDBuffer[4:2];
    assign ID_EX_input[91] = IFIDBuffer[48];

    Load_Use_Case Load_Use(
         .MR(IDEXBuffer[44]),
         .EXEC_Dst(IDEXBuffer[43:41]), 
         .DEC_Src1(IFIDBuffer[4:2]), 
         .DEC_Src2(IFIDBuffer[7:5]), 
         .Keep_Fetched_Instruction(Keep_Fetched_Instruction), 
         .Keep_PC(Keep_PC), 
         .Flush_MUX_Selector(Flush_MUX_Selector)
    );

    /*Decoding Stage*/
    DecodingStage DECSTAGE (.write_back(MEMWBBuffer[19]), .read_data1(ID_EX_input[24:9]), .alu_input2(ID_EX_input[40:25]),  .write_data(MEMWBBuffer[15:0]), .clk(clk),.reset(reset),
    .src_addr(IFIDBuffer[4:2]),.dst_addr(IFIDBuffer[7:5]),.write_addr(MEMWBBuffer[18:16]));

    /*Forwarding Unit*/
    ForwardingUnit Forwarding_Unit (
    .Dst_ID_EX(IDEXBuffer[43:41]),
    .Src_ID_EX(IDEXBuffer[87:85]),
    .Dst_EX_MEM(EXMEMBuffer[34:32]),
    .WB_EX_MEM(EXMEMBuffer[37]),
    .Data_EX_MEM(EXMEMBuffer[15:0]),
    .Dst_MEM_WB(MEMWBBuffer[18:16]),
    .WB_MEM_WB(MEMWBBuffer[19]),
    .Data_MEM_WB(MEMWBBuffer[15:0]),
    .Data_Dst(Forwarding_Unit_Data1),
    .Data_Src(Forwarding_Unit_Data2),
    .Selectors(Selectors_Forwarding_Unit)
    );

    /*Stack Pointer*/
    StackPointer Stack_Pointer_Register(.DataIn(Stack_Pointer_Out), .Buffer(Stack_Pointer), .clk(clk), .reset(reset));

    /*Flag Register*/
    FlagRegister Flag_Register(.DataIn(EX_MEM_input[75:73]), .Buffer(Flags), .clk(clk), .reset(reset));

    /*Output Port*/
    OUTPUTPORT OUTPUT_PORT(.DataIn(OUTPUT_PORT_Output), .Buffer(OUTPUT_PORT_Register), .clk(clk),.reset(reset));
    wire flush_ID_EX;
    assign flush_ID_EX= (IDEXBuffer[88]|Flush_MUX_Selector|To_PC_Selector | EXMEMBuffer[70]) & !IFIDBuffer[48];
    /*ID/EX Buffer*/
    ID_EX IDEX(.DataIn(ID_EX_input), .Buffer(IDEXBuffer), .clk(clk),.reset(reset),.flush(flush_ID_EX),.stall(Stall_Signal));

    wire flag_selector;
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
    .Immediate_Value(IFIDBuffer[15:0]),
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
    .Flags_From_Memory(out_flags),

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
    .SP_Out(EX_MEM_input[76]),
    .SPOP_Out(EX_MEM_input[77]),
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
    .MEM_Stack_Flags(flag_selector),

    /*data to pc*/
    .Data_To_Use(Data_To_Use)
);

    /*EX/MEM Buffer*/
    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(EXMEMBuffer), .clk(clk),.reset(reset), .flush(1'b0),.stall(Stall_Signal));

    /*Memory Unit*/
    MemoryUnit MEMUNIT (
    .clk(clk),
    .EX_MEM_input(EXMEMBuffer),
    .MEM_Output(MEM_WB_input),
    .out_flags(out_flags),
    .Accumulated_PC(Accumulated_PC),
    .Stall_Signal(Stall_Signal),
    .flag_selector(flag_selector),
    .MemWSP(MemWSP)
);

    /*MEM/WB Buffer*/
    MEM_WB MEMWB(.DataIn(MEM_WB_input), .Buffer(MEMWBBuffer), .clk(clk), .reset(reset), .flush(1'b0));

    reg [8*50:1] instuction;
    reg [32:0] data_from_file;
    integer fd; // file handler

    integer count;

    initial begin
        $monitor("IF/ID=%b,IOR=%b, IOW=%b, OPS=%b, ALU_OP=%b, ALU=%b, FD=%b, Data1=%d, Data2=%d, WB_Address=%b, MR=%b, MW=%b, WB=%b, JMP=%b, SP=%b, SPOP=%b, FGS=%b, PC=%d, JWSP=%b, SRC_Address=%b, Immediate=%b, Stack_PC=%b, Stack_Flags=%b, Data=%d, WB_Address_out=%b, MR_out=%b, MW_out=%b, WB_out=%b, Address=%d, JWSP_out=%b, Stack_PC_out=%b, Stack_Flags_out=%b, Final_Flags=%b, Flag Register=%b, OUTPUT_PORT=%d, Stack_Pointer=%d, JMP_Flag=%b, MEM_WB_Buffer = %b, Accumulated_PC=%d, Keep_Fetched_Instruction=%b",
        IFIDBuffer,IDEXBuffer[0],IDEXBuffer[1],IDEXBuffer[2],IDEXBuffer[5:3],IDEXBuffer[6],IDEXBuffer[8:7],IDEXBuffer[24:9],IDEXBuffer[40:25],IDEXBuffer[43:41],IDEXBuffer[44],IDEXBuffer[45],IDEXBuffer[46],IDEXBuffer[47],IDEXBuffer[48],IDEXBuffer[49],IDEXBuffer[51:50],IDEXBuffer[83:52],IDEXBuffer[84],IDEXBuffer[87:85],IDEXBuffer[88],IDEXBuffer[89],IDEXBuffer[90],EXMEMBuffer[31:0],EXMEMBuffer[34:32],EXMEMBuffer[35],EXMEMBuffer[36],EXMEMBuffer[37],EXMEMBuffer[69:38],EXMEMBuffer[70],
        EXMEMBuffer[71],EXMEMBuffer[72],EXMEMBuffer[75:73],Flags,OUTPUT_PORT_Register,Stack_Pointer, JMP, MEMWBBuffer, Accumulated_PC, Keep_Fetched_Instruction
        );
        reset_ins=1'b1;
        INT=1'b0;
        #MEMDELAY;
        reset_ins=1'b0;
        Write_Enable=1'b1;
        count=0;

        fd=$fopen("../Assembler/ins_mem.txt", "r");  
        while (!$feof(fd)) 
        begin  
            $fscanf(fd, "%b\n", data_from_file);
            if(data_from_file[32]==1'b1)
            begin
                Write_Address=data_from_file[31:0];
            end
            else 
            begin
                Instruction=data_from_file[15:0];
                #DELAY;
                Write_Address=Write_Address+1;
            end 
        end

        Write_Enable=1'b0;
        reset = 1'b1;
        clk=0;
        INPUT_PORT=16'd12;
        #DELAY;
        reset = 1'b0;

        #MEMDELAY;

    end

    always begin
        #CLK;
        clk=~clk;
    end

    // always @(negedge clk)
    // begin  
    //     if(count==7)
    //     begin
    //         INT=1'b1;
    //     end
    //     else begin
    //         INT=1'b0;
    //     end
    //     count=count+1;
    // end


endmodule