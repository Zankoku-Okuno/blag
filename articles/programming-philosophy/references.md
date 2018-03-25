# References

Let's be sure we're both talking in nnormal English.
You know what the verb "to refer" means, right?
Well, I'd have to do to a dictionary to articulate it, but we both know what in means.
We also know that it's a transitive verb, i.e. X refers to Y.
Referring is done by name^[or some other sort of identifier like address, but let's stick with "name" for simplicity. After all an address is the "name" of a owned piece of land.]/
The "reference" a name used to refer to something somewhere else, and and the "referent" is the thing that name refers to.
This is all perfectly normal English and you already know all of it, even if you couldn't have described it before.

With that in mind, take a small piece of code, say a twenty-line JavaScript function, and find every reference and referent.
You will very likely fail, because in computer science, names don't always look like human names, and in high-level languages, you let the language make and use a lot of those names without seeing at them yourself.


------------

It is easy to screw up the distinction between the reference and the referent^[Don't belive me? Talk to me about "Ceci ne pas un pipe."].

If you can't even count the references in a small piece of code, how can you claim to understand a large piece of code?

Where references are necessary, we should strive to make them visible in the source code.
The more references are visible in the source code, the more easily we can think about the semantics (i.e. operation) of those references.
Admittedly, that will make a lot of normal programming more verbose and therefore seem more painful.
Then again, a lot of code is already painful because references were used incorrectly.
