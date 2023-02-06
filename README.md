<div align= >

# <img align=center width=75px  src="https://media0.giphy.com/media/idjnnqxEInAPn8elMd/giphy.gif?cid=790b761139e83663458cbb2b9508ae1ad8b5f85fab058fe7&rid=giphy.gif&ct=s"> Pipelined Processor



</div>
<div align="center">
   <img align="center"  width="650px" src="https://cdn.dribbble.com/users/1366606/screenshots/8075231/dribbble-003.gif" alt="logo">


### ”Lets Go, Start New Adventure.⚡“
   
</div>
 
<p align="center"> 
    <br> 
</p>

## <img align= center width=50px height=50px src="https://thumbs.gfycat.com/HeftyDescriptiveChimneyswift-size_restricted.gif"> Table of Contents

- <a href ="#about"> 📙 Overview</a>
- <a href ="#started"> 🚀 Get Started</a>
- <a href ="#memory">💾 Memory units and register description</a>
- <a href ="#isa">💻 ISA specifications</a>
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
<th  align="center">Function</th>
</tr>
<tr>
<td align="center" colspan="2">👆 One Operand</td>
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
<p>NOT value stored in register Rdst</p>
<p>R[ Rdst ] ← 1’s Complement(R[ Rdst ])</p>
<p>If (1’s Complement(R[ Rdst ]) = 0): Z ←1; else: Z ←0</p>
<p>If (1’s Complement(R[ Rdst ]) < 0): N ←1; else: N ←0</p>
</td>
</tr>
<tr>
<td>🔶 INC Rdst</td>
<td>
<p>Increment value stored in Rdst</p>
<p>R[ Rdst ] ←R[ Rdst ] + 1</p>
<p>If ((R[ Rdst ] + 1) = 0): Z ←1; else: Z ←0</p>
<p>If ((R[ Rdst ] + 1) < 0): N ←1; else: N ←0</p>
</td>
</tr>
<tr>
<td>🔷 DEC Rdst</td>
<td>
<p>Decrement value stored in Rdst</p>
<p>R[ Rdst ] ←R[ Rdst ] – 1</p>
<p>If ((R[ Rdst ] - 1) = 0): Z ←1; else: Z ←0</p>
<p>If ((R[ Rdst ] - 1) < 0): N ←1; else: N ←0</p>
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
<td align="center" colspan="2">✌️ Two Operand</td>
</tr>
<tr>
<td>🔷 MOV Rsrc, Rdst</td>
<td>Move value from register Rsrc to register Rdst</td>
</tr>
<tr>
<td>🔶 ADD Rsrc, Rdst</td>
<td>
<p>Add the values stored in registers Rsrc, Rdst and store the result in Rdst</p>
<p>If the result =0 then Z ←1; else: Z ←0;</p>
<p>If the result less than 0 then N ←1; else: N ←0 </p>
</td>
</tr>
<tr>
<td>🔷 SUB Rsrc, Rdst</td>
<td>
<p>Add the values stored in registers Rsrc, Rdst and store the result in Rdst</p>
<p>If the result =0 then Z ←1; else: Z ←0;</p>
<p>If the result less than 0 then N ←1; else: N ←0 </p>
</td>
</tr>
</tr>
</table>
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
