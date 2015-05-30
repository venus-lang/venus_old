# Objects

In Venus, every thing is an object, that is, it has a type and a value.

Venus provide three kinds of objects for their different behavior rules:

- value (`val`) : immutable object that represent a timeless value. 
- variable (`var`) : an object that can change its value over time, this is same as variables in C
- reference (`ref`) : a constant reference to an object so that we can efficiently read objects, *NOTE*, not like C++/D, reference is readonly. For modifications, use `ptr`
- pointer (`ptr`): a pointer to an object, so that we can efficiently modify objects.

`ref` and `ptr` objects are particularly useful in function calls


## Rationale
Venus promotes the functional programming style, so we encourage you to use value instead of variable where ever possible. Think in data transformation (stream) instead of data mutation (state).

Variables may be more effient sometimes, especially in a single thread world, but once you step into a multi-thread or multi-core, or even multi-machine world, things would easily get ugly for variables as you have to sync its state within many contexts.

## Examples

Values are immutable objects in the system.
```d
val a = 1 // a is inferred to int
val a = 2 // ERROR! value objects are immutable, you can not assign value to it
val b = a // OK, a's value is copied to b. Acutally, b and a might be optimized to be the same memory block.
```

Variables are mutable, at any time you want

```d
var a = 1 
a = 2 // OK
a = 3 // OK

var b = a // b == 3, here b and a have same value, but they are different.
b = 4 // OK. Here only b is momdified, a is still 3.
```
When you assign a var to another, its value is actually copied into the receiver var.

```d
var date1 = Date.create // create a new date
var date2 = date1  // the value of date1 is copied into date2, so that modifying date2 would not affect date1
```
When you are dealing with complicated types, this operation might be costly.

To avoid copies when reading, use `ref`: 

```d
var complicateObject = ComplicateType.create // create an new instance of 
ref b = complicatObject // no copy here
print(b.toString()) // same as complicateObject.toString()
```

if you actually want to modify the original var, use `ptr`:

```d
var a = 1
ptr b = a // here b is acutally pointing to a, so modifiying b will also change a
b = 3 // now a is also 3
print(a) // output: 3
```

You can also make a ref of a val, but that would be unneccesary most of the time,
because assignment of val is usually optimised with a ref by the compiler:
"These things can not change, so why do I bother copying it? just use a ref!"

