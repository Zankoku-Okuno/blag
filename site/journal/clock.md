# A Well-Tuned Clock

It seems that timing and cycles are important for humans to locate themselves in their time direction.
As such, I should design for myself a clock that suits my orientation in time and is attractive given my interests.

## Design

It should be a 24-hour clock, with noon at the top.
The existing 12-hour clocks make fitting blocks of time into a day difficult by rolling over during times when I am normally or often active.
A 24-hour clock will better allow me to approximate my time planning and usage day-to-day by simple visual inspection.

Notes for day-planning could be taken around the periphery of the clock.
Tasks could be dragged onto one or more hours.
A checkbox by each task would help identifying what is left to do.

Years pass by unnoticed; this has to do with the lack of intuition in our linguistic notation for dates.
My clock should note the time of the year in a purely visual way: using a pointer travelling around a cycle.
The pre-existing art here is to use an ecliptic, as in an astrolabe.
This has the added benefit of my being able to visually estimate sunrise/sunset; note that daylight hours are an important consideration for some tasks.
I am interested in astronomical phenomena, so this astronomy addition is quite pleasing.
The clock will therefore require my latitude and information about daylight savings.

Knowing the weather is important on a daily basis to determine my carrying an umbrella and wearing coats.
If I know temperature, precipitation, wind, and cloud cover, I should be pretty good.
I haven't decided on actual temperature or adjusted for wind chill &c.

Knowing where the sunlight hours are could come in handy when dealing with daylight-based scheduling constraints.
Although sunrise/sunset should be estimable from the ecliptic and altitude lines, it'd be much easier to just read it off from some lines.

I've always wanted to learn stars but I don't have a good method.
Integrating a planisphere into the clock should do the trick.
If I'm ending up with a computer-clock, then I could also mark the planets, something which would be extreemly difficult in a mechanical clock.
Knowing the phase of the moon would also be cool.

The day of the week should be given, but I am undecided as to how to accomplish this visually instead of using day-of-week names.

In addition to visual estimation, the clock should allow detailed times to be known so as to better coordinate with other's or fixed schedules.
I have not explored methods for this, other than to integrate a standard clock as a smaller component.
If ever I end up collaborating across time zones, I'd like the ability to have more than one standard clock, each set to a different timezone.

There may also be some benefit in including a Baha'i calendar so I'm not so surprised by events.


## Notes

what is local sky projection?

[Astrolabe Manual](journal/Astrolabe_the_Missing_Manual.pdf)

[Dark Sky API](https://darksky.net/dev) looks like a good place to get some weather info


### Stereographic Projection

A.k.a. planispheric projection?

An important property we'll use is that stereographic projections preserve circles (also angles, though we won't use that).
The projection is defined from point $P$ on a sphere to point $P'$ on the plane through the sphere's equator.

<svg width=200 height=200 viewBox="-1.1 -1.1 2.2 2.2">
    <circle cx=0 cy=0 r=1 fill=none stroke=#000 stroke-width=0.015 />
    <line x1=-1.1 y1=0 x2=1.1 y2=0 stroke=#44C stroke-width=0.005 />
    <line x1=0 y1=-1 x2=0 y2=1 stroke=#44C stroke-width=0.005 />
    <line x1=0 y1=0 x2=0.920 y2=-0.391 stroke=#000 stroke-width=0.005 />
    <line x1=0 y1=1 x2=0.920 y2=-0.391 stroke=#000 stroke-width=0.015 />
    <text x=-0.03 y=-0.03 text-anchor=end font-size=0.15>O</text>
    <text x=-0.03 y=0.95 text-anchor=end font-size=0.15>O'</text>
    <text x=1.04 y=-0.02 text-anchor=start font-size=0.15>I</text>
    <text x=0.950 y=-0.421 text-anchor=start font-size=0.15>P</text>
    <text x=0.65 y=0.15 text-anchor=start font-size=0.15>P'</text>
    <line x1=0 y1=-0.391 x2=0.920 y2=-0.391 stroke=#0A0 stroke-width=0.005 />
    <text x=-0.03 y=-0.391 text-anchor=end font-size=0.15>A</text>
</svg>

