# Classification of Data Structures

Data synchronization is a fundamental issue in computing but has recieved relatively little theoretical attention.
Note that I use "data synchronization" to cover cases of data storage data transmission (between two different machines separated in space), data storage (between two different times within a single machine), and combinations of both.[^spacetime]
Today's software for data synchronization (XML, JSON, SQL, &c) are essentially ad-hoc[^At first, it may seem that SQL is on solid ground with the relational algebra, but the theory behind SQL is primarily about data query rather than synchronization, and so different RDBMS have a wide variety of extended data structures that can be stored.]
What we need is a fundamental theory about what counts as a "data structure" beyond an arbitrary collection of bits, the same way that the lambda calculus is a fundamental theory of computation beyond arbitrary reduction systems.

[^spacetime]: This viewpoint is motivated by relativity, wherein space and time are not merely two things which happen to be thought of together, but are actually two names for the same fundamental thing --- spacetime. That is, what you call space may be what I call time, the same way your left may be my forward.

## Mathematical Foundations

It seems to be that the qualifying attribute for a data structure is its ability to contain meaningful information, possibly in the form of additional data structures.
A subtle part of this idea which we should address before moving on is "meaningful".
In formal semantics, meaning is nothing more than an equivalence class over the formulae in the language under study such that the Principle of Compositionality is satisfied.
Here, we use the Principle of Compositionality to mean that when two equivalent items are placed into the equivalent contexts, the results are also equivalent.

There is already a theory of containment with an equivalence relation --- set theory.
Understanding what makes data structures special might be helped with a breif examination of set theory.
  * Sets are an extremely low-level idea in mathematics.
    Even simple data structures such as the ordered pair can be encoded with sets in multiple ways, none of which are particularly illuminating[^unless you count the cleverness in pursuit of parsimony].
    Data structures in practice tend to be built on slightly higher-level concepts.
  * Set theory usually takes a keen interest in infinite sets, and equality of infinite sets is not a difficulty.
    Data structures, on the other hand, are usualy finite, though it is going to far to say that all data structures are finite.
    Programmers comformatble working with lazy langauges will immediately note that data structures should be able to account for codata, e.g. infinite streams, infinite trees, infinite maps.
    The natural way to encode these infinite structures is through algorithms, but this presents a problem.
    Once general algorithms are allowed as constituents of data structures, equality becomes undecidable.
    That would be too great a disadvantage, since the whole idea behind data structures is to make the information (i.e .equivalence class) easy to access.
  * Sets are the only objects in set theory, even the counting numbers are encoded as particular sets.
    Although it would be possible to make similar encodings with data structures, it would be far more straightforward to allow for primitive data.
    The exact choice of primitives would vary on the use case, but we can stay flexible by parameterizing on the choice of primitives.


# NOTES

It's a language for data transmission, which implies (space/time) distributed computing, so the question of who does the computation is important.

What is more general? I.e. homogenous is heterogenous where all the items happen to be the same type, or unordered is just ordered where the ordering is meaningless.

Is automatic equiality testing actually important? What would it be important for? Perhaps I simply mean that there shouldn't be any data-hiding in data transmission languages.

* finite vs. infinite (data vs. codata)
* typed vs. untyped vs. dependently typed
* equality should be automatically derived (as a free tree theory)
* sets vs. multisets
* ordered vs. unordered
* homogenous vs. heterogenous

Perhaps there should not be infinite, but you should be able to use functions for data compression.
Or perhaps more to-the-point is the idea of a template: the parameters of templatescannot be inspected, and templates are neither parameters to nor results of other templates.

Type systems are a cheap way of describign sanity checks that the data has not been corrupted in transit, and also a particularly rich system of self-describing media.

Units are necessary for recording measurements, but should they be a derived thing, or their own thing?