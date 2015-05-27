# Objects

In Venus, every thing is an object, that is, it has a type and a value.

Venus provide three kinds of objects for their different behavior rules:

- value (`val`) : immutable object that represent a timeless value. 
- variable (`var`) : an object that can change its value over time, this is same as variables in C
- reference (`ref`) : an reference to an object so that we can efficiently manage objects

## Rationale
Venus promotes the functional programming style, so we encourage you to use value instead of variable where ever possible. Think in data transformation (stream) instead of data mutation (state).

Variables may be more effient sometimes, especially in a single thread world, but once you step into a multi-thread or multi-core, or even multi-machine world, things would easily get ugly for variables as you have to sync its state within many contexts.

## Examples

Values are immutable objects in the system.
```d
val a = 1 // a is inferred to int
val a = 2 // ERROR! value objects are immutable, you can not assign value to it
val b = a // OK, a's value is copied to b. Acutally, b and a might be optimized to be the same memory block.
val c = a + 1 // a is used as normal value in an expression
val d = square(a) // OK
```





