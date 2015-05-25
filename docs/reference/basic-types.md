# Basic Types 
Venus comes with built-in types like numbers, booleans, arrays, strings and dicts, and you can create your own type with the `type` statement. We'll introduce the built-in types first, which would cover most common tasks hopefully. And then you will see how to define your own type.

## Numbers

Venus handles numbers similar to C/C++/D, but has some differences.

Venus has these number types with different bitwidth:

| Type | Alias | Bit Width | Desc |
| --- | --- | --- | --- |
| i8 | byte | 8 | 8 bit integer |
| i16 | short | 16 | 16 bit integer |
| i32 | int | 32 | 32 bit integer |
| i64 | long | 64 | 64 bit integer |
|    |  | | |
| u8 | ubyte | 8 | 8 bit unsigned integer |
| u16 | ushort | 16 | 16 bit unsigned integer |
| u32 | uint | 32 | 32 bit unsigned integer |
| u64 | ulong | 64 | 64 bit unsigned integer |
| | | | |
| f32 | float | 32 | 32 bit float number |
| f64 | double | 64 | 64 bit float number |
| | | | |

### Number literals

you can write numbers in the code so that the compiler gets its type directly:

```d
val a = 123 // default type: int
val uint b = 123 // declare it is an uint
val c = 1000L // long integers tails with a capital 'L'
val d = 0x1F // hex numbers starts with '0x'
val big_number = 1_000_000_000 // for long numbers, you can add '_' anywhere to make it clearer
val e = 0b10001 // binary numbers starts with '0b'
val e1 = 0b_10001 // because '_' can be anywhere (but not '0_b'), you might want it after '0b' to make it more clear.

val f = 0.23 // default to doubles
val g = 12. // also double
val h = 0.9e12 // scientific
val i = 0.12f // floats
```

### Type conversions

Implicit conversions are allowed only when there is no precision loss, otherwise you have to explicitly convert it.

```d
val short a = 123 
val int b = a // OK, implicit conversion with no loss
val byte c = b // Error! Might lose precision

import std.conv  // explicit conversion functions are defined in std.conv module
val byte d = a.to!byte // OK, explicit conversion
```

## Booleans

Boolean type has two values : `true` and `false`. In memory it is stored as one bit, with `true==1` and `false==0`.

```d
val bool a = true
val bool b = false
assert(bool.init == false) // default value of bool is false
```

Numbers can convert to boolean type implicitly because there would be no precision loss.
Boolean can convert to number types with true => 1 and false => 0.

```d
val int a = 100
val bool b = a // b is now true
val int c = 0
val bool d = c // c is now false
val int e = d // e is now 0
val int f = b // f is now 1, NOTE: not 100!
```

## Arrays and other list-like containers

In venus arrays are a library defined container, with no special syntax for its literals

```d
val arr = array(1, 2, 3, 4) // type: std.array[int]

for n in arr {
  print(n)
}
// output: 1, 2, 3, 4
```

You might miss the array literal syntax in python, like:

```python
arr = [1, 2, 3, 4, 5]
```

We decided not to use that because the brackets `[]` in Venus is used in many compile time structures:

- templates
- generics
- ctfe

For literals, we have a compile time tuple literal:

```d
val elems = (1, 2, 3, 4, 5) // type: std.tuple[int] which behaves very much like static array in C, but it is immutable.

for e in elems {
  print(e)
}

val array arr = elems // tuple are implicitly convertable to array so you can use it just like it is an array.

```

## Strings and characters

Strings are acutally array of characters.
Character is also a basic type, which has the same number of bits as a byte.

```d
val char c = 'a' // 'a' is an ascii character, it's integer value is 97
val uint n = c // n == 97

// single line string literals are quoted with `"` or `'`
val string s = "abc" // string is actually an array('a', 'b', 'c')
val string s1 = 'xyz' // another way to quote strings, but are only used when using `"` is cumbersome because we have `"` in the string

val string s2 = "a\"b\"c" // `"` in the string content need to be escaped with `\"`
val string s3 = 'a"b"c' // here we use `'` to make things easier
val inferredChar = 'A' // type: char.  A character literal quoted with `'` is infered as char, unless we specify the type string, it will implicitly convert
val string convertedStr = 'B' // type: string, 'B' is a char, but it is implicitly converted to a string


// multiline line string literals are quoted with `"""`
val string t = """
	good morning
	sunshine!
	"quoting is also ok here"
"""

// for large text that may still contain `"""`, we also provide `[=[`, `]=]`, `[==[`, `]==]`, `[===[`, `]===]` and the like.
var string u = [=====[
	here """ is ok,
	and you rarely need to contain ]===] in a string, and if that really happens, you quote it with a longer one
]=====]
```

### String template

We can embed objects into a string with string template.
Object placeholders in a string template are defined as `$name`, or `${complex-expression}`, for example:

```d
val n = 5
val str = "n = $n" // s is "n = 5"

val s = "hello"
val str = "$s.length is ${s.length}" // s1 is "hello.length is 5"
```

### Dictionary literal

Dictionary is called `Associated Array`, `Map`, `dict` or `table` in other languages. It is a container that maps keys to values that we can lookup with efficiency.
In Venus, a dictionary is called a `dict` for simplicity, just like in Python. We don't call it a `map` because it would conflict with the functional operator `map` (as in Map/Reduce).

Venus comes with two types of dict:

- hash dict: use a hash to store data, its pairs order are not defined.
- tree dict: use an internal tree to store data, the key/value pairs are sorted by key. Tree dict is usually slower than hash dict.

dict literals are in the form of `{ key : value }`

```d
// dict literals default to hash dict
val dict ages = {
	"Ann" : 12,  
	Ben : 20, // for symplicity, string keys can omit the `"` quote if it has no white space.
	Colt : "hello", // leaving a ',' at the last pair is not an error because this will make it very easy to modify dict literals
}  

```

Because all the keys are of type `string`, and values are of type `int` and `string`, the inferre type is `dict[string, any]`

```d
// You can also specify the type of the dict
var scores = tree {
	15 : "low",
	60 : "ok",
	98 : "good"
}

// or even with the types of elements
var ids = hash[int, string] {
	1 : "Ann",
	2 : "Ben",
	3 : "Colt"
}

```

The apply operator `()` is used to look an item up:

```d
var ids = hash[int, string] {
	1 : "Ann",
	2 : "Ben",
	3 : "Colt"
}

val ann = ids(1)
```

Adding a pair is also easy:

```d
// because the lookup will return a reference to the pair data (and will create one if it does not exist)
ids(5) = "John"

// or
ids.set(5, "John")
```

Note: you can easily create your own type of dict and it will look very similar to the built-in ones.

See [dicts](dicts.md).
