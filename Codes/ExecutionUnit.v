module ExecutionUnit(
    ALU, ALUOperation, Data1, Data2, DataOut, Address
);
    input ALU;
    input [15:0] Data1, Data2;
    input ALUOperation;
    output [31:0] DataOut, Address;
    wire [15:0] ALUResult;
    assign ALUResult = (ALU==1'b1)?((ALUOperation == 1'b0) ? Data1 + Data2 : ~Data1) : Data2;
    assign DataOut = {{16{ALUResult[15]}}, ALUResult};
    assign Address = {{16{Data1[15]}}, Data1};
endmodule