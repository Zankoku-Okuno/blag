# Notes on the Second Level of Understanding in Programming

The first level is an understanding of scope, references, and recursion --- the fundamental techniques of writing code.
In the next level of understanding, we want to find the fundamental techniques of organizing code.

## From SICP

SICP (section 1.1) claims that powerful programming langauges have three classes of mechanism for organizing ideas about computational proceses:

> * primitive expressions, which represent the simplest entities the language is concerned with,
> * means of combination, by which compound elements are built from simpler ones,
> * and means of abstraction, by which compound elements can be named and manipulated as units.

Their means of combination seem to include applying an operator to arguments.
Their means of abstraction seem only to be those mechanisms by which names are bound.
Overall, I'm not too happy with their definitions, as they are fuzzy enough to allow for these ideas, but also the misinterpretations I have made over time.

## From Philosophy

SICP also quotes John Locke,  An Essay Concerning Human Understanding (1690):

> The acts of the mind, wherein it exerts its power over simple ideas, are chiefly these three:
>   1. Combining several simple ideas into one compound one, and thus all complex ideas are made.
>   2. The second is bringing two ideas, whether simple or complex, together, and setting them by one another so as to take a view of them at once, without uniting them into one, by which it gets all its ideas of relations.
>   3. The third is separating them from all other ideas that accompany them in their real existence: this is called abstraction, and thus all its general ideas are made.

Certainly, SICP's breakdown is very different.

## My Own

I initially broke down thought into analysis, synthesis, and abstraction.
Probably I was influenced from somewhere, but can no longer find a clear reference to this breakdown.
In any case, seeing Locke's breakdown, I see I may in fact need to include relation as a method of thought.
On the other hand, relation may merely be a "mode of use" of synthetic thought, as relations in mathematics are simply sets of tuples.

Regardless of what the simplest operations of thought are, I want to know when best to deploy them.
Comparing two functionally equivalent samples of code, how do I determine which (if either) uses the better abstraction boundaries to organize itself?

It seems that compositionality (a.k.a. modularity?) is an important determiner.
It's said that category theory is the study of composition, so I should probably learn more about that.
The blog post [Category: The Essence of Composition][catcomp] talks about this at an introductory level.
Here it is on [wiki](https://en.wikipedia.org/wiki/Category_(mathematics)), and I'm not sure what [operads](https://en.wikipedia.org/wiki/Operad_theory) have to do with it.

[catcomp]: https://bartoszmilewski.com/2014/11/04/category-the-essence-of-composition/

[Category: The Essence of Composition][catcomp] also contains a nice idea near its end: "So what are the right chunks for the composition of programs? Their surface area has to increase slower than their volume."
Independently, I weant to ask: Givena program fragment, how much ofthe surrounding code do you need in order to understand it? The less, the more quickly and accurately humans will understand the code, and the less the computer needs to evaluate it.
These ideas are related,but grossly informal.