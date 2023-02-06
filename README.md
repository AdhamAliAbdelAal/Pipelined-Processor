<div align= >

# <img align=center width=75px  src="https://media0.giphy.com/media/idjnnqxEInAPn8elMd/giphy.gif?cid=790b761139e83663458cbb2b9508ae1ad8b5f85fab058fe7&rid=giphy.gif&ct=s"> Pipelined Processor



</div>
<div align="center">
   <img align="center"  width="650px" src="https://cdn.dribbble.com/users/1366606/screenshots/8075231/dribbble-003.gif" alt="logo">

   
</div>
 
<p align="center"> 
    <br> 
</p>

## <img align= center width=50px height=50px src="https://thumbs.gfycat.com/HeftyDescriptiveChimneyswift-size_restricted.gif"> Table of Contents

- <a href ="#about"> 📙 Overview</a>
- <a href ="#started"> 🚀 Get Started</a>
- <a href ="#memory">💾 Memory units and register description</a>
- <a href ="#isa">💻 ISA specifications</a>
- <a href ="#design">🧱 Design</a>
- <a href ="#contributors"> ✨ Contributors</a>
- <a href ="#license"> 🔒 License</a>

<hr style="background-color: #4b4c60"></hr>

## <img align="center"    height =50px src="https://user-images.githubusercontent.com/71986226/154076110-1233d7a8-92c2-4d79-82c1-30e278aa518a.gif"> Overview <a id = "about"></a>

<ul>
<li>
It is required to design, implement and test a Harvard (separate memories
for data and instructions), RISC-like, five-stages pipeline processor, with the specifications as described in the following sections
</li>
<li>
<a href="https://github.com/AdhamAliAbdelAal/Pipelined-Processor/blob/master/Docs/Architecture_Project_Fall_2022_Semester.pdf">Project Description</a>
</li>
<li>Built using:
<ol>
<li>
<a href="https://en.wikipedia.org/wiki/Verilog">Verilog</a>
</li>
<li>
<a href="https://www.python.org/">Python</a>
</li>
</ol>
</li>
</ul>

<hr style="background-color: #4b4c60"></hr>

## <img  align= center width=50px height=50px src="https://c.tenor.com/HgX89Yku5V4AAAAi/to-the-moon.gif"> Get Started <a id = "started"></a>

<ol>
<li>Clone the repository

<br>

```sh
git clone https://github.com/AdhamAliAbdelAal/Pipelined-Processor
```

</li>
<li>Put your test cases in "code.asm"

<br>

```sh
 cd './Assembler/code.asm'
```
</li>
<li>Run

<br>

``` sh
python ./Assembler/assembler.py
```
</li>
<li>Main file is

<br>

```sh
 cd './Codes/Processor.v'
```
</li>
<li>There are more test cases in folder

<br>

```sh
 cd './Assembler/TestCases'
```
</li>
</ol>

<hr style="background-color: #4b4c60"></hr>


## <img align="center"   height =70px src="https://media4.giphy.com/media/28aHBTsyyuOSweunHR/200w.webp?cid=ecf05e4730rzgakmz1fmie707qdqtk83x7q0cvj030f7sa7k&rid=200w.webp&ct=s"> Memory units and registers description <a id = "memory"></a>


<ul>
<li>In this project, we apply a Harvard architecture with two memory units; Instructions’ memory and Data
memory.</li>
<li>The processor in this project has a RISC-like instruction set architecture. There are eight 2-bytes general 
purpose registers[ R0 to R7]. These registers are separate from the program counter and the stack pointer 
registers.</li>
<li>The program counter (PC) spans the instructions memory address space that has a total size of 2
Megabytes. Each memory address has a 16-bit width (i.e., is word addressable). The instructions memory 
starts with the interrupts area (the very first address space from [0 down to 2^5 -1]), followed by the 
instructions area (starting from [2^5
and down to 2^20]) as shown in Figure.1. By default, the PC is initialized 
with a value of (2
5
) where the program code starts.</li>
<li>The other memory unit is the data memory, which has a total size of 4 Kilobytes for its own, 16-bit in width
(i.e., is word addressable). The processor can access both memory units at the same time without having 
a memory access hazard.</li>
<li>The data memory starts with the data area (the very first address space and down), followed by the stack 
area (starting from [2^11 − 1 and up]) as shown in Figure.1. By default, the stack pointer (SP) pointer points 
to the top of the stack (the next free address available in the stack), and is initialized by a value of (2^11 -1).</li>
<li>When an interrupt occurs, the processor finishes the currently fetched instructions (instructions that 
have already entered the pipeline), save the processor state (Flags), then the address of the next 
instruction (in PC) is saved on top of the stack, and PC is loaded from address 0 of the memory where 
the interrupt code resides. </li>
<li>For simplicity reasons, we will have only one interrupt program, the one which starts at the top of the 
instruction’s memory, but be aware of possible nested interrupts i.e., an interrupt might be raised while 
executing an interrupt, and your processor should handle all of them successfully. </li>
<li>To return from an interrupt, an RTI instruction loads the PC from the top of stack, restores the processor 
state (Flags), and the flow of the program resumes from the instruction that was supposed to be fetched 
in-order before handling the interrupted instruction. Take care of corner cases like Branching </li>

</ul>

<div align="center">
<img  width="600" src="https://user-images.githubusercontent.com/71986226/216997486-e7cac8db-9c95-4880-aecd-fd19566ce8f5.png">
</div>
<div align="center"  ><hr width="60%">
</div>

## <img align="center"   width =70px src="https://media4.giphy.com/media/1eoXMKiRHoCvBZJdDp/giphy.gif?cid=ecf05e47avae43djml307ggcnazgjn5fc6x7ljf2y3zvl0b1&rid=giphy.gif&ct=s"> ISA specifications <a id = "isa"></a>

<ul>
<li>
Register
<ul>
<li>R[0:7]<15:0> : Eight 16-bit general purpose registers</li>
<li>PC<31:0> : 32-bit program counter</li>
<li>SP<31:0> : 32-bit stack pointer</li>
<li>CCR<3:0> : condition code register that can be divided to
<ul>
<li>Z<0>:=CCR<0> : zero flag, change after arithmetic, logical, or shift operations</li>
<li>N<0>:=CCR<1> : negative flag, change after arithmetic, logical, or shift operations
</li>
<li>C<0>:=CCR<2> : carry flag, change after arithmetic or shift operations.</li>
</ul>

