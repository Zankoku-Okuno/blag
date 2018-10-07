# Computer Design Log

This document's sections are organized into reverse-chronological order, with notes pinned to the top.

## Goals

What are my goals creating a computer?

My primary goal is to learn details of computing that I do not currently know:
    * soldering
    * wiring layout
    * bus design
    * microcode
    * hardware debugging
    * interrupts
    * device interfacing
    * caching and paging
    * coprocessors
        * direct memory access
        * symmetric multiprocessing
    * vector processing?
    * configurable hardware?

That's not a measurable goal, though, so I need a test for my skills:
    * a computer I can use as a networked time-share
    * text processing (display, shell, editor)
    * compression
    * cryptography
    * bootstrap a programming toolchain for it
    * 2d graphics?
    * 3d graphics??


That's a massive undertaking though, and I can't wait until that entire thing is designed and built as a first test of my skills.
Therefore, I'll need a series of smaller tests.

A for-fun goal might be to use SMD and PCB to create as small an MSI computer as I can, maybe a single board.

## Notes

There are various types of execution units in computers that drive the usefulness of the computer.
  * data transfers (between combos of: processor, memory, input, output)
  * address math
  * bitwise
  * binary integers & fixpoint
  * binary floating point
  * decimal fixpoint and floating point
  * cryptography
  * audio, color, spatial, and projection mathematics (and any other multimedia stuff I can think of)
  * neuron operations (or other AI functions)
  * programmable logic
  * synchronization
  * protection systems (for OSes)
  * virtual memory
  * maintenance (e.g. sensors for heat, power stability, modulation of clock/power)

There are also way more (finite-size) numerical formats than you'd think.
  * size
  * bit order, which could be multi-dimensional, and/or arbitrarily permuted
  * alignment
  * internal padding and error detection/corrections
  * binary, binary-coded decimal (packed, unpacked, various denser packings), bi-quinary
  * two's/ten's complement, one's/nine's complement, sign digit

## My First Machine

The question is also one of whether I copy an existing design or design my own.
The fact is, I'm in this to design my own computer, at least for now.
The designs I actually want to copy (PDP-11, VAX, DEC Alpha, Cray-1) are all too big for me to tackle right now.
It's therefore probably better to design my own, simple 8-bit system.


When it comes to designing my own machine, I should start with the instruction set, since that's what should drive the hardware, not vice-versa (at least in large part).
I've made a (not exhaustively thought-through) list of things a full ISA should be able to manage:
  * I/O
  * Conditional Operations
  * Constant data (i.e. immediates)
  * Temporary data
  * Global Data
  * Pointer Chase
  * Arithmetic
  * Local Jumps (within-subroutine control flow)
  * Jump to (global) Symbol
  * Computed Jumps
  * Subroutines (call/ret)

I notice a symmetry between data and jump operations: they both have local, global, and pointer forms (for jumps, that's the computed jump).
Really, what I'm saying is that computers make use of local resources, hard-coded shared resources, and injected resources.
Those resources can be pieces of code, or pieces of memory.
With that in mind, (directly) calling a subroutine is a combination of local data use (to load the link register) and global jump; return is just a computed jump (based on the link register).
Unfortunately, I have no name for a globally-known entry point that can be jumped to that doesn't return, but if I did, that's what I would put in place of subroutine.

In my first machine, I can "ignore" I/O by using memory-mapped I/O.
I might also be able to ignore global data by using immediates and pointer chasing in conjunction.
Likewise, subroutine support can be synthetic with immediates, local data, and computed jumps.

### Attempt 3

I got distracted by spiffy, modern features and how to implement them.
I need to define my goal more accurately, and for this first machine the ceiling is more important than the floor.

Restrictions for first computer:
    * 8-bit everywhere: data, addresses, instructions
    * single bi-directional bus
    * flip-flop inputs on all XUs (implied by the single bus)
    * single ALU
    * no multiply or divide
    * single MMU
    * no caching
    * simple flags flip-flops
    * no interrupts
    * instruction set not expandable
    * at least two architectural general-purpose registers

Since 256 words doesn't seem like much space for both program and data, I think separate address spaces for code and data would be good. There can even be a third address space for I/O.
If we have a 4-bit opcode, that's 16 instructions (which should be plenty), and one of:
    * 2 bits each for two registers
    * 4 bits for a small immediate (0--16 or -8--7) or offset)
    * 2 bits for a register, and 2 bits for an extended opcode

#### Possible Revision 1

I'm getting second thoughts about the instruction set:
    * conditional branches are very strange
    * the accumulator-based operations don't jive with the register-based idea
    * I don't need that many arithmetic instructions
    * If I only use 8-bit immediates, that lets me eliminate the sign-extension hardware needed for decoding small immediates.

#### ISA

Architecture:
    * four 8-bit general-purpose registers: A, B, DP, SP
    * 8-bit program counter: PC
    * 1-bit condition register: C
    * a 256 x 8-bit instruction memory: I
    * a 256 x 8-bit data memory: M
    * a 256 x 8-bit i/o space: IO

