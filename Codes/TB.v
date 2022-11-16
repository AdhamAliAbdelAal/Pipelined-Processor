`include "ID_EX.v";
`include "ExecutionUnit.v";
`include "EX_MEM.v";
module TB();
    localparam CLK=5;
    localparam DELAY=2*CLK;
    reg [36:0] ID_EX_input;
    reg clk;
    wire [36:0] IDEXBuffer;
    wire [66:0] EX_MEM_input;
    wire [66:0] out;

    ID_EX IDEX(.DataIn(ID_EX_input), .Buffer(IDEXBuffer), .clk(clk));

    ExecutionUnit EXUNIT (.ALU(IDEXBuffer[33]), .ALUOperation(IDEXBuffer[32]), .Data1(IDEXBuffer[31:16]),
     .Data2(IDEXBuffer[15:0]), .DataOut(EX_MEM_input[63:32]), .Address(EX_MEM_input[31:0]));

    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(out), .clk(clk));
    assign EX_MEM_input[66:64] = IDEXBuffer[36:34];
    // WB|MW|MR|ALU|ALUOperation|Data1|Data2
    // WB|MW|MR|Data|Address
    initial begin
        $monitor("Input = %b, Output = %b ",IDEXBuffer,out);
        clk=1;
        #1;
        ID_EX_input={5'b10010,16'd11,16'd15};

        #DELAY;
        ID_EX_input={5'b10011,16'd11,16'd15};

        #DELAY;
        ID_EX_input={5'b00000,16'd11,16'd15};

        #DELAY;
        ID_EX_input={5'b10100,16'd11,16'd15};

        #DELAY;
        ID_EX_input={5'b11000,16'd11,16'd15};
    end

    always begin
        #CLK;
        clk=~clk;
    end


endmodule