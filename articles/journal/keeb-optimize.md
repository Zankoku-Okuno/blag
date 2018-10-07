# Keyboard Optimization

## Reason

My current keyboard is a tenkeyless with outemu blue switches.
These are the best blue-style switches I've used, but I still think blue switches are just "lazy".
The Razer switches have about the same force and feedback, but they actuate just a little earlier, and that tiny change makes them feel wonderful.

Unfortunately, all the Razer keyboards are designed for "gamers", and they can't be configured unless you're on Windows.
Well, I'm not buying an operating system just to get the most out of my keyboard, and I can't stand the visuals.
Surely there's a market for gaming keyboards that don't look like an off-brand replica of space marine armor?

Also unfortunately, I couldn't find a way to order the switches from the manufacturer.
So, the only way I can get these switches on a different chassis is to canabalize them from a full Razer keyboard.
I found a refurbished keeb on ebay for half the retail price and went ahead and got it, figuring I'd do something with it later.


## Method

Since the family was out of the house this weekend, I decided I now had enough quiet time to desolder my Razer switches from their prison.
Of course, I've never soldered anything before, or desoldered anything, so here's a new experience for me.

After disassembling the keyboard case, I went and got myself a soldering station and some desoldering wick.
I set to work removing my first switch, and ended up not even being able to get the solder to melt.
After adding a bit of my own solder to the joint, I managed to get my first switch free...

...by absolutely tearing it apart in anger with a pair of pliers.
After reading a bit, I discovered that flux might help, and so might adding a bit of leaded solder^[I also learned that lead-free solder can contain worse materials than lead in the flux, so now I don't know what solder is safer...].
I also discovered that most keyboard enthusiasts go straight for a solder vacuum instead of the wick; annoyingly, I was thinking about buying one while I was at the store, but now the store is another 20min drive away, and another 20min back.

But, the hardware store around the corner did have leaded solder and solder flux.
Over the course of the next five hours, I managed to get a total of seven switches off the board while using up nearly all of my desoldering wick.
It's not really the switches themselves that gave me the worst time, but the LEDs mounted in them.
The holes they were mounted in were just too small for me to really get into them.
Maybe that's my equipment, or maybe it's just my (lack of) skill.
Either way, it was clear to me that I'd never get enough switches out to justify the time sink.

So, the next day it was back to the store for a solder vacuum, and anything else that could possibly help, however tangentially.
In the next four hours, I removed the remaining hundred switches from the board, which comes out to a 18-fold speedup.
In fact, I removed the final 18 switches in 15min, so the real speedup is more like 50-fold.

Again, the LEDs were the most annoying part, but I found a way around them.
It's a shortcut that relies on my not needing a clean PCB^[I'm not going to use it, and I've melted the thing probably to death anyway].
Instead of desoldering the LEDs, I added a solder bridge between the two leads and used that to heat all the solder on each LED at once.
I was therefore able to pull the LED straight from the liquid solder and not worry about the cleanup.

I eventually decided on an assembly-line-style procedure.
I went row-by-row, adding the solder bridge over each LED.
Then, I used the soldering iron on top and tweezers underneath to pull the LED.
Next, I sucked the solder off the switches.
Finally, I flipped the board over and used a switch puller to get them off the plate.
Repeat for each row, and next thing you know I have 107 switches ready to be used elsewhere.


## Result

My tenkeyless is in fact a Zhuque keyboard that lets you swap switches without soldering, or even opening it up.
So, after dinner I sat down to a podcast, unplugged my keyboard and changed out all the switches.
I thought I'd change out some of the keycaps to the Razer ones as well (to give a nice black-and-white effect), and though it looked a little better than plain white, I had forgotten how much I'd hated the Razer keycaps.
It turns out that Razer makes keycaps that feel sticky, like half-melted chocolate.
So, it's back to the white keycaps for now, at least until I get a fancy set in the mail some time in the next couple of weeks.
Although, it was too much for me to resist replacing the arrow keys with hjkl, can you spot the vim user?

Once I got to typing on it, I was immediately pleased with the responsiveness^[so pleased, I felt compelled to write this just to have an excuse to play with it].
It's not a modification that I'll notice all the time, but I expect my future self will thank me anyway.
After all, I didn't notice anything spectacular when I got my first mechanical keyboard^[a tenkeyful with Cherry browns], but now I'm not sure how I ever typed on standard keyboards without nausea.

The next steps will involve things like learning CAD on linux so I can design a case, getting some steel laser-cut, and soldering a bunch of diodes together onto a microcontroller.
But for now, I'll just chill and be happy with the improvement I've made so far.
