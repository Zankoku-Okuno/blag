# On Type Systems

There is still some question of static vs. dynamic types in the computing community.
The arguments on this subject are generally terrible, which likely contributes to the lack of resolution.
Usually, it starts with some form of "Are static or dynamic langauges better?", and then respondents attempt to answer that question directly by showing examples of things each is capable of and incapable of.
A decent cost-benefit analysis requires something more rigorous.


Let's start at ground level: what physical artifact must exist to enable static typing?
Static typing operates as a tool in your toolchain.
So, we should immediately rephrase the question as "Is static typing a tool that enhances or hinders my work?"
Note that this question is far more specific and practical, but it leaves some terms unanalyzed.
First, a "tool" could be practically anything, which --- spoiler alert --- means that the eventual answer is "it depends"; and we'll see more about what it depends on later.
Second, what exactly _is_ the work of a programmer?
Obviously, a programmer writes programs, but that doesn't mean much unless we understand what a "program" is, or what it means to "write" one.

A program, when provided to a sort of machine we call a "computer"^[or the more descriptive, but more academic term "universal machine"], allows that machine to establish a highly-detailed system of causal relationships.
That sentence has more than its fair share of jargon, so let's untangle it.
A physical system can be acted on by external forces, and can generate forces on external objects; in computing, we call these "inputs" and "outputs", and usually the external forces are due to voltages on wires connected to our machines.
Often, without even thinking about it we also include the servos, displays, switches, &c attached to those wires as part of the system, so external forces might be the force of a finger on a keyboard, or the force exerted by photons leaving the pixels of a screen.
When certain output forces are caused by certain input forces, we say a causal relationship exists between those inputs and outputs.
A system of these causal relationships is a function from all possible inputs to the outputs, and unfortunately for us programmers, the range of possible inputs is wide, and usually effectively infinite.
By "highly-detailed" is meant that small variations in inputs could cause large variations in output[^chaos], but those variations should not be accidental.
If you're starting to feel an existential dread about the inconcievable difficulty of programming, then your mind is in the right place.

^[Chaotic systems are usually described as also having this relation, but it would be more accurate to say that chaos is when _infinitesimally_ small changes to the input can cause large variations in output. In computing systems, I merely mean "subjectively small to a casual human observer": variations at least on the order of a single bit.], but unlike chaotic systems, the input variations aren't too small.
That there is a causal relationship between certain input forces and certain output forces is simply 

Writing a program takes place in two parts.
The most obvious part is typing on a keyboard into a text editor or some other development environment, but that's also the least interesting as it regards static typing.
The other part is the mental act of programing which consists of selecting, from the space of all possible programs, one of the few programs that establishes the correct system of causal relationships.
This view on the mental act of programming is about as abstract as it could possibly be, but it doesn't need to be any more concrete.
The set of all possible programs is a search space, and these are well understood mathematically and in artificial intelligence.
What makes programming hard is that the search space is so large compared to the subspace of acceptable programs, and that each point in the space is a rich conterfactual concept all on its own.

To sum up, there's an infinite space of programs, each one of which represents an infinite system of causal relationships, and each relationship is between patterns of sets of a variety of physical forces.
- fragments can be composed - some fragments restrict the input space - we have a toolchain to help author, compose, restrict, describe and check our work


There are programs whose only purpose is to take in a wide range of possible inputs (such as any pattern of bits), and produce outputs that serve as a restricted range of inputs to another program (such as valid TCP packets).
It's this restriction that has so far allowed us to manage the incredible complexity of these systems.



what a programmer's work is is searching the space of programs for one that does what they want.
What is the probability of making an error conceptually or physically?
The hard part of programming is the counterfactuality: programs don't simply establish one causal connection, but a system of infinite related connections from all possibles inputs to outputs

Next, every tool is built for a purpose; what is the prupose of static typing?
Static typing is meant to check for the absence of certain kinds of errors.
That is, it prunes the search space, though this pruning is not too exact (if it could be, then the type system would be the ultimate programmer), so some valid programs are thrown out as well.



Type systems _are_ useful: the reduce the number of tests you have to write, and in their domain of applicability, they are infinitely more powerful than tests.
(That is a specific instance of a more general objection that type systems are over-sold. They may be over-sold, but that has no bearing on their actual effectiveness.)
Type systems don't have to be limiting.
Type systems actually speed you up (they check your work, reduce the amount of documentation needed).


Scheme has a type system: it checks scope, which is more than js can offer.
Old type systems (Pascal, Fortran78, pre-generics Java, Algol?) _are_ limiting.
Even moderately new type systems can be unhelpful, e.g. not checking for nulls, or having an Any type.
Functional type systems are better.

"Here's a million lines of code. Prove that there are no scope errors. Which is faster, doing it by hand or using a type checker?"

^[too-hard]: There is also a third objection with type systems that boils down to "I am much more experienced in dynamic languages, and don't want to put in the effort to learn a type system."
This is not a terribly interesting objection; the answer is "Too bad. Be a professional."