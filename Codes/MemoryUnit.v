`include "Memory.v"
module MemoryUnit(EX_MEM_input,out_flags,clk,Accumulated_PC,Stall_Signal,MEM_Output);
//   74:43      42:40       39     38       37         36:5          4          3                2              1            0
//  32bit_data|3bit_Dst|1bit_MR|1bit_MW|1bit_WB| 32bit_Address|1bit_JWSP|1bit_stackPC|1bit_stackFlags|3bits_Flags|1bit_isStackOp|1bit_StackOp   
//  0:31        32:34    35       36      37       38:69         70        71           72                73:75     76               77
    
    input [77:0]  EX_MEM_input;
    input clk;
    output [19:0] MEM_Output;
    output [2:0]out_flags;



    //accumulated pc
    output [31:0] Accumulated_PC;

    // output of state machine
    wire [1:0] State_Machine_Out;
    wire [1:0] Machine_Stack;
    output Stall_Signal;

    // wires for stack handler input
    wire IsStackOp;
    wire StackOp;

    // stack pointer out
    wire [31:0] Stack_Pointer_Out;
    wire [31:0] Stack_Pointer;

    // right address
    wire [31:0] Address;

    // memory write data
    wire [15:0] MW_Data;

    wire [15:0] MR_Data;
    

    // output data
    wire [15:0]outData;

    // new stack pointer
    wire [31:0] NewSP;


    stackPointer sp(.in(NewSP), .clk(clk), .data(Stack_Pointer));


    State_Machine stateMachine(.clk(clk),.Stack_PC(EX_MEM_input[71]),.Stack_Flags(EX_MEM_input[72]),
                               .MR(EX_MEM_input[35]),.MW(EX_MEM_input[36]),
                               .State_Machine_Out(State_Machine_Out),.Machine_Stack(Machine_Stack),
                               .Stall_Signal(Stall_Signal));


    assign IsStackOp = EX_MEM_input[76] || Machine_Stack[1];
    assign StackOp = EX_MEM_input[77] || Machine_Stack[0];

    Handle_Stack stack(.Stack_Pointer(Stack_Pointer),.IsStackOp(IsStackOp),.StackOp(StackOp),.Stack_Pointer_Out(Stack_Pointer_Out),.NewSP(NewSP));


    assign Address = (IsStackOp)?Stack_Pointer_Out:EX_MEM_input[69:38];
    assign MW_Data = (State_Machine_Out == 2'b11)?{{13{1'b0}},EX_MEM_input[75:73]}:
                     (State_Machine_Out == 2'b10)?EX_MEM_input[31:16]:
                     (State_Machine_Out == 2'b01)?EX_MEM_input[15:0]:EX_MEM_input[15:0]; //74:43 

    Memory MEM (.Address(Address),.Write_Data(MW_Data),.Read_Data(MR_Data),.MW(EX_MEM_input[36])
 	,.MR(EX_MEM_input[35]),.clk(clk));

    Accumulator acc(.clk(clk),.flags(out_flags),.State_Machine_Out(State_Machine_Out),.in(MR_Data),.outPC(Accumulated_PC),
                    .Stack_PC(EX_MEM_input[71]),.Stack_Flags(EX_MEM_input[72]));

    assign outData = (!EX_MEM_input[70] && EX_MEM_input[35])?MR_Data:EX_MEM_input[15:0];

    assign MEM_Output[15:0] = outData; //data out
    assign MEM_Output[18:16] = EX_MEM_input[34:32]; //dst
    assign MEM_Output[19] = EX_MEM_input[37] ; //wb
endmodule