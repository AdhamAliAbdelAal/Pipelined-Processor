#this is a comment 
# all numbers are in hexadecimal
#the reset signal is raised before this code is executed and the flags and the registers are set to zeros.
.ORG 0
LDM R1,15 #R1=00000015
ADD R1,R4
STD R4,R1
RTI
.ORG 20
LDM R2,19 #R2=00000019 add 19 in R2
LDM R3,F #R3=0000000F
LDM R1,5 #R1=5
PUSH R1 #SP=000007FE,M[000007FF]=5
PUSH R2 #SP=000007FD,M[000007FE]=19
POP R1 #SP=000007FE,R1=00000019
POP R2 #SP=000007FF,R2=00000005
STD R3,R1  #M[0000000F]=00000019
LDD R5,R3  #R5=M[0000000F]
