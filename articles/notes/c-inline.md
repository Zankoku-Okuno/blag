# Inline Functions in C

WARNING: This is all subject to change when I go to read the C standard, but for now, this is what information I've gained about best practices from a few sources online.

The weird thing about it is that the semantics of `extern` are kind of swapped for `inline` functions.
An `inline` function definition does not create a label for that function, _unless_ it is also `extern`.
Non-`inline` functions are `extern` by default.
The wrinkle is that `static` still creates a label usable only within the translation unit, whether the function is `inline` or not.


## Inline Function Used Across Multiple Translation Units

### Example

Header file (`foo.h`):
```
inline
int foo(int x) {
    return x + 1;
}
```

One translation unit (`foo.c`):
```
#include "foo.h"
extern inline int foo(int);
```

Other translation units (say, `bar.c`):
```
#include "foo.h"
#include "bar.h"

void bar(int* ip) {
    *ip = foo(*ip);
}
```

### Analysis

This will only work in C99 and up.
The default gcc dialect may have different semantics.

Thankfully, the implementation is given only once in the source code
As the type signature should be checked by the compiler, the duplication of the type signature is not a major problem, though slightly annoying.

There don't have to be any tricks with `#define` before `#include`, which is quite nice.



## Inline Function Used In a Single Translation Unit

### Example

Translation Unit (`bar.c`):
```
static inline
int foo(int x) {
    return x + 1;
}

void bar(int* ip) {
    *ip = foo(*ip);
}
```

### Analysis

The `static` instead of `extern` modifier will ensure that the `foo` symbol is not exported.
THe important point for inline functions is that it will also ensure that object code is generated in case the function is not inlined somewhere in the translation unit.
Normally, object code is generated anyway for function definition, but not for inline definitions.

## Separate Prototype and Inline Definition

TODO

## References

  * [What's the difference between static inline, extern inline and a normal inline function?](https://stackoverflow.com/a/25000931)
  * [inline, static, extern in C99](https://stackoverflow.com/q/34937816)
  * [Is “inline” without “static” or “extern” ever useful in C99?](https://stackoverflow.com/q/6312597)