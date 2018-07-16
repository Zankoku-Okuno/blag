# Review Spring 12018

## Sisyphus

I need a name for my system that will last over its (my) lifetime.

I had a thought, possibly in a dream, that reinterpreted the story of Sisyphus.
Instead of highlighting the caprice of the Greek gods, the polish of the boulder was indicative of a person's character.
As the boulder is pushed up & rolls back down, it becomes rounder and smoother.
Instead of representing life as a futile endeavor, it shows that the work of life is something to take pride and joy in.
Honestly, what I've written doesn't capture what I was thinking, so I doubt anyone else will understand the idea I'm trying to get across.

In any case, it's a good name.
Eternally doing work, though it will never be finished, and (with this new idea) through doing the work becoming a more fully realized me...
I think that sums up the objective.

Speaking of Sisyphus, it seems my systems last about six months before they start failing.
Perhaps I get around this by removing them all and rebuilding them, or otherwise doing a massive reshuffling.
It's like present me is a new CEO coming in and wants to assert their authority and show how much better they are than the CEO that was past me.
In any case, I think the seasonal review may have just saved Sisyphus.
There are a bunch of obvious problems that I've just gotten used to.
After a season-full of roughly the same system, taking a step back turns out to have been essential.


## Focus

I've struggled with motivation this season, and I think that comes down to not understanding focus.
I introduced focus to Sisyphus last season, but I think I got lucky in January.
By now, it's obvious that weekly focuses are not working, and that I'm having a hard time remembering my monthly focus.

One thing that helped this season was separating the focus from my task list.
This way I'm not thinking about my focus in the same way I think of tasks: as chores I "have" to do.
I think focus is meant to be there as a reminder that I _do_ have things I _want_ to do if I'm ever at a loss for something to fill time with.
I'm going to have to re-orient my perspective on focus as a set of proposals for action rather than a checklist of actions to perform.
I still want to check on my focus, though, and I think that can be done with crafting a question as in Cortex 66 (Triggers).
I'm not entirely sure on these, but the underlying principle is to prevent lists from demotivating creative work.

Another facet of the focus-isn't-a-checklist principle is that the items in my focus should never be discrete tasks to be finished.
Something I thought I wanted this year is longer cycles of action, but I'm not so sure anymore.
I think it's more important to be able to resume tasks without much loss from re-loading them into memory rather than trying to complete an entire project in one go.
If I can manage it, I'll then be able to make progress on multiple fronts concurrently, and not feel so guilty about switching tasks.

I'm experimenting with an "unfocus" for things I don't want to get distracted by, but I'm not sure that's a great idea.
For example, I wanted to focus on building a breadboard computer, and thought I didn't want to get distracted by building a programming language.
Shortly after making that decision, I stopped working on my computer and built the infrastructure to build programming languages.
I think the unfocus, used in this way at least, is reminding me of worthwhile things I want to do, while also trying to stop me from following my inspiration.
I think I should use the unfocus as a list of things I know I'll be ashamed of if I make progress on them: like watching YouTube, or playing unintentional games.

Possibly the biggest problem with focus is just remembering that it is there.
I think I had something physical getting in my way in January, and that may have been why it was successful then.
There are two timescales that I need to worry about here: monthly and weekly.
For the weekly focus, I think the left-hand side of a spread is more visible, so I think I'll put the focus there, and make sure it's nice big and colorful; I'll see how it goes.
As for the monthly focus, I think I need to de-improve Sisyphus and go back to having a loose sheet of paper floating on my desk instead of burying it in a notebook I've optimized to only ever look at weekly.


## Garbage Collection

One weekend this season, I skipped garbage collection.
It didn't turn out too bad, but I did have to spread out some of the process over two more gc cycles.
After skipping another week to see if I was right, I wasn't so impressed, but it did get me thinking.

Doing all my garbage collection in one day is reminiscent of stop-the-world garbage collection.
In week 19, I could have been doing interesting stuff over the weekend, but was distracted by the pressure of garbage collection.
The obvious solution to latency from stop-the-world gc is incremental gc.

My goal is to spend about an hour a day each weekend doing garbage collection.
Too much gc is too much overhead, and too little loses things.
So far, I've noticed that my gc checklist is inadequate: instead of storing booleans, it needs to store the date a particular gc action was last performed.

I also want to try to reduce that amount of stuff I think I shouldn't lose track of.
This is analogous to physical de-cluttering.
That is, "Does this spark joy?" is a good question for intellectual organization as well.
If it doesn't, then it doesn't need follow-up, and can be ignored during gc, or it can (lazily) be archived/discarded out of other Sisyphus subsystems.


## Journal

I ended up with 72% on my entry-every-day goal, which is not a great success, but it's not so bad.
I think a lot of that comes down to having the feeling that I don't want to journal when I am reminded.
I don't want to feel guilty about failing something which is not actually that important in the first place.

Don't get me wrong, though, there have been times when it was essential to have a journal to write in.
One thing that the journal has clearly helped with is with exploring ideas that have a high likelihood of being discarded.
Starting Night 22 May 12018, my journal is overrun by thoughts about digital design.
It gave me a chance to get things out of my head and see the problems more easily, or to see that there aren't so many problems and I should just get up and do a proper design.

I'm removing any goal for a regular journaling schedule.
I'd still like to remember that the journal exists though.
I'll therefore continue collecting data on my journaling habits as part of garbage collection.
This reduction in journaling could be seen as an example of "Does this spark joy?".


## Facts about My Self

My special skill is semantics.
Recall that a semantics is an equivalence class over a language subject to the principle of compositionality.