</li>
</ul>
</li>
<li>
Input-Output
<ul>
<li>IN.PORT<15:0> : 16-bit data input port</li>
<li>OUT.PORT<15:0> : 16-bit data output port</li>
<li>INTR.IN<0> : a single, non-maskable interrupt</li>
<li>RESET.IN<0> : reset signal</li>
</li>
</ul>
<li>
Other registers to hold the operands and opcodes of the instructions
<ul>
<li>Rsrc : 1st operand register</li>
<li>Rdst : 2nd operand register and result register field</li>
<li>Imm : Immediate Value</li>
</li>
</ul>
<li>
Instructions (some instructions will occupy more than one memory location)
</li>
<br>
<table align="center">
<tr  align="center">
<th  align="center">Mnemonic</th>
<td  align="center"><strong>Function</strong></td>
</tr>
<tr>
<td align="center" colspan="2" height="50"><strong>👆 One Operand</strong></td>
</tr>
<tr>
<td>🔶 NOP</td>
<td>PC ← PC + 1</td>
</tr>
<tr>
<td>🔷 SETC</td>
<td>C ← 1</td>
</tr>
<tr>
<td>🔶 CLRC</td>
<td>C ← 0</td>
</tr>
</tr>
<tr>
<td>🔷 NOT Rdst</td>
<td>
<ul>
<li>NOT value stored in register Rdst</li>
<li>R[ Rdst ] ← 1’s Complement(R[ Rdst ])</li>
<li>If (1’s Complement(R[ Rdst ]) = 0): Z ←1; else: Z ←0</li>
<li>If (1’s Complement(R[ Rdst ]) < 0): N ←1; else: N ←0</p>
</ul>
</td>
</tr>
<tr>
<td>🔶 INC Rdst</td>
<td>
<ul>
<li>Increment value stored in Rdst</li>
<li>R[ Rdst ] ←R[ Rdst ] + 1</li>
<li>If ((R[ Rdst ] + 1) = 0): Z ←1; else: Z ←0</li>
<li>If ((R[ Rdst ] + 1) < 0): N ←1; else: N ←0</li>
</ul>
</td>
</tr>
<tr>
<td>🔷 DEC Rdst</td>
<td>
<ul>
<li>Decrement value stored in Rdst</li>
<li>R[ Rdst ] ←R[ Rdst ] – 1</li>
<li>If ((R[ Rdst ] - 1) = 0): Z ←1; else: Z ←0</li>
<li>If ((R[ Rdst ] - 1) < 0): N ←1; else: N ←0</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 OUT Rdst</td>
<td>OUT.PORT ← R[ Rdst ]</td>
</tr>
<tr>
<td>🔷 IN Rdst</td>
<td>R[ Rdst ] ←IN.PORT</td>
</tr>
</tr>
<tr>
<td align="center" colspan="2" height="50"><strong>✌️ Two Operand</strong></td>
</tr>
<tr>
<td>🔷 MOV Rsrc, Rdst</td>
<td>Move value from register Rsrc to register Rdst</td>
</tr>
<tr>
<td>🔶 ADD Rsrc, Rdst</td>
<td>
<ul>
<li>Add the values stored in registers Rsrc, Rdst and store the result in Rdst</li>
<li>If the result =0 then Z ←1; else: Z ←0;</li>
<li>If the result less than 0 then N ←1; else: N ←0 </li>
</ul>
</td>
</tr>
<tr>
<td>🔷 SUB Rsrc, Rdst</td>
<td>
<ul>
<li>Subtract the values stored in registers Rsrc, Rdst and store the result in Rdst</li>
<li>If the result =0 then Z ←1; else: Z ←0;</li>
<li>If the result less than 0 then N ←1; else: N ←0 </li>
</ul>
</td>
</tr>
<tr>
<td>🔶 AND Rsrc, Rdst</td>
<td>
<ul>
<li>AND the values stored in registers Rsrc, Rdst and store the result in Rdst</li>
<li>If the result =0 then Z ←1; else: Z ←0;</li>
<li>If the result less than 0 then N ←1; else: N ←0 </li>
</ul>
</td>
</tr>
<tr>
<td>🔷 OR Rsrc, Rdst</td>
<td>
<ul>
<li>OR the values stored in registers Rsrc, Rdst and store the result in Rdst</li>
<li>If the result =0 then Z ←1; else: Z ←0;</li>
<li>If the result less than 0 then N ←1; else: N ←0 ;</li>
</ul>
</td>
</tr>
</tr>
<tr>
<td>🔶 SHL Rsrc, Imm </td>
<td>
<p>Shift left Rsrc by #Imm bits and store result in same register
<strong>
Don’t forget to update carry</strong></p>
</td>
</tr>
<tr>
<td>🔷 SHL Rsrc, Imm </td>
<td>
<p>Shift right Rsrc by #Imm bits and store result in same register
<strong>Don’t forget to update carry</strong>
</p>
</td>
</tr>
<tr>
<td align="center" colspan="2" height="50"><strong>💾 Memory Operations</strong></td>
</tr>
<tr>
<td>🔶 PUSH Rdst </td>
<td>X[SP--] ← R[ Rdst ]</td>
</tr>
<tr>
<td>🔷 POP Rdst </td>
<td>R[ Rdst ] ← X[++SP]</td>
</tr>
<tr>
<td>🔶 LDM Rdst, Imm </td>
<td>Load immediate value (15 bit) to register Rdst
R[ Rdst ] ← Imm<15:0>
</td>
</tr>
<tr>
<td>🔷 LDD Rsrc, Rdst </td>
<td>Load value from memory address Rdst to register Rdst
R[ Rdst ] ← M[Rsrc]; </td>
</tr>
<tr>
<td>🔶 STD Rsrc, Rdst </td>
<td>Store value in register Rsrc to memory location Rdst
M[Rdst] ←R[Rsrc]; </td>
</tr>
<tr>
<td align="center" colspan="2" height="50"><strong>🦘 Branch and Change of Control Operations</strong></td>
<tr>
<td>🔷 JZ Rdst </td>
<td>
<ul>
<li>Jump if zero</li>
<li>If (Z=1): PC ←R[ Rdst ]; (Z=0)</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 JN Rdst  </td>
<td>
<ul>
<li>Jump if negative</li>
<li>If (N=1): PC ←R[ Rdst ]; (N=0)</li>
</ul>
</td>
</tr>
<tr>
<td>🔷 JC Rdst </td>
<td>
<ul>
<li>Jump if negative</li>
<li>If (C=1): PC ←R[ Rdst ]; (C=0)</li>
</ul>
</td>
</tr>
<tr>
<td>🔶 JMP Rdst</td>
<td>
<ul>
<li>Jump</li>
<li>PC ←R[ Rdst ]</li>
<ul>
</td>
</tr>
<tr>
<td>🔷 CALL Rdst </td>
<td>(X[SP] ← PC + 1; sp-2; PC ← R[ Rdst ]) </td>
</tr>
<tr>
<td>🔶 RET </td>
<td>sp+2, PC ←X[SP]</td>
</tr>
<tr>
<td>🔷 RTI  </td>
<td>sp+2; PC ← X[SP]; Flags restored</td>
</tr>
<tr>
<td align="center" colspan="2" height="50"><strong>💻 Input Signals</strong></td>
</tr>
<tr>
<td>🔶 Reset </td>
<td>PC ←2
5h //memory location of the first instruction</td>
</tr>
<tr>
<td>🔷 Interrupt  </td>
<td>X[Sp]←PC; sp-2;PC ← 0; Flags preserved</td>
</tr>
</table>
</ul>

<hr style="background-color: #4b4c60"></hr>



## <img align="center"    width=70px height=70px src="https://user-images.githubusercontent.com/71986226/178469374-15498392-26a1-4ba0-99d7-9ce899c131f0.gif"> Design <a id = "design"></a>

