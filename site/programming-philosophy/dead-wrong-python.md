# Dead-Wrong Python

I've mastered Python well enough to recognize it as a poor language.
Don't get me wrong, the Python community is large, and that's a plus, but other languages have good communities, and the technical problems are too stupid to ignore.

## Fun With Conditionals

What will this script output when run?

```
import some_other_module
if True:
    print "Hello"
else:
    print "Goodbye"
```

Of course, it will print `Hello`; it doesn't matter what's in `some_other_module` since we aren't using anything from it---it's a dead import.
But... how about this one?

```
from some_other_module import *
if True:
    print "Hello"
else:
    print "Goodbye"
```

It should be the same: `some_other_module` is still a dead import.
Unfortunately for Python, it will print `Goodbye`.
Take five minutes (actually five minutes) to try to figure out what's in `some_other_module`.
I've put the answer in this footnote^[`True = False`] so as not to spoil you, but here's a hint: it's only one line of code.

Admitedly, this was fixed in Python 3, but the design should never have been that terrible in the first place.
The rest of the examples will work^[that is, they will fail] in both Python 2 and Python 3.


## Destroy All Code

You might know enough about how python objects work to know that `Foo().foo()` evaluates to `None`.
It's honestly not that hard to figure out... in a class with two one-line functions.

```
class Foo
    def foo(self):
        return 4

    def foo(self):
        pass
```

Most classes in python tend to be larger, say six 20-line methods.
I know from personal experience that the first time you encounter a bug like this, you'll lose at least a couple hours not realizing there's a second method with the same name.
After all, there's no indication during debugging to help you know why none of your code changes seem to be having any effect.
Finally, in frustration you will delete the method entirely just to show it who's boss---and still nothing changes!
Hopefully, you think to ask why there wasn't an `AttributeError`.

Well, know that you know this problem exists, it won't take that long to figure out.
It takes me about half an hour to remember this kind of bug; it just doesn't happen often enough.
Still, once you add up all hours lost by all the people who've run into this bug, we're probably talking about manslaughter.

If you thought "destructive update" might have been an over-the-top description, I hope this example enlightens you.


## Easy Proxy Patterns

One of the things that's awesome about python is that metaprogramming is pretty easy.
For example, if you want a generic Proxy class from which other proxies can inherit, you can do this:

```
class Proxy:
    def __init__(self, proxied):
        self.__proxied = proxied

    def __getattr__(self, attrname):
        return getattr(self.__proxied, attrname)
```

In my computer architecture course, we had to build a simulator for a fictional instruction set, and then measure how different caching and paging algorithms affected performance.
I decided it might be a good idea to separate the two concerns of (a) simulating correctly, and (b) measuring the simulator.
The proxy pattern looks like it's just what I need!
I'll just simulate the hardware first, then wrap those objects in proxies that write to an event log for later analysis.

```
an_array = Proxy([1, 2, 3])
assert an_array[1] == 2
```

Oh... that didn't work?
But that's what people advised would work.
I googled "python proxy pattern" today (2018), and the first link still recommended that broken code.

At the time, I decided to suck up the pain of boilerplate and also implement all the magic methods for `Proxy` as well.
It's obvious in retrospect that I could have just monkey-patched measurement-decorated functions into the simulated hardware.
It's almost like there are two ways to do it, and they're both reasonably obvious.


## Builtins are Magic

We all know how setting attributes on an object works:

```
class Object(object):
    pass

a = Object()
a.a = 'a'
```

It's too bad it doesn't work on `object`s:

```
a = object()
a.a = 'a'
```

When whether an idea works or breaks depends on the typeface of a word like object/`object`, you know someone didn't think things through.


## Hi, My name is Joe and I Work in a Lambda Factory

Python supports functional programming, like most "multi-paradigm" languages.
Occaisionally, a functional programmer might want several related functions.
Of course, you wouldn't want to write them all by hand, so you use a list comprehension:

```
funcs = [lambda: x for x in range(1, 4)]
```

Now, I know it _looks_ like that makes three functions, each returning a different number, but go ahead and give `funcs[0]()` a try.
Odd, right?
It's not what you might expect based on stuff you've done a billion times before, like `nums = [x for x in range(1,4)]`.

Well, when you start thinking about it, it does start to make sense^[The `for x` introduces a mutable variable `x`, the lambda expression makes a function that reads from that variable only once it's called, and the `in range(1,4)` part serially replaces the contents of `x` until it holds `3`.], but if you think about why it was built this way, it stops making sense again^[because it's a feature borrowed from math, and in math, there's no such thing as mutable state.].


## A Toy `atoi`

If you call `int` on a string that doesn't represent an integer, what happens?
When I checked the official documentation in 2018, it wasn't specified.
This isn't an isolated problem, either.
Plenty of standard library functions have undocumented failure modes.
They had twenty-three years to get basic technical writing right.
