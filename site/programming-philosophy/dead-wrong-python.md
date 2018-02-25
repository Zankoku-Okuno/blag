# Dead-Wrong Python

I've mastered Python well enough to dismiss it as a poor language.
Don't get me wrong, the Python community is large, and that's a plus, but other langauges have good communities, and the technical problems are too stupid to bear.

## Fun With Conditionals

What will this script output when run?

```
import some_other_module
if True:
    print "Hello"
else:
    print "Goodbye"
```

Of course, it will print `Hello`; it doesn't matter what's in `some_other_module` since we aren't using anything from it --- it's a dead import.
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

## Silencing the Problem

```
class Foo
    def foo(self):
        return 4

    def foo(self):
        pass
```

## Easy Proxy Patterns

```
class Proxy:
    def __init__(self, proxied):
        self.__proxied = proxied

    def __getattr__(self, attrname):
        return getattr(self.__proxied, attrname)

an_array = Proxy([1, 2, 3])
assert an_array[1] == 2
```

FIXME: should I be using `__getattribute__` instead?


## Smooth Builtins

```
a = object()
a.a = 'a'
```

```
class Object(object):
    pass

a = Object()
a.a = 'a'
```

## Hi, My name is Joe and I Work in a Lambda Factory

```
[lambda: x for x in range(1, 4)]
```

## A Toy `atoi`

If you call `int` on a string that doesn't represent an integer, what happens?
When I checked the official documentation in 2018, it wasn't specified.
They had twenty-three years to get this right.

This isn't an isolated problem, either.
Plenty of standard library code could fail, but doesn't have specified error modes.
TODO: make a short list of these.