<ul>
<li>You can view <a href="https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1#R7X1bc9tGnu9nOQ%2Bq2nlQV98vj5Ht7GQ3nknZyXjmvGzREi3xRBJ1SHrs5NNvN8kGge4G0CC7AVCEk7Iskg2S%2BN9%2B%2F%2FsVefP0%2FT9Xs5eH98u7%2BeMVhnffr8jbK4wxElz%2FMI%2F8sX9EELl75H61uNs9hg4PfFz8Od8%2FCPePfl3czdeVF26Wy8fN4qX64O3y%2BXl%2Bu6k8Nlutlt%2BqL%2FuyfKy%2B68vsfu498PF29ug%2F%2Bmlxt3nYPSqxODz%2B1%2Fni%2FsG%2BM%2BJq98zTzL54%2F03WD7O75bfSQ%2BTdFXmzWi43u389fX8zfzR3z96X3bkfa54tPthq%2FryJOcD%2B%2FOvbL%2F9499s%2F%2Fnqz%2FvTfn9fy9re%2FXe%2Bv8u%2FZ49f9F95%2F2M0f9g6sll%2Bf7%2BbmIvCK3Hx7WGzmH19mt%2BbZb5ro%2BrGHzdOj%2Fg2Zfy5Xiz%2BXz5vZ4%2F71%2Fqe0bzlfbebfSw%2FtP%2FV%2FzpdP883qD%2F2S%2FbOEcAoQ3R3b8xEVQO0f%2BXYgC93f6ocSRTDBGMA9G8723HBfvMnhhul%2F7O9Zh%2Fvn3675neaf%2Fa%2FL1eZheb98nj2%2BOzx6U72hh9f8vFy%2B7G%2Fj%2F5tvNn%2FshWH2dbOs3uT598Xmn%2BY4YPvf%2FrW%2FmPn32%2B%2FlX%2F6wvzzrr%2FvP8i%2F%2FOlzB%2FHo4tv3Nnvuiibn%2FIIZG9fRcL7%2BubucNt4rspXe2up9vGl7H97QyN7KRPVbzx9lm8e%2BqoCanMAlICH%2FUX%2BBm%2FTJ7rtCe%2F%2F%2BvRphvbpePy9UV%2BcF8xvvP%2F6GZUr81tD%2F%2Bsr2L0NzY6y%2Bzp8XjH7uX%2FnX%2B%2BO%2F5ZnE7Kz2%2F3t558yzCL9%2FLT%2Bze1DzzvFw9GXErnvv3bLWY6Z%2BPi%2FvZ5uvKaM%2FG193OXupe8m0vSOZJCnfyDB81c85X1%2Frr3y6e7%2F2Ty9XLw%2Bx5f8kdz0At6pvrhWb75%2F3VoP0622c2K33gi76GvdrzfPesFu6tCi9d6ttydVd98%2BJa%2BvN%2B%2Fn2hL2euud6slr%2FPr%2FfqofK6z7Pb3%2B%2B3Ynjt0AoztiNT%2BR9%2FKX3Su%2FntcqXZbvl8vXlY3P7%2BPF%2FvP97iebFZ2HvgvrZEr8bXlT5O5XVfHpezjXtz7hbrl8fZH%2Fbljwv9BIb%2FZ%2FH0opXKzNzpmwNT6n%2Fdm59aTuDNYqP%2F%2FunvHywra8nYcfPuNZ5SMx%2BzXfmXdAUyemWmOfBZ%2F3KrqT7X3%2BrmbrHSNlp%2FT3N8vjaX%2FPK4ePmH1TX633%2FdX2u13Mz2r8QimSFhDAimij%2ByYlMEBIp4NoVDwIlvVgjVqjOPxqG1GuezJdBP%2BtEf3%2F2zRL7PbbQr0WknGW92rPZ2z09fFo%2BPzkMe%2Fcyt1grq8Yf9E0%2BLu7utSQsxRtXMpSHfAQdUKBQgD8xEHNYOmObPdz8Y5Hm4kaV7X70rB6sMIK0aZq5wi2ne%2FvbLfLXQ38yQp%2Fk%2Bt5rT0h1lgTtqH4u2uvt3%2BGW5eN6UiEghc8Ec0gjNojl7pR2c2B8uo1r3eoQHrkcAlLD443zIHQLxLr1lh%2BJ%2BHM8hfAIME2B4pYDh0wQYynqGISDlCBCDmIxScqOEIQFSHYwITGigtG4EEB%2FYSuFeLZT0uWOcQYty8KEpiIHbohi1DNgatdhH81qjFgxHcvSprKo4B9xhJ4kBgpIJRLH5m4le2UlNgGcCPK8S8Pxdkx3Dj%2FNHDUKWq%2FWlgR8MAVJVTaNtmdV0JdOMCAJY9gp5bH5owjzHYx4DcCrkJRrQMlrCJUdDnuCluTxcWfRro1Ao0TUZqclInauRIjsjZezTDz%2F%2FtrVVl2aeiNTKqqpkFALQDxArBqDo1zrhyTqdap0oQCUXWVQITbWBQfJo69R2aYJqbWBuO0XO0TfHZR5FVQbN55rboEp7RUFPvjlVyPPNFRYa93TNRWjFMPuj9LIX84J1k7hI752ZliAum0UhcAwhKtrOUakBf%2Fs5%2FY%2FdF0krIvX50QnKTVDu%2FKDcId6wRXKXBeIaEyxUFipl2AQLmtL%2B6TMsjCjAjw8xBK8n8WDIjQ%2BC3GpQl8gIu0Qk7BK9wS4JK4wgBIwifWeUxVT1jZh0Sq7bDsiWA1SiEw%2BItgPezep6gO7FLi%2FIC6W0J5A3gbxzBXm4AHk%2Fvp0wXlmHclyE8YbFeHLCeMkxHkeaYA7FTsF45nrlNJLT15Mb46khMF59FUyp8OVfZQyYHPPZHrZWzKeJ1hPoQ36sDcODu5g8wMaqYWLOKyio%2FYCVsqywCYey4hNsmmDTucIm41XbPOfdbDMzvHVp8IlygKu6hwqAfcgklHH7%2B4RMOFRVMUGm0yCTgGnDYuZ60k939gSZQhwxzoTmELAqticay%2BSw6jTBn7qiJ5zxynEGvjicQdx6KkElwDwaaDCQT%2BGEkv4T0jgNaUjtQiNSW5tyCugwl8bci%2Fn1BTrYuYAOVysM0OGEY%2FN5yGZUs%2Fc4Maa0KuJcSCy4sG9rAymKMiAgi%2BKo7ik%2B4iTgFGtmfvcAgZg5PJ0j0DNMtvkIDq8Om7jCe31TPGOnark2ElfVdF%2BIPFYYME0%2BpijMYJjwKoNd58puU4vqY1nfPXDdlg5HTiq5%2BwFEmk%2FoT918IpM4TunqyR96Tf5Qqb3k7Xpbmnh3tzJf4sJ8IowAq20VkEIA7uPncmMkVgCqgKuUMSY7pbHTe0qKU0BRFk%2FJXNrNkOd2jwZJY4fBo32mJSbbtbzxFNR5PHok0WnyTOjxiLR2FS4hy9sNeW0HYOmH8gMs4ie2D2Xz7z%2FU2Z%2BBh97lsUkcejpEEsB5kyEK6Uui3WhZz1CnTU31M4Mlen26KHoxCEg1hIEg54Bij0pcABpCC7mmFxPcQKVPtajuVVKJVrEdQpSAQFlimEJYAKFyESmUa5sAXbJeYgQp9crGEjUTb68tca%2Fojkypkrz8grRTmKn5fHtt0jO%2FTL1tKfjF7YZW4kQmCVywb84YOMmA4x3F2hrpa82GiDl8yGhSPmz3C6NTbFb2cmcVuAaVbvk0RfnKp5lfrY2waB9QEDqnJG47x6hKdo6R0ASHuitwlOMKhPUzW4H4eYyDQ%2FBf73%2Fx9MGr9ghoUWVbsKypcfEb0iWzFbq9%2BdcjmuF6pGbubU4MjY3K7fOd%2BXtXMPO1k8zXvEIDGgURRlrHvITOlT5nrRYlwh8P45%2FLpMIGDm6nAC1O8U9rtDsxXIkWGMRikfipEJtjv9sL44x4JTAYiQjYjlf8c%2BXPWWvzpel3bT2XR2JoU2z942XZfIYAlLXeuX4e0OigYLawLUUeTSbjX3evcKzx78nzIkJKoDBjkEH9G3b9fJGxiVVQX6tR0ooDgudEBA6AgTFx%2FrlMWg03arW%2FX5ZeowQgR5lRREPKTKJiF1NFmcniAun12ZThSBCBLPf4McduIQIc4nWKRbZcWtIodZVMsqcER2Z2UdDGM5Kzi7406ZldpvxGCnYhtaiYyhPZpfnSfbPLiDorjiuOywimo%2FMYdgB6bjTNhL8OSWqsYtY%2FYqohDuQ4bkZQ56CaDIBixltDBMFzwovvB76pHwI59pzslpCAoXvccIVMgN7PTeCrokr9x8fZ%2FVVlV88FoXtnBiRitLoAdS%2BM5cJ009kb2tiTLWYxcMJCHD%2FZ%2Fnh9aQ1w9oSC8BMKTBJgAvG7lXC059IBOqYofDdylwCe6KnrkMUG3HsbqRtgKCyERvb4sGawV4ZifpDa9iIZAlZYzTYzOc1xWO07u9xmp%2BrY9d3lavqa1g%2BzF%2FPPjVbu8z%2BX5iPfvJTwfPF4CeS3dkEtvs%2FvbAPCVbXpSbOOUdk36%2F3TCO%2BYMoHZ0CohUJNBgSKetcA04F1whADJFRJiIwpxH6s%2B%2BkLldiFf%2B47SvmYzEr9qh6Nj9qAk0x5%2BMLiz9sA12uP9b%2F88E%2B3BUgFO6Wc5KQyuakChuARmsFjIlV5z1I%2BmiiY1rCG12bFWmQvUSO1xeBxl%2FaTyWQ6mVNHGWF69Fuo7grlIHwoMpyQ9mkgfAg0CA%2BZPieqX9H6QF54BVXIqZFazO6dPqnCPKj6uGx9VGp3%2B06jCJAbQV5P9UiU0rKR%2FsH0C4JWxgDd5l%2FVpN94fzXBJ4iB4NRk4CllQHklMJHms4eMMZKGh0koiQha9V8pwP%2BDzYb7%2B%2Bri5bNIwwgHy%2FejBqHQ2cZpSWLfbeOd06QC7h7Z9Ye247Jb93FP0JIlUh5I1GLdIdf%2BBFO4HUs4BreSkkmijUr%2B61w93nIPPm8o4BgjEFQ8FofqlyjnOHm5sP8qXubB2rr2eiPbUmscY9Lhqu5BjsNQF92Mok%2FE9WmswGGjPljTkhw5gcf3AzDko9FSkQZB4Cp0MHyLgFx21CVHFWF6Kx4ODRjTOMtriuvPN%2Byo1ssPDB%2FBBaywuFL7FZccUC3Su4FW%2BLVAEd6iMDV1BmN73fitjhR8q6woREKuBCD%2F97ZffftUv%2BOXvH36NxQpV2YqfAb3VWSEQ8LBcLf7UrzNzrpv5v4P%2FEMjOCCWAiNNm2J3Cn0ydCd%2B6jFSd1TkMGZeV2ALIVvVF8LhiaPaDTzA%2BifCqQBkC4qCkd0OwZLtewcMlCAFbIZ%2Be7H4QDZ4Dpk8VpAnRiUlABi5MEIHQ2QWB%2BhBZMMKD14sIv4oHXbi0YEmDqVjcJ1kCZTyXJS3KG8hHRyAtYgigWL%2BxDjBVaYjWZhWmnVyVvXBdYeYJoPYJGGXSQgtSvWiNLxpow%2FTbPqkg3qiXms7prr5t6O0YIl18W%2BkX8Z9%2BBe1gtzbIBongHsvkSXdbnnP7OFuvF7dVAanVR6ixcWckzf6aJwMTzPjRA9KDNk0%2FZGInxZ9%2BO%2FztpP4cZeLnWyHezJ1d8rJ%2BPM%2FMrh7aWspQkOzSRNvDMUibIFRabOXmtjqIeeDaOHaSWSrRlihA5ESiDSfRFsInMqUA%2BZGWfkU7FFtziNIpJp0j3swExoBgBzsdFoUwQP3G21DfLeECwFxjGiTxleJ5BZ%2FbPI7ozHUPo2sQkNQZkGUkjLMDlzjuRqw%2BZsoo39JgJcceU2A69oo%2FcU5NZydk%2ByFco6B6QfJ2Jt1AG3mnxbvT4t2jFu8mS9z%2B3x9r8colrfBlAjaZXcaLRTvlGajBhG9RiZTe6k4jCk%2B2pVUqV62qBlIFuupsSV3c5l%2Ba8YMllT07PCOaVpim2rh12cFwgE35ay0w5RqMlyKiOIr8IQaGBgyG1ZQZyozVIWKWKWYs%2FXHd5p3bBgyGjtH2uYTBu9nPbHAZ6oCewOEEDi8FHP5tAoft4NDs9bA51iHBYbec1AQOO4JDQhwTngUnmneJwwbJjNw5lsU3QMOja%2BKHwIWEyGK5RlosSCEBCB4ihDiKXbtjQeh9Jwrb92cGjpH29VfBO9jT9isVygtOWHDCgpeCBd9MWLAdCxKpAPMrGPrGguoMe0MGG7diN7oNsPf1NCKH0tmJWkV%2BuLvTwra%2F2ueVffjj189adZvFCf5zF9daEljOW141OmiLuDrD%2FDw4Vv6b61ba5Z9Fyj%2BCyT2F04hMhyDy8Ls6OxCsp3EgHPrjQDDKt6EztDm7%2FH71DpSKOZfJgwplL6fWxmNxKA4sXccyOF17APtznhN9U9GG%2BMMwEDHDMgeeUaLOc3JMqhklIbJQjoBF0oORZdClV%2FbfJbMdNZnE6eoSGnNWu7qwbIEA4%2Brq2mpUSg8RfqfkkkoBJGMM7rPrcfsC%2FbfhBPq9zloZMycakCpEG3o%2FHhFsRTzdOXPvesEYwyYz0kgSUsyRJNjmDXWTpFaEXXg67TER3I9wUuUjbA13YDaErTndeTOoGvmeSn76iX0LdVYZQYHJEiMNDqRz8jP47nUult%2FNigTP5wqKgB9AEWvf9xo4V%2FqcmVnw9Aas2kTFx83s9nf9gu0XPkQxX8U0KsaCXh%2BM9SzyjaNCNsN8yY2T%2FgJkLYqkAiqPLC8OhpvNtXseM4tg%2Fd602jz4MV3RManE8bioyVonZQDmEEmLIpGhXFQEBwk2n5hRoLQSlL6GAPKea9dO1CkCUg6IQO7AW80SSDBk89BH%2BqIccj8iIjEGAuVxRjlT4TdsQSuhc1x02U6%2FvZFdrpAL%2BUxR8KuEUfAQ2ubhMRL9R8ERvOwweGiqn6DDz%2FhA8Dzj4DnpIkewBxLBswmEH92WFk3P9pCGnXkYkQcXqdHKiXQeJExbXz%2Fe21j1DjSzBce5ESZCdnpIUVEtHQFPFlO1042Ld9p%2FyTrQFvhsXU%2BIfYw1L6qzZM0xUOijsRkYvvu%2BmT%2FfxeI7%2FaEXL%2Bs6E9NQb5vCvpiNnfW99JKE4VmoSFblqpBFgcmkI%2FVnU1oM3I9O4dgfmo8lAaZuiWINNfTfKkrHpJPQUHhy8ruOhpCBUGe4%2BLX%2FYeoIXfY09SBxuAJ44FW9yI5QudBx6iG66Ns9%2BAplhC57nnqILgTKYMwd90qXyx6oruniD1RnY5CX0FwQF0yelOpM75qOJEfKAsO%2BKfGrI%2BIHGAZkVxCgKHP9j9TerPRT8aVvUt%2F67B8jop%2Bx5QiFZkRMI61T%2Bb2SeEkqCvngmykRGrQqslNYVf%2Fi5l4T%2Br9WT2fP2qJAmQ4S2YrAOFXVSkJCmsNk3gEEZfMJ%2FZWaT2RSWYHEzKCh4mq4v3WFXerCXMvB7fFj1lOFAqeBBeuoj8WcnAZsP4GttQSBY%2BEPXHsFIf1qhKYr5JKNQWOYp%2Br1csV7FeSOWa6wXdWXX66cTMY1xXnyMpwKJ8vSaj2cA9ekxXroK%2BLGE7kkJBT1rQnJLmNCremz8cFYOcVA%2BWP%2BUWjOPxIUiGxpEhwq93Ru4OA7EwSkClBZuYX6pgZqokM3UGnvi%2Ba7gX7Ms5idYV2kd%2F%2FU137%2F7n3Jg%2Fo8cvcpDdUIwFW1oK03LP8JDN3u13XCbEgTm2LRhYBMfwuuOEZKCtVkWIsGzgYXjJxqaEWsocV5DG1X6yiYY%2BzQPi5c6ym5B1g%2Fpm7gEd%2F4%2BLauIQpx4vmQ9AT4KHRhGM2D90RRCVtkbls42h6o7U6BsS9wv1vtgaJLMXwglxANO%2FH70NxmSw2m8Y%2FT%2BMf9zTlq%2FCMx3HyzMOoA3s02s8sa1iggQYBRJyhTLliBpd1XysOaQhWuVQVuUpDPX5jGeJ%2FaMaWg6wxqudb%2BdMmtwNWrxmYbNZYOXJt4HSS5i9nwoAmdI4sXicOPijgT4zDqO%2Bpn%2FcaIamzVDwgURFVxj0FCeVCg9077%2FZi1zO8eIBD1Ma7CEmnCZBMmex2Y7ADJ3q6NgP1wd7cyX%2BLCsBnkQIoabIa5WcXmZRDLwXCsgO0j6guckdDYkgmcnQbOCEPa9Ncmi0%2FBZubShJYQfs84jfjpJ7QTfv33%2Bw91kj1wbD%2BPtFOmqVM3XI8ITTt%2FuU4LUxIGhKxnwRNl3c98lWj36aJoZ240qaMdZSaN00Q7LgANaepc28kRGdGwEvtMd%2F9IyqpNIEL17R9FT9ruyz%2FiAjtOCMrmHznvxNryPu4BAnkfMWsS6N4oFNWnsSaQB1BUjBDAZFO8r0ZR5WuEJ36HxwQouwFKqQCtVqZSgipQ4%2BhgHw1empdsXeTgpXSy3q3zZOKXGH5hUGhjm4VfGJQADckvUzYhBb%2FU%2Bi1MEqBEaa37KazT8C60wkU9j3wkI8o2NKPpuhqoDkN5Tq1vorEphaKVcyxDeegRcfajwrhNOeptFeSRAdFXiGi5kgI4k8g5066gB13RNmDq68GsMRI6xUNPMy%2BEQgYY9gKUxdQGdnxrLCG89drSwTq5TQkN8Mc4TckYhoVZeW4Pv9DkA95qwi%2Fcb1ZAKltfI9nuknYnSKLWJmsS6Ek79hyGovUc54HJHkeeK93O%2Bv4zf5atfyxTuIn6cfFf3lyQSSZmZ7u7uEObJ8BUUwxcv4CEzHO2GLidXjL%2B5sAGVdttJ%2FApqjY60t2fqhWekMt8HeSMeO8mYKem2MAVvK1PUaqsp11RBc3Pb2hjAjXGGGoY0sgpBjiwSFIFoDDK131FB%2B5p6XWN8anDLWhsR0vR5TCayEN918U0m7F7zCCIDrU4l8LQTPiy3f94fOpHp89h7FwyOgUGZzh0GnrSmc2GXuYCgxCFkBgZiZgvMiPF%2BY1DQDpuj09oN%2B2gnCGg%2F4mkjwi%2FnjLdomysng2TJDNQ1Jvbg2horiNi1JclSYDbwJPwnr6CCGU3UUpdNMZio5YkOhh%2F8jg2t4W%2FGCuWIWBZfSe5H2NQH3L0TrRM3yEUiRNPYCZanHnFTz2BbAd3Q1d584lMbj9rKuz9r08ffxkpwMkUzBTFnOOCnaApavB0sdKv5AFkI4HN6mTQxqHpOa56nhKMjQqJA8hrk4ChzcQdEoyt1%2B47wcgGndeTcNSp1tj16Lh1y9Qp5ptHmu%2F%2BNhRpWwEYkUSbbSWhcEad5hqLp1EDd96pZWgJwrT5RC6LFlFFnMoPsEGrBMZHIMKAqt4xhAQD2N8iEloOxPP51FOZbQKzY29agSsEL0h7lK0JXZCi2urL7LZm0G2F1gp09RUbDUtGu8JjCyN7sysCMwUEVowSBJlgTkuidk%2BBKKEbFsVdna0MdqYqCNWcMfUO6A%2BKW8yS8L5a5UQuszRY3XBrjg6zbnwfVMJrzQIbxwYcLyAFkcYzgphoEw0M6yPJkRIKVdnomrpR7c4ykVwnWy0zOfemfgMp4DhlEtKinjjCt%2BeANXDNaSCLT8XDCYYpIG%2FPjbUj3Ew3Ow5tbWcpNF4Z8cFgl93BlWwkdQJR284r4RISzrAyP505FFQCTBlHFBIGpfAFkGuwAaF%2BCTejMKh1QCpco9GupPpphjnRLoqq55cTBTM087tjOQavKcf4ML%2FXT%2F%2B40MfPdl0QT8QzVGtdxgQUgmNm4%2BtFJQDUeqvgFxSaBs%2B0p8wQovof25%2BB8lKBQcEvUlFBs%2FFMIFD7Vl3Jm2SFPJ9uzpZjME7FMUIatcwlVZqi0AmEaWJr%2B66tvtAejQwlU8fEMH7x5XYY1uhpSTOhNTNmAEDtNEkkCNM%2FnVCiiX9oPYCV3FmSo8i7bST1mSQDef2Q5MfV7UTeOvIyxAFVB9oEam9HJb3Ch%2BrjrJIYQWGuza%2B1O%2FbJA18nUtmvz3w728zOoQIwmxgLrkxIREMyriVMOckoqiiA4oDb8MjF%2BAw7%2B7uJ8QliK2ID1ukXlZxGVeHHwIzY%2Bl7yJYmtMJuFEOFKclKsFbIBDayAhJ68jVVqha%2BAB6txwC1FDjViC1vEtuxukxPFmEaKceGSjEaOA%2FHQkdayWDJfGykTFUofO7ZwGBbAI2MBcoYGurf5CNF0xbKvjBm3QlvUs6g81UlIuhW6vKXelnBnpVL3E4JVipkz5Y1FIJboSkGnAH%2B0KokHFEgiWTT0W%2FAPPdygDjmYSsssZKQ4nUFrhBqbR3YDMTHVQFwgTLAU%2BqdThAyVuUOHP6FdnqYqkGLKmTA%2FA4t6EKUAl0FZtklIotsgz9vH2Xq9uL1qyGdG3%2FORZCMx0xh5n8rYpjScwj7p6MHYXKS%2BHtXonCmtjQTRP51alnBqra9kpPArBT%2BttCxdlYaYXa7XhZQCSBIteabIykmKRnhdSgJlPS7zM1Ci0J%2FX1W2U5hESfszcgVPQU%2FTIk2hU3JemEUyzFeZUUmh%2BuiXESADCD6lyRyUkUjxI%2B4uAEskU3wXue1Y8fme2VTxvt3v%2B4JfV8kn%2FuPn65YtWFuPXQiyR0qGm6okc0qQO1bTWKREN%2BqXmRL9CQQ2vmVDmpxxQ6VijOQb%2Fr1kR1XWftraqJPTzZXQn99j8fPvJsyH2TC0cSBEKDrkQp82Um4lQpT%2BBoSMm7Ukk0fiN736GrIZ%2Bi5I%2Bx9mIgNuxnNWqP%2Fz825XZs3a1H1l7Ftq1hPFUIoinb5oEh7I3btvnbbkpw8AWLBh87q9cGJW29Qvffnp6mt8tZlsm%2BMf2YbzderifV3xuZE8G7RHn1dAQ0i560Uns0hf5ROUqYwBEhiJIHevQWE0d2k%2FPmqZfd7oU89mTuf%2FPn9cvu5eEC9RapmjXvfVxWxLdD3zFbm7MBsAfbuAVe3teM7X7YWUmgVZVOx9Vaxhnv69RYbBkf3wep9rhwERQihXe%2FgwMLelPiZ1PB%2FTp0%2Fqba3HbEaOKRoyWYKNBjH7Aser%2FjV6eaSJ%2Fz6xvwRya%2FcTC%2FKxGAww%2BIaIkeT4GHVNuXw5aWJdCers4fKdW1snYyrpC0Ecjvn40MTBF%2B0BYQ5nZ6taqvQgP0BPbDAPyEJGm3g0TiTT850I6%2Fh9FQEKolPbsKBQwUNQKCZBMEEqYvgojNIAUtURqptKCSSRDDOcbNiP9kNoQwniKOYvusbb8NxZ5UH7N2nZya6NAtEiA6%2B7mEAAkTN%2BW9n2kIlBKUo02mhUbgjUJANbGSyDKpf6LCshlKFvclwAoPwpV9Xa2nsPnVZQTUzcZ%2B%2F38abn%2FsGXKtmmz9cv81tyP7UDdTMQ0CyI1GSDXGIAiDKspaaYkEFrHYY400qD2ZpW1mZmazan2bSmWgmEZ6OKre00Gag6ivU4cnt3bwH8VO6UwwziKE%2BnqR6l%2BePs2kOLpY551Scde51OyGiVwzimjCGHudr1xoCjVilGawnsW6HuL0bFajQuMFNVXEKZ9NZ%2BOHXQtx5FS2a2ibxiAP7IifDVoGAZeHePIddS%2BCems4ofOjY3Ofhymtj%2Bqa8Tlcf5l0xRvWWs1vXi%2B%2F3n7srf08MiHvWIzDy318S%2BP25qUB31w%2FmyswK64VH82ZsLD2sC9MVxiosNv9O%2Fo8Lv%2B37x8tXmzNEhwttiSdj5bb77N1xtrAGaft980mVepMKAaNnMklJTOXCYNzQCklENpBpxQ7Ad0GAIKa28UCcnNEMqATynN4EquYTuRklOCssVz1MCNkvgIfd912GQ5HttYxBGhB1SkHigWZ41GDww8DC6ezi656uiO2%2Bh%2BpnQOV3tRiZyEpqR5KvfNnufKO2Gyvx11lWhU8lNPFN%2BmttZf2GbQmhOZiv1VKOjWLVVL6kINPy5X32Z32h7qF319NiPA4gaIdIoylStrjF2sBGpT7fShHFPt5hC4%2F6%2FKDYppHwgT7f9s%2F%2FbLbAhVAEtMi%2F98i2hSHMUVzN%2BZFCWGge7Udx9%2FrcNMI0pYpaKlkspbFqqovv1%2BREkEqmizjb3F0I%2F%2FfTqHyoBEhGEQV5UmKR4oT%2BqiIDidiwCYq7sE2xURFyszDDJPZrSeOtzzNpk5SFcG6vgBuUsSG6oEBbhqkkih5st%2BmekPCkhOPn3ml4F9XN2ew%2FiSVKShJgPr9Inu0IIvNgSgQGCUmwRtNgL5jYqaQH7e4hUTCB2IYWWnGOBRbiSVharrjzp%2BaGtXWnTIAyZN6SW4n4Ij14Rrc40gkxwrIan1ccrZAWx6RAlBHAqpzFBw%2FzbXvSbDPR84XiSOiiMQJ46spDNfWxxG8vazhQyj6FII64HmjjAwDfIBkkhBrjjE2MljoUzhBkkdVMv38LUuEuAdIHYNaNZIAIbnGEHDzOF8RKucL4m8eM6Xdg3OoWnbBX3JmN3Z9MdQG7MLl9n3BjUzsw88ea1DXqA2XtzbKLZ4lsakp0EvFFIMtpu0qXb9qTP1BWca%2BqKVicOt%2B7kTteztHrAzJmsDx24MpPMB0jJUhiLYeCCTwCE%2F7OhJYKcOywzNdFKjAqA4Y1QDKFbsF7KJT4602Govmmu%2FCWGJ%2FUoX%2FRTQ%2Fp2EAktFisxptZgQAWo0sDbqGoqQbEgW%2BcHEQxcl4p8XtcOepzR5Ll9HsxRAlHHDIhARxQPttpxrl5Jo%2FSYVQ7QwVBkYxA9qxnSwTNxxHHfs1IfHEqFoKSEg23YJjAYdaZeiwwUTBimSSgqiFFOyybUldQDf9Z5PQUfRi6NGNqkW27qbc%2BIFwLEz4FKptuBGVWddGchj%2FhTPfNrLozu5AedwD6PH%2FmTaw9d5Q550gdB%2BJ1Xt9iL3wDVrwaQIOuUS3U%2BI1t2wznCMIw7gPnCyH5L%2FMJ%2FdXRm0SbZ9Z5NxPt04C2eHIw0kmqkEoVZUDfEzGmd%2Bhgq5Wp0OW3RxSsMrYg0vHFe1YvHJy%2B12HyahPhFxUwbcMaYCAr9CgVIgQ9sWFcDZCD5scP04wUaHvY0xAcbkSCm6SDW9eB%2BHlDirlmFoB6UPyOCXcL7%2FNCmTFMqEUCkUY0VXm6UrZIBrNIYY55Kr0FALqj%2B8Jj9D0gT7OAkU3vQW6bHg5qxQBcXSrArhjG03rcp6TYQiVVFC5GFfeX4ufyEKE%2FJIpiykm4ORiAAUmpjuKwHKM1YQYT%2FHMkLBv7ZPuQKbpDPytI6oQn7bJR0lD9ecSHy%2FLPb91%2B8eQ6wfZndbYTM37m62fihI79XuefV%2F5biZ7XZ%2F%2Bn6%2Fmr08gPnj%2FHazMmoAzD4bSbzdgKev37ETYku0zkBCk1qBChIhERTUGVIvzbIIIQRTBB8GVne015gLQBHhyKRvGJck1%2BgIjP3CWaP42uYYJhlXeIO3swo197yiYYXJMsSaN4DNrNp6LmHAYIijfBYi2WqtsR837IdfKnuhJy7ZcYnwuIRhBQLjd3m%2FTNJtS8r%2B7scsUGg2syNZXCAxVR5dtGlwtjDHLiiQhAUuZ8bbV6%2BXeRVBUcl6sVRlVfTNIDqWoNy9UlwdWTpShjf%2BTqq0guY4AtAPufSsSmOGFb5eoSOEUzfYjqHbGhsreIS6LfnepXJLHhk0RtZl02N9PXDZRY6YG1LLY%2B1esW3mHE%2BNO6Ha8gqEoRTI7CRyHEAzwgwrFsVTXcP%2BxC2vR0pUatjbTxDEkcPWOTIFlmwnDHtAdXP5tQcEt0WlpWUdH1e3sTMfRm%2FRks27JwRyIJDDMdwvQECMgNBA3nxGze52GYMSbG6KqFN6%2Fc1KKlodWnUgG9fo%2BuKDn7KdA9dNlzVDg%2BMkvo%2FxmKG1S%2BvEo2HcfgpsZmr7o0RUAIwhSQHLNunFbsqYpDlGmmMnINqmjtFI87CDLlMMPutI9T6ozJPr7DASpNwJXggc5%2Fh0BqnSgZx2iUYtRnUPtE0wo9zNgnY9YL977QHBRNOBXKg5FDWd7OWx8Fe4bVMSAe4nywewl93iqB03DG%2B1WqtiTj8MMmHPbk%2BhJeG0hCus%2FSBcvUxsZIlCh9uU6z1lDyxl3Vt9GlcdHyI6Q65yzZmSgMPDH3Ikg5mFxlSbMg65kNwOrre6jUBAFcVKcc16nDHRM%2FN1i1LnZb5U8woSDq3th%2Fe8Hn0MlVmZdvhzpHYj3FGVlHPA4tKPnQGki1RtwWr9h2ONiDMTWrNiPhKW77a64TXxvEN9RKkp0Cr9OZLnXUVOodkLlCm0z4n3LVqY3jnAenFRaCiwPxjTJ3Ln25NL0SWXPfE8dvQ8gRAcq9up5iVAtJhATCgR1XwWUpnCBN5XQLKXeUw0wK9D9UcVs5naw1iiquyR0wrZDrBT90zR2AAXgcnjmGGOQtLZGHUdOZwpHW%2BNaOLFRfAWFj1NASPYnRtAMulFLKkMv1Od%2FvZP0JaZBv636X6CVEF5Lm09cGbpyOl5%2BGwlitgez%2BzamjoRDBZZiNVZoLCzReOaopaBHNQTD9QLtvYr6%2F97Pn%2FRjwQ2Rhv6%2FDz7PH%2Bssm58jcpqvl78WWpPq3a%2BvQ1wtM9%2FzULrheoxvF0%2BP89vbVfc1R4D1obwtehAWVVu%2Bwsdy332JcsvX9bzTCjAz%2BI8zP6cre70Y3danI%2FYsYtETVZnt%2BzGYY1OW20OK2yIUUqaQJvZ4jnUyrrFCbU6KD4vgxGmZhc4onj7tyOdhGOzA7T4I%2FwCXIJg%2BQK2QraSwBEIlEMA9irpkznUT%2Basx7t7oAf6HlxGS1IsuCZpiRp%2BWxynwBbT97MCh%2FrZkvV4NxL0IZaQumQLzCpSCITWLLqdKAnp5CcW%2Fvvdu1%2FMuee10ehf5ptb00p6wYSDEuCyPnQUqqYZKf%2Fx14YhxEHpfDFWrbJJk1UUarZ15kWMrETxJ9NODNfbTl9NqcslNWXe5KGdwayjqU9Hdnh1BtplDQ%2BLk8LDOXPQdFw5Ec8EIzdaERscRkrSYpmTvRhkxcC6vkJrDI%2BXsS6Jr5wiF0Y8ZRLLWVpBNbkBWCltb0puQBS%2FdQ0OIOXMZ2TNWTfv9RrbVvZOZAoNML%2BS%2FtflPjAwdruYYZuWMMPtrdtXqDiqAAuMyg%2BJgyx2DGawgf5MjV8NIdqpkzJ4Y6Ka60O9ZSzh22M%2BR%2FQtIGexOwyMJw%2BRKV%2F%2FERu0lv3IQWWDjSaytT%2Ft0eNIa5U6G4MV4IyWgj1xRRrp1PM5TtMdPzv1tBGeYCaAkyRAhJsVX7Xxw%2BwcNeh6wFfLUX31iAc4CnMEkDxwVGSPeDqOGnQw8KvlKBuN6YGlEID4UMlbjQJRIYBQB%2B7iPTOXOkPmGj9viVHwFuNamfHBeMtivfPlLThC3rK%2BVT%2B8hQ68VY0lKokAJXQoo8j9PO3EW6fzVuwIqcR6yxl1AjXikmo43gpEqCfeOpm38Cj0FkJUw3k6HHONqNQ4O3M1z25OyVz9AS7jH9Yyl1nMyHHfLDVore1rZSnaG87iEJQaPaHTx0MI1kCrb5Y6xzD7%2BFmqNxPYzFIUYY2v%2Bmapcwy1j5%2BlRmL4mEZVEh5QVc8Drvk5Rt1Hz1yI9ZYXZNIsRq%2FjLgkx4LBvhfX64%2B69MFHymMJpFQT87CPebaqiD6piObJ9qcIvPu48gq1ucPGb32InsOlPunhZG45pG6tWUue0iWYdaoyZM1jiWqNAysq1335HDgoOUYP6IM9GqRGXGmesCBWx%2FmRvFaEMkOrSSi0CgJWGDrk8EF8hirUlQocKUVzlS8QQQPBQIqp6nnklzifA22XnXRcI2VgiGGEnYidbj8z4i9Bga4cV7BTN78uI8ZihcZgJdDnB2p9iboNloK1LBjREvt47W0yVTnV3mpSVqB3%2FMCWAQFkRRiq6i%2BMpUsSijUds%2FVNPoxKxCzXsEKvufSrSGY6uHQZVaVhzx4Bltw6hPXk1OuLb7I9tBbfmg%2FXvpp%2FRqtrF46Nl6%2FXycTuJd1%2FUza%2F2Vd%2Fz1bt%2Fz3fF3%2Bgq2MbvV3m75ePuqtrytN9dMXp51O%2F6efby63J353ZvmkRVOZtUrmlgU0VwsW0%2BPRWzxa7PcSSFXvlX6akGr6%2BTOvN2SB2vkhCPdgBFT9OhCJbGFNbFhg5jqhJ3GAnsdAyJfVCzTpN5B65py3hzs2m28US1Kcl%2FRyg5UIy5HxOgEoiPm1qbTnvGjMguid788fPyW8Xemwf0E7aFpsrhMZCiATC0DskOSlitPJ2f4SZOH%2BA1kUcbbmRWJlev5un0XO1%2BhZGp90FdXGHFs%2FYEFBp4NJ7J1CQozifSnNIfPd5MFWIVUYmbvMz7RGgSMW97DB4ocmfsXysHlvuTC%2Fp1Ru27le7kl8ev6wdzLxf3WhK8%2BzqOttokxJEOcaTfmNnvtlOZPKo7yiguwqOy54K5492Fk3mPNeeCOixFI%2BdkJrOCMsAw41xTNUS%2BVcZGXOPHvHfjve6D0V3%2FCbVtA1AuB0qH0XKALxkKCU%2B7m460TIQ7DgZnJsx6%2BIM8OyUC6hERAXC20WTSD2NfCnIgZuC8O4gKWVgwHHoY0YrCiPBc4TYlwBwRqj96qrbsq16LOyMHt6Ol%2Bq57l36U96enp5HKbp490Yy6woyhGlyYBy3G7CLMxwtlrMMwsvy37LZqbi8HMYU3zX1kI3GXCOEM0GqMDyM3Zhm9Z4hCBAhruVp2LegHlNab2e3vhhC3l6UMD0sgC2qIoZWh8qNUFyZxGsmXlno5FWdewqCD8BEAuReOrL1wbjlUfgDMyuGXx9n9%2BuJEETkEkYOLIk4qiqUoEKRVZ4Ar3OIOdMszjkSYhcaWgMq6vjLJqxmCYyORkDW%2BizAOrBdQ6E3MB%2B3f7gJuy6YCXw0TtbQV5xFTTXAkq5%2FKw9SJMiqUqX6E0vAb1Ufg3Tn%2BrDlhLZgzn9M5kClgqvzo2UUCTgGJAs4GL2U6J%2BTQdi6igHGyc8fbOeXmtBNZNn3dimXreVK7GrRBO5FlS7RMOcKyidFbNhTnAXU3bNJ9n1bL5p1ofj13Sop72eKmAvugLtSB06ZNAnd3BBzcfxu0TA6W1FNbmVw09M5XIleonfYQNe4paySgU6wiMikoyKoh3mvUDzAetLP8SP50V56K8fFnP9xJqFsa3Xcon1gNe9YMlLvmPiFn9bfhXHlNbtkK5Z0ZwP3oPmLDcBPr9sS6va17Zh7ruggvFeu6XkJfrBtKCyQqAPyosflcv%2BD97PZhoaF%2FZDFgVTBaqvxS4H0v9BhaIVrYp0qlXrYuTgL9ykx9P7cHR12ml2EVkyDuZnNky6WHcseINTRn37XUDfKmm6JRwI%2Bz62IqPnlANMsL0nfqrUZYO3U5uXc9V9eTZN7WzGBvDQPWa67Gn%2FPNTSIwpqn96LlJWyjUZRhHohxiO%2B%2FbmrWRJAeQ6ydKW07euYPWuxKhwDYYJQdXNZ86M7byY6o%2F%2Fe3Xy7HbyLXbMjAbo2ez3a0E9Bg1cmw6pl3%2FvCY1YtdMHOpajlUjokc14n7qftSIX%2BP6Yb6eby5IkVA2NkViDUovimQ0emRscxxxsW7CMsaRagRzQoCzP0zF9vR01SN1nzqvGrGjiC8VjWgFgQGDXoWmTccxYJe5D6dUEgTj6sb4%2FrJa3q9mT%2Folb%2FSdNgTCfPZk7vzz5%2FXL7oXh8Nzu4fXL7LnTB4CfZ7e%2F32%2FJen274xTz%2FOr%2B839sF1m%2F2b748I%2B%2FBD%2F2Fbu5oUIfvUHcDIY7fMjdB6qJIY6Oi7cOY45qBcSZBFqFKMUoIUI6bC2RAFIRLqnpUiwWMJWH0%2BlXYCIoxQpvf1Kf5QUGu9OI6Xeg7lrhhBIQMaL0uIaRqk3t2L9aH11ba5uwSTaBjth%2BxoRBsZ4QvTQ7MKpmjUMFoKwdZRk%2Fa0t5l2as8dK5c9WWTJcwJTMHntc6xA00MsqB3ZIz1OhMgtIWDwfVT4OK6ZrNPV7RFOojItc6NkXjT95j3PCOA9aj1ctuFrzXU9N07ez6peMI1%2FRzJBu8UUhk1XpCrtqYO%2FVgydiivb76PN0MMjm6s9O%2FlFtwn535AmHr0U6WyGCdAmNCOSlUznDO4WuZkzlYxtlWDSUMl%2FeUcUZ%2BCLilGGSU%2BWU3jMuwAMxfyxPCfCybXNlan3OXq6pNPm45xAnCFZ%2BLYuNanlV88iawZS3Uz7PP88dfluvFXjo%2BLzeb5ZOxfQ%2Bzuy22MrfxbrZ%2BKJjDs3YlLnAN38Zwz42V3afv91pUH8D8UUvjyrwOPC7vF7f%2Fcz%2FbzNdg8bwVvdX%2FZBRZgQgDztgKhLACxHe%2ByxKMgVWhFeMoAM8WOmqByOOcoNlTwx7BscVWMtbbOxEyM44OAfc9YxXjYvpCunhE4wzOmGWSb%2BE9UREMWpr5WqiqYjO9fVE1FJqbJtUeadcZYdpEM8GV9lj131VFjBQvamjK6zJJ5UyoBhSZ3euU5hpeS7AfGPPh%2B%2BgiE7gXqmHMgfS9KUYAonuCbf%2FmAbIpgLORbNiBmB38q1PUavKAQQ1swlgaDkBCUSlQNddLNKTqd%2FV88b1L8uj3wo1PHhNFCpvlkUCuES4%2FTDzxs1uDy%2BagTdvJYh%2B9TaMmNrzbnjbDybtrTyM1iShYtOCm6%2BadZ8MEqURKEiNSEkOGsLQXsCLFOcD%2B6h0BzRFKmFS7v30pIhJkizwQP4D04%2BPsXj%2FyZbU0FVdP86fl%2Fo3GpxdTEK1AYYUnj4MAUmtELLXnTyTd%2Fs36VXfEZ%2FnRe4ZV1dZ7TzaJ3bxSKJjRKDy%2FlOz9h1csg1ssUo3UakcMcF9d9pu3JGcYjqkKXe%2B5FBIbpBmf0PlRmvIYsVcsftQxgZRSQFRp94%2Fvmfcsh2cz4bAuLNpWKnCKxMUONCw6TEYjcefUZJpA0PztjziANBOJlv51tTSh4kPQxGRk3y%2Fv5uYV%2Fws%3D">Design</a></li>
<div>
<br>
<img src="https://user-images.githubusercontent.com/71986226/217028542-2a6abadc-a5fb-40c0-a74c-c4f42997354d.png">
</div>
<div align="center"  ><hr width="60%">
</div>
<li><a href="https://github.com/AdhamAliAbdelAal/Pipelined-Processor/blob/master/Docs/opCode.xlsx">OP Code</a>

