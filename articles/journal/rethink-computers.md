# Rethinking My Computers

I really don't have much of a workshop at home.
If I'm going to be building a computer^[or, as was my earlier idea, simply a keyboard], then I'll need some equipment to turn metal into a case.
I therefore decided to check out a local makerspace.

Sure enough, the people are good, they have a Bridgeport mill, and an there's electronic station including oscilloscopes.
Basically everything I could want except a metal bender (though, for all I know a table, clamps, and some skill will work just as well).
Really being there means making some new friends, which is a selling point in my book.
In fact, I may even take the opportunity to run some classes or workshops so I can get more teaching experience.

Once I was there however, I started thinking about how I would be using the space, and one thing stood out to me as missing:
I don't have a mobile development environment I can be proud of.


## Background

> Skip over this section if you don't want my sob story.

A few years back^[2013, perhaps?], my old laptop died and I needed a new one for school, so I popped over to the mall to grab a MacBook Air.
It's nothing special, but it works, and I was happy about the aluminium case and all-solid-state construction for a device that inevitably gets shaken and bumped as much as an everyday-carry laptop.
Nowadays though, I find myself using it less and less.

My "real" computer^[by which I mean both that it's the better set-up, and that it's a desktop] is one a friend and I built from parts which is running Ubuntu.
I've been trying to do most of my heavy work on there because I don't want to cram a laptop onto the desk and boot into a sub-par environment before I to do fun things.
This means there isn't much on my mac anymore, and that's a shame because what's the point of having two computers if you're only going to use one of them?

A year or two ago, I would've said Mac is fine---it is unix after all---but I'm currently wishing there was a proper package manager.
Sure, I'm using Homebrew, but compiling from source takes longer than setting down some binaries, and it's never felt solid to me, for whatever reason.
I don't like the mac's workspaces either: it seems designed to disrupt my spatial reasoning.
I'm also running an older version of the OS^[10.8, which is old enough to be called OSX instead of macOS] and I'm not immediately sure how to upgrade it.
Finally, the amount of effort that Apple has been putting in over the past year or so to enhance vendor lock-in is outrageous.
They've always been a bit stuck-up and proprietary (at least since I started using Mac: I was two), but this is getting silly.

So, I decided that it was time that I try a new Linux distribution.
So far, I've only really used Ubuntu, which is a shame considering I'd like to know more about how Linux works under the hood.
I did some reading up, and installed Mint with the Cinnamon desktop manager.
If I like it well enough, it'll displace Ubuntu on my desktop.

My first impression with Mint was "Wow, that installed quickly!".
Windows, Mac, and Ubuntu always take 40-60+ min to install, but Mint completed in 10-15, so I was actually unprepared for my post-installation work!
I just had to reconfigure some trackpad settings and enable a driver for the MacBook's wireless.
I decided to enable disk encryption because I hadn't tried it yet, and now I'm not sure why I didn't use it to begin with.
The one thing I truly don't like about it is the fact that Cinnamon only supports 1-dimensional workspaces instead of the 2d workspaces I'm used to in Unity.

Note from the future:
I ended up switching to Xfce as my desktop environment and got the 2d workspace grid back.


## The Workflow

The big picture is that I am managing my ideas.
Sometimes I have an idea I think is great, but then two days later I realize it's dumb.
Sometimes, an idea really has staying power.
Having both of these kinds of ideas mixed up means that I've gotten my project list cluttered, and that has negative impacts on everything I try to do.

Now that there is nothing on my laptop anymore, I was wondering what I should fill it with.
Except that there is one thing on my laptop: I am experimenting with a new OS.
So, I thought to myself, if I'm already experimenting with a new OS, why not make my laptop an experimentation platform?

When I want to learn a new programming language^[I've got four in the pipeline], or have some crazy idea for a library, or want to try out a new technology, I'll do that on my laptop.
I'll periodically review everything on the laptop, and if it's good enough (i.e. it's stuck around long enough), then I'll move it to my desktop for further development.

I'm a little ashamed to say it, but this answer has been staring me in the face the whole time:
this is exactly what happens in a generational garbage collector.
It's far too interesting to hold myself back from sharing it though!
Who knows how someone might be able to further apply principles from garbage collection algorithms to everyday life?

Now, you might be (but probably aren't) wondering how I'll reconcile a development environment with experimentation platform.
The fact is, if I want to experiment, I need frictionless access to my favorite development tools on it.
No inspiration survives contact with having to do something else first.
While I'm at it, I can use the opportunity to document my procedures for setting up an environment, not to mention experiment and improve them.
The two goals oddly seem to mesh nicely together.


## tl;dr

 *  *Avoid vendor lock-in like the plague.*
    Eventually you'll want to make some improvement or customization the vendor didn't think about (or actively thinks it's dumb even when it's not... looking at you, Apple), and then you're deciding whether it would be easier to move to the other side of the world than to change your OS.
 *  *Keep experiments separate from serious ideas.*
    When you want to do some lasting work, it's not worth getting distracted by some crankfile from three years ago.
 *  Where possible, *isolate exploration from daily use.*
    It one of those paradoxical improvements I love so much.
    You'll be both more secure---you won't accidentally bring down your critical tools---but you'll be more adventurous at the same time---because it doesn't matter so much if you have to rebuild a mere experimentation platform.
