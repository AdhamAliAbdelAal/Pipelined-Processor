.ORG 0
LDM R6,F0
LDM R5,2
JZ R5
RTI
IN R5
.ORG 20
IN R2 ;20
LDM R1,26 ;21
LDM R3,27 ;23
INC R5 ;25
JN R3 ;26
ADD R0,R2 ;27
ADD R4,R2 ;28
