;First Jc not taken due to CLRC
;Second, Third, JC taken
;SETC, CLRC, Regular Operations Tested -> JC
LDM R0,0 ;32
LDM R3,44 ;34
LDM R5,48 ;36
LDM R7,FFFF ;38
LDM R6,4B ;3A
LDM R2,47    ;3C
MOV R0,R7 ;3E
INC R0    ;3F
CLRC      ;40
JC R3     ;41
STD R6,R6 ;42
MOV R4,R0 ;43
INC R7 ;44
JC R5 ;45
INC R6 ;46
JMP R6 ;47
SETC ;48
JC R2 ;49
INC R1 ;4A
MOV R1,R7 ;4B