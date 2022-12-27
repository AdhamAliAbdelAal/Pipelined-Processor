module MemoryUnit_TB ();

  localparam CLK=5;
	localparam DELAY=2*CLK;
	reg clk;

  reg [74:0]  EX_MEM_input;
  reg [2:0] Flags;
  wire [2:0] out_flags;
  wire [19:0] MEM_Output;
  //intermediate
  reg [31:0] address;
  reg [31:0] dataIn;
  wire Stall_Signal;


  //accumulated pc
  wire [31:0] Accumulated_PC;


  MemoryUnit mu(.EX_MEM_input(EX_MEM_input),.out_flags(out_flags),
                .Flags(Flags),.clk(clk),.Accumulated_PC(Accumulated_PC),.Stall_Signal(Stall_Signal),.MEM_Output(MEM_Output));

  initial begin
      $monitor("EX_MEM_input = %b Flags = %b Accumulated_PC = %b MEM_Output = %b",
              EX_MEM_input,Flags,Accumulated_PC,MEM_Output);
      clk=0;
      //memory write
      Flags = 3'b110;
      address = 32'd15;
      dataIn = 32'd3;
//  32bit_data|3bit_Dst|1bit_MR|1bit_MW|1bit_WB| 32bit_Address|1bit_JWSP|1bit_stackPC|1bit_stackFlags|1bit_isStackOp|1bit_StackOp   
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b1,1'b0,address,1'b0,1'b0,1'b0,1'b0,1'b0};
      #DELAY;
      //memory read
      Flags = 3'b110;
      address = 32'd15;
      dataIn = 32'd0;
      EX_MEM_input = {dataIn,3'b100,1'b1,1'b0,1'b0,address,1'b0,1'b0,1'b0,1'b0,1'b0};

      #DELAY;
      Flags = 3'b110;
      address = 32'd15;
      dataIn = 32'd125044;
      //int
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b1,1'b0,address,1'b0,1'b1,1'b1,1'b0,1'b0};
      #DELAY
      #DELAY
      #DELAY
      #DELAY
      //int
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b1,1'b0,address,1'b0,1'b1,1'b1,1'b0,1'b0};
      #DELAY
      #DELAY
      #DELAY
      #DELAY
      //reti
      EX_MEM_input = {dataIn,3'b100,1'b1,1'b0,1'b0,address,1'b0,1'b1,1'b1,1'b0,1'b0};
      #DELAY
      #DELAY
      #DELAY
      #DELAY

      //push 4 in memory
      Flags = 3'b110;
      address = 32'd0;
      dataIn = 32'd4;
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b1,1'b0,address,1'b0,1'b0,1'b0,1'b1,1'b0};
      #DELAY
      // pop from memory
      EX_MEM_input = {dataIn,3'b100,1'b1,1'b0,1'b0,address,1'b0,1'b0,1'b0,1'b1,1'b1};
      #DELAY
      // wb without memory
      dataIn = 32'd1;
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b0,1'b1,address,1'b0,1'b0,1'b0,1'b0,1'b0};
      #DELAY
      // call 
      Flags = 3'b010;
      address = 32'd15;
      dataIn = 32'd15;
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b1,1'b0,address,1'b0,1'b1,1'b0,1'b0,1'b0};
      #DELAY
      #DELAY
      #DELAY
      // ret
      EX_MEM_input = {dataIn,3'b100,1'b1,1'b0,1'b0,address,1'b0,1'b1,1'b0,1'b0,1'b0};
      #DELAY
      #DELAY
      #DELAY
      EX_MEM_input = {dataIn,3'b100,1'b0,1'b0,1'b0,address,1'b0,1'b0,1'b0,1'b0,1'b0};


      


  end



  always begin
        #CLK;
        clk=~clk;
    end
  
endmodule