Let $R$ be the radius of the circle $O$ and $\theta = \angle IOP$
Given $\theta$, solve for $r = \lVert\overline{OP'}\rVert$.

Note that $\triangle O'AP$ is similar to $\triangle O'OP'$ so that ${\lVert\overline{OP'}\rVert \over \lVert\overline{O'O}\rVert} = {\lVert\overline{AP}\rVert \over \lVert\overline{O'A}\rVert}$.
Using trigonometric definitions, ${r \over R} = {R\cos\theta \over R + R\sin\theta}$.
With a touch of simplification, we find $r = {R\cos\theta \over 1 + \sin\theta}$.

### Ecliptic

In the left of the figure, a cross-section of the Earth is given, with the equator in red, and Tropics of Cancer and Capricorn in blue and green respectively.
The ecliptic is defined^[more properly, the tropics are defined by the observed ecliptic, but math don't care] as a (particular) great circle osculating the two tropics.

<svg width=400 height=200 viewBox="-1.1 -1.1 4.4 2.2">
    <circle cx=0 cy=0 r=1 fill=none stroke=#000 stroke-width=0.02 />
    <line x1=-1 y1=0 x2=1 y2=0 stroke=#D00 stroke-width=0.02 />
    <line x1=-0.920 y1=0.391 x2=0.920 y2=0.391 stroke=#0A0 stroke-width=0.02 />
    <line x1=-0.920 y1=-0.391 x2=0.920 y2=-0.391 stroke=#00C stroke-width=0.02 />
    <line x1=-0.920 y1=-0.391 x2=0.920 y2=0.391 stroke=#000 stroke-width=0.01 />
    <g transform="translate(2.2,0)">
        <circle cx=0 cy=0 r=1 fill=none stroke=#0A0 stroke-width=0.02 />
        <circle cx=0 cy=0 r=0.66188 fill=none stroke=#D00 stroke-width=0.02 />
        <circle cx=0 cy=0 r=0.43809 fill=none stroke=#00C stroke-width=0.02 />
        <circle cx=0.28096 cy=0 r=0.71904 fill=none stroke=#000 stroke-width=0.01 />
    </g>
</svg>

On the right of the figure is the stereographic projection.
Recall that stereographic projections preserve circles, therefore the ecliptic is still a circle after projection.
Projective geometry also preserves tangency, and so the projected circle will also osculate the tropics in projection.

Given two circles of radii $R_1$, $R_2$ centered on the origin, the radius $r$ and magnitude of displacement from the origin $c$ of an osculating circle are given by:
  * $r = {R_1 + R_2 \over 2}$
  * $c = {R_2 - R_1 \over 2}$

An astrolabe (or astronomical clock)'s perimeter is given by a tropic (which one depends on hemisphere).

#### Grading the Ecliptic

<svg width=200 height=200 viewBox="-1.1 -1.1 2.2 2.2">
    <circle cx=0 cy=0 r=1 fill=none stroke=#000 stroke-width=0.015 />
    <line x1=-1 y1=0 x2=-0.6 y2=0 stroke=#44C stroke-width=0.005 />
    <line x1=-0.6 y1=0 x2=1 y2=0 stroke=#000 stroke-width=0.015 />
    <line x1=0 y1=-1 x2=0 y2=1 stroke=#44C stroke-width=0.005 />
    <line x1=0 y1=0 x2=0.5 y2=-0.86602 stroke=#000 stroke-width=0.015 />
    <line x1=-0.6 y1=0 x2=0.5 y2=-0.86602 stroke=#000 stroke-width=0.015 />
    <text x=-0.03 y=0.15 text-anchor=end font-size=0.15>O</text>
    <text x=-0.60 y=0.15 text-anchor=end font-size=0.15>O'</text>
    <text x=1.04 y=-0.02 text-anchor=start font-size=0.15>I</text>
    <text x=0.53 y=-0.89602 text-anchor=start font-size=0.15>P</text>
</svg>

Given $R = \lVert\overline{OP}\rVert$, $\Delta c = \lVert\overline{OO'}\rVert$, and $\phi = \angle IO'P$, find $\theta = \angle IOP$.
From [Solution of triangles](https://en.wikipedia.org/wiki/Solution_of_triangles#Two_sides_and_non-included_angle_given_.28SSA.29), I see that I have a side-side-angle situation^[Good job mathematicians for avoiding "angle-side-side"].
Let $\alpha = \angle O'OP$ and $\gamma = \angle O'PO$.

Read off that $\sin\gamma = {\Delta c \over R} \sin\phi$ and $\alpha = {\tau \over 2} - \phi - \gamma = {\tau \over 2} - \theta$.
With some rearrangement, we get $\theta = \phi + \arcsin({\Delta c \over R}\sin\phi)$.