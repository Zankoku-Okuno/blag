# How to Digital Circuit


## My Goals

First, let me think about the pie-in-the-sky, bucket list sort of thing.
  * I want to make a replica Cray-1.
  * I want to design my own von Neumann processor architecture and build hardware implementing it.
    This should include enough ecosystem to bootstrap my own development environment and run it as a timeshare.
    I'd love the implementation to be pipelined and superscalar, even multi-core.
  * I might want to design and build my own FPGA and experiment with a multi-user operating system for it.

Jumping straight into these projects is a recipe for disaster.
Therefore, let me think about what sort of small, experience-building projects I could do.
  * Copy other's small architectures.
  * Create "modular synth"-style computer components and experiment with various approaches to small architectures.
  * Copy an existing simple, medium-scale architecture.
  * and so on, through larger and larger machines

As far as inspirational architectures, I have _lots_ of leads.
I'm classifying as small-scale those architectures that are 6--12-bit, have a limited instruction set, are sequential (no pipeline, superscalar, or vector ops), and have a simple memory and I/O interface.
  * [J1](https://www.embeddedrelated.com/showarticle/790/homebrew-cpus-messing-around-with-a-j1-cpu), [github](https://github.com/jamesbowman/j1)
  * Ben Eater's Computer
  * PDP-8 (LD20/LD30 from "The Art of Digital Design")
  * [Intel 8086](https://en.wikipedia.org/wiki/Intel_8086)
These machines might have a single clock for processor, bus, memory, and only hardwired (debug) devices.
Increasing the complexity of these machines towards medium-scale might mean
  * multiple clocks (for the bus, RAM, &/ devices)
  * more registers
  * I/O devices
  * additional bus cycle types (interrupt, block, read-modify-write)

I'm classifying as medium-scale those architectures that are 16--24-bit, have an instruction set with 20--100 opcodes and 2-5 addressing modes.
  * PDP-11
  * AVR?
  * looking for more...
At this point, multiple devices should be no problem, but they may still have to be configured with DIP switches rather than discoverable.
Increasing the complexity of these machines towards large-scale might mean
  * instruction pre-fetch, and the instruction cache flush to support self-modifying code
  * coprocessors (for floating-point or vector operations)
  * kernel- and user-modes with page tables (at least permissions, or possibly address translation)
  * programmable bus/interrupt controller
  * automatic ram and device discovery and configuration
  * watchdog timers for preemptive scheduling

I'm classifying as large-scale those architectures that are 32--64-bit, a full and elegant instruction set, 16+ general-purpose architectural registers, and may be parallelized.
I'd be embarrassed not to be able to bootstrap an assembler and linker on a device this big.
Bootstrapping a high-level systems language, should also be possible, as should a dynamic linker.
By now, housing/enclosure will likely become absolutely necessary.
  * VAX
  * DEC Alpha
  * MMIX
  * ARM
  * Cray-1
  * looking for more...
The features of large-scale architectures are diverse, so I'll list some ideas:
  * virtual memory
  * discoverable memory and devices, supporting automatic configuration by the OS
  * live reconfiguration of devices on a separate peripheral bus
  * instruction and data caches
  * cache snooping
  * pipeline
  * superscalar
  * register renaming

After large-scale designs, we're looking at wild experimentation.
  * kernel-mode-only registers
  * dataflow execution
  * "hyperthreaded" block bus transfer
  * computational RAM
  * "virtual compute units" --- like virtual memory, but with on-the-fly reconfigurable circuits
  * I have no idea what else might be interesting...

## Manufacturing

In circuit manufacturing, there seems to be a few ways to "level-up".
The direction of level up could be from prototyping to mass production, or could be from low-abstraction to high-abstraction.

### Integrated Circuits

1. Logic gates: and, or, not, shottky diode, oscillators, &c
1. (EE)PROM, (S/D)RAM
1. PLA/PAL/GAL: programmable sum-of-products (obsolete, apparently)
1. CPLD
1. FPGA
1. ASIC
1. Microcontroller
1. Microprocessor

### Connections

Connections fall into two categories: "permanent" and configurable.
By "permanent", I don't mean that it's hard to pull apart and put back together, but that it's not meant to be altered before or during normal use.

1. Breadboard
1. Perfboard (dot/strip)
1. Wire-wrap
1. PCB (custom order, hand-made)
1. [BEOL](https://en.wikipedia.org/wiki/Back_end_of_line) (back end of line)

jumpers&headers, sockets&cables, card/slot

An essential part of connection is labeling all of the terminals.
Obviously, configurable connections should be labeled so that a user can, at a glance, 
Even for permanent connections, this is important so that you know which parts are to be soldered where.

### Enclosure

### Signaling

As clock speeds get higher (or, more generally, as precision becomes more important), there are apparently things that become more and more of an issue.
Things to note include: signal noise, voltage stability, current supply, timing regularity, noisy transitions, thermals.
Effects that can contribute are outside interference, stray capacitance, reflectance, differential wire delays, switching delay.

At this point, I don't really know what I'm looking for.
