
module MEM_TB();
    localparam CLK=5;
    localparam DELAY=2*CLK;
    reg [70:0]  EX_MEM_input;
    reg clk;
    wire [70:0] MEM_Buffer;
    wire [19:0] MEMOut;
    wire [19:0] out;
   wire [31:0] MR_Data;
    EX_MEM EXMEM(.DataIn(EX_MEM_input), .Buffer(MEM_Buffer), .clk(clk));

    Memory MEM (.Address(MEM_Buffer[69:38]),.Write_Data(MEM_Buffer[15:0]),.Read_Data(MR_Data),.MW(MEM_Buffer[36])
 	,.MR(MEM_Buffer[35]),.clk(clk));

    Mux_WB Mux(.Read_Data(MR_Data[15:0]),.data(MEM_Buffer[15:0]),.Out(MEMOut[15:0]),.MR(MEM_Buffer[35]));
    MEM_Out Memory_Out(.DataIn(MEMOut), .Buffer(out), .clk(clk));
    assign MEMOut[18:16] = MEM_Buffer[34:32];
    assign MEMOut[19] = MEM_Buffer[37];
    initial begin
        $monitor("Input = %b, Output = %b ",MEM_Buffer,out);
        clk=0;
        #1;
        EX_MEM_input={1'b0,32'b01000001010101010100010101010101,1'b0,1'b1,1'b0,3'b110,32'b01011101010101010100010111010111};

        #DELAY;
        EX_MEM_input={1'b0,32'b01000001010101010100010101010101,1'b0,1'b0,1'b1,3'b110,32'b01000001010101010100010101010101};
	
	#DELAY;
        EX_MEM_input={1'b0,32'b01000001010101010100010101010101,1'b1,1'b0,1'b0,3'b110,32'b01000001010101010100010111010101};
        
        #DELAY;
        EX_MEM_input={1'b0,32'b01000001010101010100010101010101,1'b0,1'b0,1'b1,3'b110,32'b01000001010101010100010101010101};
        
       

      
    end

    always begin
        #CLK;
        clk=~clk;
    end


endmodule