<div>
<br>
<img src="https://user-images.githubusercontent.com/71986226/217029995-22b4625e-0dad-4122-a96b-d8bc0ca35c0a.png">
<div align="center"  ><hr width="60%">
</div>
</div>
</li>
<li><a href="https://github.com/AdhamAliAbdelAal/Pipelined-Processor/blob/master/Docs/outputCU.xlsx">Output Signals from Control Unit  </a>
<div>
<br>
<img src="https://user-images.githubusercontent.com/71986226/217030356-2925f5da-42c0-49e0-8947-4e6bc0100107.png">
</div>
</li>
</ul>

<hr style="background-color: #4b4c60"></hr>


## <img  align="center" width= 70px height =55px src="https://media0.giphy.com/media/Xy702eMOiGGPzk4Zkd/giphy.gif?cid=ecf05e475vmf48k83bvzye3w2m2xl03iyem3tkuw2krpkb7k&rid=giphy.gif&ct=s"> Contributors <a id ="contributors"></a>

<table align="center" >
  <tr>
     <td align="center"><a href="https://github.com/khaled-farahat"><img src="https://avatars.githubusercontent.com/u/84389471?v=4" width="150px;" alt=""/><br /><sub><b>khaled Farahat</b></sub></a><br /></td>
    <td align="center"><a href="https://github.com/AdhamAliAbdelAal" ><img src="https://avatars.githubusercontent.com/u/83884426?v=4" width="150px;" alt=""/><br /><sub><b>Adham Ali</b></sub></a><br />
    </td>
      <td align="center"><a href="https://github.com/MohamedWw"><img src="https://avatars.githubusercontent.com/u/64079821?v=4" width="150px;" alt=""/><br /><sub><b>Mohamed Walid</b></sub></a><br /></td>
     <td align="center"><a href="https://github.com/EslamAsHhraf"><img src="https://avatars.githubusercontent.com/u/71986226?v=4" width="150px;" alt=""/><br /><sub><b>Eslam Ashraf</b></sub></a><br /></td>
  </tr>
</table>

## 🔒 License <a id ="license"></a>

> **Note**: This software is licensed under MIT License, See [License](https://github.com/AdhamAliAbdelAal/Pipelined-Processor/blob/master/LICENSE) for more information ©Adham Ali.
