I'm just a stupid mathematician; I don't know what is meant by "closest possible world".

Well, let first decide on what a world is.
Presumably, a world is determined by all any only those facts which are true in that world.
As a first attempt, facts are propositions; therefore a world is a map from propositions to booleans `P -> Bool`.

There are already a couple of problems with this.
First, the set of propositions is determined by a choice of syntax (up to isomorphism).
Second, the set of maps `P -> Bool` includes maps which do not abide by commonly-used logics.
The first problem requires choice, thereby presuming the possibility of an alternative choice, and therefore requires a formalization of possibility even before we have developed this theory of possibility.
The second problem is merely one of taste, though I think most philosophers would be uncomfortable with impossible worlds (choosing a trivial logic would allow both `P` and `~P` to be mapped to true).
For now, we can simply skip over the problems and agree to use a intuitionistic first-order logic.
While that choice is perfectly useful, it does relegate us to a subjective view on possibility, so any theories based on ours will also be subjective.
There are plenty of other reasonable choices, such as using a constructivist logic, or augmenting that logic with some principles of physics (e.g. unitarity or continuity).
This does not bode well if we want to develop an objective measure of, for example, knowledge or causation based on possibility.
(FIXME: I don't want isomorphism between syntaxes (though that theoretically could be a thing if you allow finite or uncountable syntaxes), but homeomorphism between logics.)

We have chosen a logic where propositions have consequences.
Therefore, a simple map from propositions to booleans is too large to model the set of possible worlds.
Instead, we will define the set of facts as a partitioning of propositions into equivalence classes based on logical equivalence.
(Recall: a different choice of logic might give rise to different equivalence relations and therefore a different notion of fact, or might not necessarily allow us to construct meaningful equivalence classes at all.)
A world is possible when its map `P -> Bool` is consistent w.r.t. the chosen logic.
Since we are only concerned with possible worlds, we can simply define a possible world as a map from facts (as defined above) to truth values `F -> Bool`.

Now, we move to the notion of closeness.
In mathematical terms, this means establishing a metric: a distance function.
If we stretch the definition of metric slightly, we can get away with counting the number of facts where two given worlds produce different results.
We can do this because every world has the same domain, so the total number of facts between worlds is invariant.
We have to stretch the notion of metric if the domain is infinite: in such a case, the metric won't only produce finite numbers, but may produce infinite cardinals.
There's a perfectly good notion of infinite cardinals, so I'm not worried.

There is a problem with this however, and it again relates to choice.
The metric described above was only one of many possible choices.
In particular, we might decide that some facts matter more than others (e.g. whether the Holocaust happened is more important than whether my shoelace is untied; sorry/not-sorry to Godwin's law it).
We might then give a valued weight to each fact, and the metric would sum the weights of all the differing facts (we now require our metric to have a domain in the hyperreals, but again, there is a perfectly good theory of these).
Again, there are many reasonable choices, and the metric is another place where subjectivity is injected.
For now, let's continue with the original definition of the metric.

Now that we have a notion of distance, we can consider the problem of "closest".
In the metric we have chosen, there is not necessarily a unique closest world.
For example, if worlds were determined by three facts, then the world `W = [True, True, True]` would have distance `1` from `W'a = [True, False, True]` and also from `W'b = [True, True, False]`.
To always have a unique closest possible world, we would need to arrange all possible worlds in a line (i.e. a total order), but given the apparent complexity of the world, there is no compelling choice of order.
Luckily, if the worlds are determined by many facts, then the odds of two worlds being equidistant from a given third are low.
This feature might allow us to obtain some utility from an approach considering _nearer_ possible worlds, though it will need to account for edge cases.

We have now elaborated intuitive notions of "closest", "possible", and "world" into established formal theory.
It is subjective, but if we are willing to agree on reasonable premises (a choice of logic and metric), then that isn't likely to be a problem in practice.
It does have problems in some cases, but if we don't rely heavily on uniquely closest worlds, then given the apparently large number of determining facts for a world, those problems will be unlikely to be relevant in practice.
This bodes well for its application in many domains, such as linguistics or decision theory, as long as approximate solutions are acceptable.
However, the theory closest possible worlds as it stands is unsuitable as a foundational theory.


There is one particular problem with applied closest possible worlds theories I would like to highlight.
If we are interested in physically possible worlds, then we must include physical law in our choice of logic.
It is not unreasonable to assume that the laws of physics determine an analytic world.
That is, if a function is known to be analytic, then the entire function can be uniquely reconstructed using only knowledge about a (any) open subset of the function.
The true laws of physics may not be analytic, but it is a dream of physicists which has not yet been dashed.
If this is the case, then the world is determined by only one fact (the path through state space, which itself is determined by a single point on that path).
As state spaces are quite intricate (and in fact are usually infinite-dimensional), distance, if it could be defined at all, might not be relevant.
