```
interface ShrinkWrap = \E.x { new: Int -> x, peek: () -> Int, extend: (* -> *) -> * }
module ShrinkWrap :: ShrinkWrap = pack ShrinkWrap as \mu.x {
    new n = pack n
    peek x = unpack t, x = n in n
    extend mkSubclass = mkSubclass x
}
```

```
class Greeter {
    protected String _name
    public Greeter(String name) {
        this._name = name
    }
    public Greeter greet() {
        print(this._greeting())
        return this
    }
    private String _greeting() {
        return "Hello, ${this._name}!"
    }
}
class CuteGreeter extends Greeter {
    public CuteGreeter(String name) {
        this._name = name + "ie"
    }
}
```

```
module Greeter exports { Greeter, _Greeter, new }
    type Greeter = \E.x. { greet: Int -> x
                         }
    type _Greater = \E.x. { _name: String
                          , greet: Int -> x
                          }
    new name = pack \mu.This. { _name: String
                              , greet: () -> This }
               as Greeter
               in letrec this = { _name = name
                                , greet = print "Hello, ${this._name}!"
                                }
                  in this

module CuteGreeter
    TODO
```

I haven't even gotten into mutable state yet.
FIXME: what about calling the super constructor? Initializing final variables?


------

Much better classes would be like

```
class Foo(var field1, val field2) implements Interface, Field2Interface {
    get field1, field2

    field1 delegates fooMethod
    field2 delegates Field2Interface

    myMethod() {
        return field1 + readRef field2
    }
}
```

There is only one constructor, and its arguments are given as if the class were a function of those arguments.
There's no need for a `this` keyword, since the fields are like the arguments of a function.

Default getters and setters can be defined.
If they need to change later, they remain properties.

There is no implementation inheretance.
Instead, you can state which methods you want to delegate where.
You should also be able to delegate a whole interface to a field at a time.

No static methods: use modules instead.