`include "ID_EX.v"
`include "ExecutionUnit.v"
`include "EX_MEM.v"
`include "DecodingStage.v"
`include "DecodingStage.v"
`include "CU.v"
module Processor();
    localparam CLK=5;
    localparam DELAY=2*CLK;

    reg [31:0] IF_ID_input;
    wire [31:0] IFIDBuffer;

    wire [39:0] ID_EX_input;
    wire [39:0] IDEXBuffer;

    wire [69:0] EX_MEM_input;
    wire [69:0] EXMEMBuffer;
    reg clk;
    wire immediateSelector;

    IF_ID IFID (.DataIn(IF_ID_input), .Buffer(IFIDBuffer), .clk(clk));

    CU CTRLUNIT (.In(IFIDBuffer[31:29]), .WB(ID_EX_input[36]), .Alu(ID_EX_input[33]), .MR(ID_EX_input[34]), .MW(ID_EX_input[35]), .AluOp(ID_EX_input[32]),.Imm(immediateSelector));

    DecodingStage DECSTAGE (.immediate(IFIDBuffer[15:0]), .write_back(EXMEMBuffer[66]), .read_data1(ID_EX_input[31:16]), .alu_input2(ID_EX_input[15:0]),  .write_data(EXMEMBuffer[47:32]), .clk(clk),
    .src_addr(IFIDBuffer[20:18]),.dst_addr(IFIDBuffer[23:21]),.write_addr(EXMEMBuffer[69:67]), .category(immediateSelector));

    ID_EX IDEX(.DataIn(ID_EX_input), .Buffer(IDEXBuffer), .clk(clk));

    ExecutionUnit EXUNIT (.ALU(IDEXBuffer[33]), .ALUOperation(IDEXBuffer[32]), .Data1(IDEXBuffer[31:16]),
    .Data2(IDEXBuffer[15:0]), .DataOut(EX_MEM_input[63:32]), .Address(EX_MEM_input[31:0]));

    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(EXMEMBuffer), .clk(clk));

    assign EX_MEM_input[66:64] = IDEXBuffer[36:34];
    assign ID_EX_input[39:37]=IFIDBuffer[23:21];
    assign EX_MEM_input[69:67]=IDEXBuffer[39:37];

    // WB|MW|MR|ALU|ALUOperation|Data1|Data2
    // WB|MW|MR|Data|Address
    initial begin
        $monitor("IFIDBuffer = %b, IDEXBuffer = %b , EXMEMBuffer = %b ",IFIDBuffer,IDEXBuffer,EXMEMBuffer);
        clk=1;
        IF_ID_input={8'b00101000,3'b000,3'b000,18'd15};

        #DELAY
        
        IF_ID_input={8'b10101000,3'b111,3'b000,18'd13};

        #DELAY
        
        IF_ID_input={8'b10101000,3'b111,3'b000,18'd13};

        #DELAY
        
        IF_ID_input={8'b00101000,3'b111,3'b000,18'd13};

        #DELAY
        
        IF_ID_input={8'b10101000,3'b111,3'b000,18'd13};

        #DELAY
        
        IF_ID_input={8'b10101000,3'b111,3'b000,18'd13};
        

        #DELAY;
        
        IF_ID_input={8'b01101000,3'b111,3'b000,{18{1'b0}}};

        #DELAY
        
        IF_ID_input={8'b10101000,3'b111,3'b000,18'd13};

        #DELAY
        
        IF_ID_input={8'b10101000,3'b111,3'b000,18'd13};

        #DELAY;
        
        IF_ID_input={8'b10001000,3'b101,3'b111,{18{1'b0}}};

        #DELAY;
        
    end

    always begin
        #CLK;
        clk=~clk;
    end


endmodule