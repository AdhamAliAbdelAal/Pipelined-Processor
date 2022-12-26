module Decode_TB( );

    localparam CLK=5;
    localparam DELAY=2*CLK;
    localparam MEMDELAY=5;

    wire [47:0] IF_ID_input;
    wire [47:0] IFIDBuffer;

    reg [90:0] ID_EX_input;
    wire [90:0] IDEXBuffer;

    wire [19:0] MEM_WB_input;
    wire [19:0] MEMWBBuffer;

    /*IF/ID Buffer*/
    IF_ID IFID(.DataIn(IF_ID_input), .Buffer(IFIDBuffer), .clk(clk));

    /*Decoding Stage*/
    DecodingStage DECSTAGE (.write_back(MEMWBBuffer[19]), .read_data1(ID_EX_input[24:9]), .alu_input2(ID_EX_input[40:25]),  .write_data(MEMWBBuffer[15:0]), .clk(clk), .src_addr(IFIDBuffer[4:2]),.dst_addr(IFIDBuffer[7:5]),.write_addr(MEMWBBuffer[18:16]));

    
endmodule