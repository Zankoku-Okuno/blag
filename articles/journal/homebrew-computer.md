# Computer Design Log

This document's sections are organized into reverse-chronological order, with notes pinned to the top.

## My First Machine

I'm torn between Ben Eater's machine and J1.
On the one hand, J1 has a much better address space, but on the other, it doesn't generalize to larger computers very well.

Really, the question is also one of whether I copy an existing design or design my own.
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
  * A general-purpose register arrgument is one-bit.
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
In fact, overall this looks more like a stack machine rather than a register machine; even then, I'm not sure that Forth operations can even be efficiently compiled onto this machine, not without combining some of the above operations into micocoded ops.
So, I made a bad stack machine when I wanted a register machine.

That said, I only used three architectural registers, and that seems to be sufficient for computation.
That indicates that four general-purpose registers (perhaps even two for this 8-bit machine) could be comfortable for a register machine.
A paucity of architectural registers might not hurt performance much on larger systems either if a "stack cache" is employed, essentially upping the number of microarchitectural registers.
