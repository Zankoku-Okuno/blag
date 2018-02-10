# Toolchains

In the bad old days, being a competent programmer meant being literate, having a user manual, and the ability to punch holes in paper.
This method of programming can no longer feasibly meet the demands of programming today.
The push to achieve faster development times with more reliability and faster performance all at the same time has required programmers to adopt --- and expect --- a massive range of tools: a toolchain^[I'm not sure why it's called a "toolchain" instaed of a "toolbelt" or a "toolbox"; I'm not even sure if there even is such a thing as a physical toolchain to that people put their tools on (in?).].
We should never forget however, that the final artifact of programming is still essentially a pile of punch cards; a toolchain just means we don't have to do it manually anymore.

The question is, what should be included in a toolchain?
We all feel like we have a good idea of what a toolchain is, but as begin compiling a description, I realized that a complete answer is big.
At the same time, the different parts of a toolchain follow a kind of organization.
We can follow this organization while investigating proven toolchains for a number of languages to find out what what the ideal toolchain would look like.

The result is not just a big list of resources for programming tools, but a toolchain rubric.
The rubric can help those embarking on learning a language as a curriculum of questions to ask to become a more effective programmer in that environment.
It can help evaluate different languages against each other based on their tooling support by minimizing selection biases.
I could also help language designers as a to-do list of tooling that potential users will expect and the beginnings of documentation for thosse tools.



@[toc](Contents)


## Questions (DRAFT)

What environment(s) does the language get used in?
What is the particular niche of the language?
Are there major dialects?
What is the packaging system?
How are dependencies acquired and linked into a program?
How are packages distributed? Do packages tend to be source or binary?
Are there any particular advantages or disadvantages compared to other languages in the niche?
How do you test an artifact for deployability on other systems?
How do you generate API documentation?
Are there additional static analysis tools?
Are faults in the language commonly covered by libraries? Which ones?
Note some recommended learning resources.

## Learning Goals

## The Environments

TODO: server/desktop, mobile, browser, hardware

TODO: computation, business logic, systems programming, data storage, prover, typesetting

TODO: what do I do about constraint programming? theorem proving (coq, isabelle)?

## The Languages

### Haskell

ghc, cabal, stack, ghcjs

* [What I Wish I Knew When Learning Haskell](http://dev.stephendiehl.com/hask/)

### C

gcc, llvm

### SQL

sqlite3, postgresql

### VHDL

ghdl, gtkmake

#### Learning

* [What every software programmer needs to understand about hardware design](https://www.nandland.com/articles/what-software-programmers-need-to-understand.html)
* [VHDL GUIDES](http://www.ics.uci.edu/~jmoorkan/vhdlref/)
* [A structured VHDL design method](http://www.gaisler.com/doc/vhdl2proc.pdf)
* [Nandland VHDL Tutorial](https://www.nandland.com/vhdl/tutorials/index.html)


### Rust
### Java/C#
### Kotlin
### TeX & Friends
### Python
### Arduino
### Javascript

node, npm, webpack, babel

### Elm

style-elements

### R
### Erlang
### Assembly