Instruction formats:
    * RR (register-register): 4-bit opcode, 2-bit source register, 2-bit destination register
    * R (register): 4-bit opcode, 2-bit extended opcode, 2-bit register
    * I (immediate): 4-bit opcode, 4-bit signed immediate

You could consider two additional sub-formats of R instructions: RX and RI8.
RX instructions are exactly as R instructions, but the extended opcode is unused.
RI8 instructions as as RX instructions, but are followed by an 8-bit immediate which the PC skips.

To stay agnostic as to assembly syntax, I'm using arrows to show which operands are source and destination.
RR Instructions:
    * `mov rd <- rs`: `0000 | rs | rd`
    * `add rd <- rs`: `0001 | rs | rd`
    * `adc rd <- rs`: `0010 | rs | rd`
    * `sub rd <- rs`: `0011 | rs | rd`
I Instructions:
    * `jc imm`:  `1000 | imm` `PC <- PC + C ? imm : 0`
    * `jnc imm`: `1010 | imm` `PC <- PC + C ? 0 : imm`
    * `addi DP <- imm`: `1001 | imm`
    * `addi SP <- imm`: `1011 | imm`
R Instructions:
    * `inc r`: `0100 | 00 | r` increment
    * `dec r`: `0100 | 01 | r` decrement
    * `neg r`: `0100 | 10 | r` negate
    * `clr r`: `0100 | 11 | r` clear
    * ---
    * `not r`: `0101 | 00 | r` bitwise invert
    * `sl r`:  `0101 | 01 | r` shift left
    * `sr r`:  `0101 | 10 | r` logical shift right
    * `asr r`: `0101 | 11 | r` arithmetic shift right
    * ---
    * Unused:       `0110 | 00 | xx`
    * `and A <- r`: `0110 | 01 | r`
    * `or A <- r`:  `0110 | 10 | r`
    * `xor <- r`:   `0110 | 11 | r`
    * ---
    * `jal r`:  `0111 | xx | r` jump and link (PC swaps with r)
    * ---
    * `clr C`:      `1100 | 00 | xx` clear condition flag
    * `cmp A == r`: `1100 | 11 | r`  set condition if `A == r`, else clear
    * `cmp A == 0`: `1100 | 11 | 00` set condition if `A == 0`, else clear
    * `cmp A > r`:  `1100 | 01 | r`
    * `cmp A > 0`:  `1100 | 01 | 00`
    * `cmp A < r`:  `1100 | 10 | r`
    * `cmp A < 0`:  `1100 | 10 | 00`
    * ---
    * `peek r`: `1101 | 00 | r` `r <- M[SP]`
    * `push r`: `1101 | 01 | r` `M[SP--] <- r`
    * `pop r`:  `1101 | 10 | r` `r <- M[++SP]`
    * `swap r`: `1101 | 11 | r` `r <-> M[SP]`
    * ---
    * `ld r <- M[DP]`:   `1110 | 00 | r`
    * `st M[DP] <- r`:   `1110 | 01 | r`
    * `in r <- IO[DP]`:  `1110 | 10 | r`
    * `out IO[DP] <- r`: `1110 | 11 | r`
    * ---
    * `ldi r <- imm8`: `1111 | xx | r | imm8` load immediate (`r <- I[PC++]`)

#### Using the ISA

Unconditional relative jumps can be made with the following sequence:
```
clr C
jnc imm
```

Since there are no interrupts, it's not necessary to have the SP point to the actual last valid entry on the stack.
Therefore, accessing data deep in the stack can be done as follows:
```
addi SP, -offset    ;; point SP at needed data
peek r              ;; move data into register for use
addi SP, offset     ;; restore SP
```
Constant propagation can eliminate the last instruction, or merge it with another SP movement.
It only needs to be restored before call/ret.

#### Minimal Instruction Set

It's great that I can cram all these operations into a tiny instruction word,
but getting them all implemented would take a lot of soldering.
Therefore, I should select a smaller, minimal set that is Turing-complete to implement first.
I've tried to organize these instructions into groups based on the hardware that will be required to implement them.
Earlier instructions in each group are more important, but further instructions will only require additional microcode.
    * Bus: `mov, jal, ldi`
    * Comparator: `cmp A to 0, clr, jc, jnc`
    * ALU: `add, sub, inc, dec, neg, clr, not`
    * MMU: `ld, st`

#### Microarchitecture Notes

I'm thinking that the execution units (XUs) + XU buffers resemble an accumulator architecture.
At first, I thought that perhaps I should give in and build a PDP-8, but then I thought that I might get experience with both register and accumulator machines if I stick with my design.

### Attempt 2

General purpose registers (A, B, ...) two to four, depending how instruction coding goes.
An instruction pointer (IP).
A stack pointer (SP).
  * i/o through memory-mapping
  * conditional operation:
      * on condition IP <- IP + offset
  * immediates
      * GPRn/M[++SP] <- M[PC++]
  * temporary data
      * GPRn <- GPRn
      * GPRn <- M[SP + offset]
      * M[SP + offset] <- GPRn
      * SP <- SP + offset
  * global data: load immediate; pointer chase
  * pointer chase
      * B <- M[A]
      * M[A] <- B
  * arithmetic
      * A <- ALU[op] A, B
  * local jump: see conditional operation
  * jump to global symbol: load immediate; computed jump
  * computed jump
      * PC, A <- A, PC
  * subroutines: see computed jump

