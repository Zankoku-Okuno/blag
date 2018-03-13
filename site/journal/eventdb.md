# A Write-Only Database

Pure functional programming emphasizes non-destructive updates.
In contrast, most databases use in-place aka destructive update.
Every update into one of these databases is therefore a loss of information, specifically, the information about what the database used to look like.


## Ideal Architecture

There are a set of event streams, each of which is a write-only log of events.
Each event from a stream, in addition to some metadata, contains data in a format determined by that stream.
The stream's format consists of a type that all data going into the stream must have, and constraints that further refine the type based on the runtime data available.

Substreams are views on streams that select out all and only those events that meet some predicate.
Substreams act just like streams on the outside, even writing to them is allowed, though the predicate will need to be met.

An automata is an independent processes that folds a stream into a different data structure.
These processes are online, and update whenever an event occurs on an observed stream.
Automata can also sendcreate new events as part of their processing.

The type of a stream can change over time.
These changes, as well as other structural changes to a stream (such as creation or deprecation) are recorded in a control channel separate from the data channel fo the stream.

The types of data supported are various primitives (possibly extensible), lists, records, and variants.
Codata (functions and infinite lists) are not supported.
Nesting these features can allow for complex data structures to be stored.
A particularly useful type of data may be the table: a list of records.


## Distributed Computing and Atomicity

It's possible to store encrypted data in the database but the encryption key elsewhere and not trust the database with decryption.
In such cases, it must be possible for a client to start a transaction, obtain information from the database, make a calculation which is then stored back to the database, and commit the transaction.

If we're going to have concurrent writes, then we'll need to face transaction timeouts, priority inversion, and all that.

Automata likewise might be outside the database process, and therefore outside of guaranteed bookkeeping.
After all, a browser interface that sends events to the database is just such an automaton.
So, how should we even detect that the information went into a new event's creation might be based on out-of-date views of that information?

If we're going to have constraints validated based on the states of automata, that makes transactions interesting as well.
Ideally, I'd like automata to run in their own threads, but they'd have to sync up on constraint-checking.


I wonder how the stock market handles these things.
After all, a trade is an event that has to be recorded, and probably has some atomicity requirements.
Also, how were inventories and mail order handled back when it was paper-based?

I really don't want to have the user implement their own atomicity in the structure of their events.


## Stream Control