I think something that slows me down or turns me away from books is that whenever I'm consuming something, I'm thinking about how I could create something like that.
If so, that would explain why I end up writing in styles that I've recently read, and why it's painful to read things that are so bad or wrong.

In a dream, I think I discovered a design tension within myself.
As an engineer, I like when the parts of a system have one of a few clearly defined functions and each part operates only to serve its given functions.
As an evolutionist, I know that a population's stability is dependent on its genetic diversity.
The tension comes when examining a living population as composed of parts.
I guess the tension is resolved when we recognize that engineered systems are simple: too simple to have high stability.
The question is, in what way to we complexify designed parts in order to allow for device population diversity and thereby achieve stability of technology?
The dream is summarized in my journal, Eve 22 May 12018.

## Stillness and Awareness

For about a month, I put "Stillness" on my focus.
It seems it was useful while I had it one there.
In particular, it has helped me get a little bit of work done, which was then the inspiration I needed to continue on to large projects.
Little tasks may be where stillness shines: immediate work on large tasks without planning (at least head organization) can lead to inefficiencies down the road.

## Actions

In my social life, this season saw my sis' wedding celebration.
That meant I got to spend some time with my uncles, Mark, and Seian&Leslie.
The Atlanta Pen Show was also this season.
Seeing people I'd only known from online was surreal, but also reassuring to see that the really are the people they portray themselves as online.
I also made a number of unexpected friends there, though despite some of us agreeing to meet soon, we still haven't.

Speaking of pens, I've tentatively stepped into ink mixing.
I've successfully reproduced Wakakusa, and I'm working on a Iroshizuku-based red.
My first attempt turned out with a fascinating wine color which varies dramatically in different contexts.
I'm still making my way through the sample I made up.

Binder clips on the Midori have been really useful.
Not only can they mark many pages and make it easy to flip between them, but I can clip a pen on the large binderclip, alleviating the need for a pen loop.

I read Addy Pross' book "What is Life?", and it completely opened my mind to a realm of thought about how living systems are distinct from non-living ones.
Given that I am all-in on the idea of memetics, the ideas there can also apply to understanding societies.
Thanks to my note-to-self system, I've managed to write down these ideas.

I made progress on some basic programming projects.
I finally figured out what is going on with `inline` in C, so I put it some work simplifying and expanding predithmatic.
I also had a thought about how to implement regular expressions with backtracking using derivatives, so I implemented a rough draft of just such an engine.
After getting annoyed at the lack of portability in the C standard, I switched to working on [`cvm`](https://github.com/Zankoku-Okuno/cvm).
I had enough of a novel approach that I started it over, so I've renamed it to `prokaryote`, but I got stuck on IO ports vs. parallel processing, which indicated to me that I needed to learn more about real hardware.

I spend the rest of the season deep in computer hardware.
I read the rest of "The Art of Digital Design", as well as some more of "Structured Computer Organization".
I designed an architecture, which I've called Sigma8, for my first computer build.
I learned Verilog to try to help me design the microarchitecture, but I didn't make much headway there.
After some fiddling around with different design methods, I landed on the idea of "throw hardware at the wall and see what sticks".
After being dissapointed and hurting my wrist using available digital design tools, I built by own breadboard CAD system.
I was amazed how easily it came together, and how much confidence it gave me to go forward with my build.
I've now designed the general-purpose register file and made progress on the ALU module.
I also built a timer module on a physical breadboard.


## Follow Up

Note-to-self is not providing value due to lack of categorization and filtering.

I don't think seasonalism (different kinds of work in different seasons) is really doing anything for me at the moment.
I've got so much to experiment with and so much to develop that spring/summer are getting in each other's way.

The categorization of actions might be more of a series of principles rather than true categorization.
For example, tasks must be perfective, but there's no requirement about then being/not being intertial or high activation energy.

On books: I'm amazed by how much Mom and Seian[sp?] read.
I'm not sure it's useful for me to start reading that much now, but I would like to think about reading more often.
I did read "What is Life?" last season, but didn't end up reading "Triggers".
I think I'll fix the latter one as soon as I can, since I'm working on improving my system at the moment anyway.

I'm still not sure why updating okuno.info has been so high activation energy.
I still haven't improved it, even though I've known I need to for three months now.
I did try rebuilding it for a moment there before basically giving up, since I didn't want to go through the work of porting it, and my categorization system seems to be in a highly unstable state.


## For Next Time

Pay attention to the several changes to my focus subsystem:
    * Focus is not a list of tasks.
    * Focus is a reminder that I have things I want to do, regardless of my mood.
    * Craft a [trigger](https://www.relay.fm/cortex/66) to ask about my focus rather than checking them off.
    * Get focuses into resumable states rather than trying to get them into finished states.
    * Use the unfocus as a list of things I know my future self will be ashamed of, rather than a list of things I'd be happy to have made progress on.
    * Did focus on the left-hand side of the spread work?
    * Did a loose-leaf monthly focus work?

For garbage collection:
    * Did I rebuild my gc checklist to account for dates rather than bools?
    * How did I do with my weekly two-hour gc cycle? Numbers, please.
    * Did I ask "Does it spark joy?"

Did I remember that my journal exists?
Did I get good use out of it?
Do I need to switch it for a sketchbook?

Did I try to meet with my pen friends?

Focus on stillness again, especially for small tasks.

Waking up is something that I need to optimize:
    * I like setting my alarm for ~0900.
    * Breakfast might just be acting as a break in my action before I even get moving.
    * What if I set my alarm to ask me what I would like to do with the next two hours?
    * How does the script on Even 8 April 12018 work w.r.t. Triggers?
