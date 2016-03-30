# Traits

Traits in venus is similar to interfaces in D, but much more flexible.

## Trait as interface

You can define an interface with trait

```d
trait Runnable {
    fun run() void;
}
```

The trait `Runnable` says it is a type with a member function called `run` that has the signature `fun run() void`;
Trait interfaces are duck-typing, so your type doesn't need to explicitly inheret/implement the trait.
Any type that has a member `run` whose signature is the same with `Runnable` is a `Runnable`.

So with a function:

```d
fun start(Runnable o) {
   // ...
   o.run();
   // ...
}

type Rabbit {
  fun run() void {
    // ...
  }
}

val r = Rabbit()
start(r) // OK, Rabbit is Runnable
```

## Trait as type constraint

In D, templated functions can specify type constraints on its generic argument types.
For example:

```d
R encode(R)(R r)
if isInputRange!R && is(ElementType!R == string)
{
   // ...
}
```

Here `encode` is a function that accepts object of any type that is an `InputRange` and its element type is `string`,
which means `string[]` or lines read from a File, or any other range of strings are accepted.
This is very convenient but somehow verbose and hinders readability.

Venus use traits to achieve the same feature, but more succinct:

```d
trait SRange = constraint [R] { R.isInputRange() and (R.elementType() eq string) }
```

Now you can use SRange just like a normal type:

```d
fun encode(r SRange) SRange {
  // ...
}
```

