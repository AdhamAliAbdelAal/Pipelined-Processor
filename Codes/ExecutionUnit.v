/*ID/EX Buffer*/
/*
1: IOR
1: IOW
1: OPS
3: ALU_OP  
1: ALU
2: FD
16: Data1
16: Data2
3: WB_Address
1: MR
1: MW
1: WB
1: JMP
1: SPOP
2: FGS
32: PC
1: JWSP
3: SRC_Address
1: IMM
1: Stack_PC
1: Stack_Flags
16: Immediate_Value
*/

/*EX/MEM Buffer*/
/*
32: Data
3: WB_Address_Out
1: MR_Out
1: MW_Out
1: WB_Out
32: Address
1: JWSP_Out
1: Stack_PC_Out
1: Stack_Flags_Out
*/

module ExecutionUnit(
    /*Inputs From Buffer*/
    IOR,IOW,OPS,ALU,MR,MW,WB,JMP,SPOP,JWSP,IMM,Stack_PC,Stack_Flags,
    FD,FGS,
    ALU_OP,WB_Address,SRC_Address,
    Data1,Data2,Immediate_Value,
    PC,

    /*Signals*/
    Forwarding_Unit_Selectors, // 1-bit To be changed in the design

    /*Asynchronous Inputs*/
    Data_From_Forwarding_Unit1,
    Data_From_Forwarding_Unit2,

    /*Flags*/
    /*NF|CF|ZF*/
    Flags,

    /*Flags From Memory*/
    /*NF|CF|ZF*/
    Flags_From_Memory,

    /*Input Port*/
    INPUT_PORT,

    /*Outputs*/
    MR_Out,MW_Out,WB_Out,JWSP_Out,Stack_PC_Out,Stack_Flags_Out,
    WB_Address_Out,
    Data,Address,

    /*Flags Outputs*/
    /*NF|CF|ZF*/
    Flags_Out,
);  
    /*Inputs*/
    input IOR,IOW,OPS,ALU,MR,MW,WB,JMP,SPOP,JWSP,IMM,Stack_PC,Stack_Flags;
    input [1:0] FD,FGS,Forwarding_Unit_Selectors;
    input [2:0] ALU_OP,WB_Address,SRC_Address,Flags;
    input [15:0] Data1,Data2,Immediate_Value,Data_From_Forwarding_Unit1,Data_From_Forwarding_Unit2,INPUT_PORT;
    input [31:0] PC;

    /*Outputs*/
    output MR_Out,MW_Out,WB_Out,JWSP_Out,Stack_PC_Out,Stack_Flags_Out;
    output [2:0] WB_Address_Out,Flags_Out;
    output [31:0] Data,Address;

    /*Connections*/
    wire [15:0] Operand1,Operand2,Immediate_Or_Register,Data_Or_One,Data_From_ALU,Data_To_Use;
    wire [2:0] Flags_From_Decision,Final_Flags;
    wire Temp_CF,Select_Flags_Or_From_Memory;


    /* Level 1 */
    assign Operand1= Forwarding_Unit_Selectors[0]==1'b1?Data_From_Forwarding_Unit1:Data1;

    assign Immediate_Or_Register= IMM==1'b1?Immediate_Value:Data2;

    assign Data_Or_One= Forwarding_Unit_Selectors[1]==1'b1?Data_From_Forwarding_Unit2:Immediate_Or_Register;

    assign Operand2= OPS==1'b1?16'd1:Data_Or_One;


    /* Level 2 */
    assign {Temp_CF,Data_From_ALU} = (ALU_OP==3'd7)? ~Operand1:
        (ALU_OP==3'd0)? Operand1+Operand2:
        (ALU_OP==3'd1)? Operand1-Operand2:
        (ALU_OP==3'd2)? Operand1&Operand2:
        (ALU_OP==3'd3)? Operand1|Operand2:
        (ALU_OP==3'd4)? Operand1<<Operand2:
        (ALU_OP==3'd5)? Operand1>>Operand2:Operand1;


    /*NF|CF|ZF*/
    assign Flags_Out[0]= Data_From_ALU==16'd0; // ZF
    assign Flags_Out[1]= (ALU_OP==3'd0 || ALU_OP==3'd1 || ALU_OP==3'd4) ? Temp_CF : Flags[1]; // CF
    assign Flags_Out[2]= Data_From_ALU[15]==1'b1; // NF


    /* Level 3 */
    assign Data_To_Use=(JMP==1'b1)?Operand1:
        (IOW==1'b1)?Operand1:
        (ALU===1'b1)?Data_From_ALU:
        (IOR===1'b1)?INPUT_PORT:
        (MW===1'b1)?Operand2:Operand2;


    assign Flags_From_Decision=(FD==2'b00)?{Flags[2],0,Flags[0]}:
        (FD==2'b01)?{Flags[2],1,Flags[0]}:
        (FD==2'b10)?Flags:
        (FD==2'b11)?Flags_Out:3'b000;

    
    assign Select_Flags_Or_From_Memory= Stack_Flags & MR;

    assign Final_Flags=Select_Flags_Or_From_Memory==1'b1?Flags_From_Memory:Flags_From_Decision;

    /*Unchangable*/
    assign  {MR_Out,MW_Out,WB_Out,JWSP_Out,Stack_PC_Out,Stack_Flags_Out}={MR,MW,WB,JWSP,Stack_PC,Stack_Flags};
endmodule