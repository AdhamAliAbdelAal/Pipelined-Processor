.ORG 0
IN R6
ADD R1,R1
DEC R7
RTI
IN R5
.ORG 10
INC R5
LDM R6,9A
DEC R0
JZ R6
RET
DEC R7
.ORG 20
IN R1 ;32
LDM R7,1 ;33 - 34
LDM R2,10 ; 35 - 36
call R2 ;37
DEC R7
IN R0
INC R3
INC R0
Inc R0
INC R0
