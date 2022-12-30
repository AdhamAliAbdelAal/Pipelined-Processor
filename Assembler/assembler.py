from opCodes import *
def main():
    open('ins_mem.txt', 'w').close()
    f = open("ins_mem.txt", "a")
    with open("code.asm",'r') as openfileobject:
        for (i,line) in enumerate(openfileobject):
            line=line.upper()
            first_split=line.split(' ')
            ins=first_split[0]
            if(ins=='.ORG'):
                imm=int(first_split[1][:-1],16)&((1<<32)-1)
                opCode=(f'{imm:032b}')
                f.write('1'+opCode+'\n')
            opCode=''
            if ins in instructions:
                opCode=instructions[ins]
            if(len(opCode)==8):
                if(len(first_split)>1):
                    second_split=first_split[1].split(',')
                if(opCode[:2]=='00'):
                    reg1=second_split[0]
                    opCode+=registers[reg1]
                    reg2=second_split[1][:2]
                    opCode+=registers[reg2]
                    opCode+=('0'*2)
                elif(opCode[:2]=='01'):
                    reg1=second_split[0]
                    opCode+=registers[reg1]
                    opCode+=('0'*5)
                    f.write(opCode+'\n')
                    imm=int(second_split[1][:-1],16)&65535
                    print(imm)
                    opCode=(f'{imm:016b}')
                elif(opCode[:2]=='10'):
                    reg1=second_split[0][:-1]
                    opCode+=registers[reg1]
                    opCode+=('0'*5)
                elif(opCode[:2]=='11'):
                    opCode+=('0'*8)
                f.write(opCode+'\n')
    f.close()


main()