Two general-purpose registers does seem sufficient.
For the pointer chase, a good way to remember which register is for what purpose is that A is an address, and B is a data buffer.
Now, to see what the instruction code looks like.
  * A general-purpose register argument is one-bit.
    In cases where the IP or SP might be possible, or where push/pop are possible, then we can use two bits.
  * Selecting a condition will take three bits for lt, eq, gt and their negations, but that leaves space for carry and overflow (or carry and not carry)
  * I think at least four bits for any small signed immediates to get numbers in the range -8...7, but five might be better
  * Arithmetic operations don't require any operands, just an opcode, and four bits should be plenty.

Okay, segmenting these into groups:
  * _conditional jumps_: 1 fixed bit, 3 bit condition, 4 bit offset.
    That takes up half the instruction space, but it's probably best not to panic...
      * `1cccssss` where c is condition and s is signed immediate
  * _offset instructions_: 1 fixed bit, < 3 bit opcode, 4 bit offset
      * `0(01)issss` GPR[i] <- M[SP + offset]
      * `0(10)issss` M[SP + offset] <- GPR[i]
      * `0(11)1ssss` SP <- SP + offset
      * `0(11)00uuu` A <- M[u]
      * `0(11)01uuu` M[u] <- A
  * _register-register/stack_: > 1 fixed bit, 2-3 bit src/dst fields, < 4-5 bits remaining
      * `0000(001)i` GPR[i] <- GPR[i+1]     // mov reg reg
      * `0000(011)i` GPR[i] <- M[SP--]      // pop reg
      * `0000(100)i` GPR[i] <- M[PC++]      // mov reg imm
      * `0000(101)0` M[++SP] <- M[PC++]     // push imm
      * `0000(101)1` PC, A <- M[PC], PC+1   // jmpl imm
      * `0000(110)0` PC, A <- A, PC         // jmpl a
      * `0000(111)i` M[++SP] <- GPR[i]      // push reg
  * _dedicated instructions_: 
      * `01100000` B <- M[A]
      * `01100001` M[A] <- B
      * `0110ffff` A <- ALU[f] A, B

That leaves 5 unused instruction codes (00, 01, 04, 05, 0D), which is plenty for extensions later.
Oh, and there's also 6x, which is another 16 codes.

To be sure, real code will be spending a lot of code words to manage the A/B registers from the stack, but besides that, I think I've got a design that demonstrates the key features of a register machine.
Having multiple general-purpose registers really puts this in a different class from Ben's accumulator machine, and the J1 stack machine.
What's more, I'm quite happy that I was able to use jump-and-link using a link register; that's something I normally think of as only being on larger machines, but as long as I'm willing to sacrifice one register-passed argument in the calling convention, it's not a problem.
I do wonder how much `push/pop reg` will be useful; I may simply remove it in favor of more modern approaches where the SP is incremented/decremented in bulk.

Thinking about it, it might be useful to have an area of global memory that can be accessed relatively easily (i.e. without taking up two words), so I'll use 6x to read/write the first 8 bytes of memory.
I'm thinking if A should really be the default source/destination for data: for indirect memory reference, B is used for the data and A for address.
The changes would be: `B <- ALU[f] A, B`, `B <- M[u]`, and `M[u] <- B`.
I guess it's a question of if the first eight bytes are more commonly going to be memory-mapped i/o vs being pointers themselves, and if changing the ALU destination makes it easier to perform modifications to items in an array of memory.
Well, A is the link register, so using B for data during a function call means that a single byte of argument/return can be passed on the stack; if the data is already in B, then we can avoid a couple move instructions in the function pro/epilogue.

### Attempt 1

I'm thinking:
  * Hardware is an accumulator (A), stack pointer (SP), an instruction pointer (IP), and a memory (M)
  * conditioned IP <- IP + offset
  * push immediate (whole next word) onto stack
  * A <- M[SP--], M[++SP] <- A, A <- M[SP + offset], M[SP + offset] <- A
  * A <- M[M[SP]], M[M[SP]] <- A
  * IP, A <- A, IP
  * A <- ALU[op] A, M[SP]
This should cover the range of things an instruction set should be able to do.
The only worry I have is that this isn't much like a normal processor.
In particular, many operations use the top of the stack, which without a microarchitectural register to cache this value, means that there will be a weird memory bottleneck.
In fact, overall this looks more like a stack machine rather than a register machine; even then, I'm not sure that Forth operations can even be efficiently compiled onto this machine, not without combining some of the above operations into microcoded ops.
So, I made a bad stack machine when I wanted a register machine.

That said, I only used three architectural registers, and that seems to be sufficient for computation.
That indicates that four general-purpose registers (perhaps even two for this 8-bit machine) could be comfortable for a register machine.
A paucity of architectural registers might not hurt performance much on larger systems either if a "stack cache" is employed, essentially upping the number of microarchitectural registers.
