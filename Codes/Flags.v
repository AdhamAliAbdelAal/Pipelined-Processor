module Flags(
    flags, flags_out,
    operand1, operand2, result
);
    input[15:0] operand1, operand2;
    output [15:0] result;
    input [2:0] flags;
    output [2:0] flags_out;
    assign {flags_out[1], result} = operand1>>operand2;
endmodule