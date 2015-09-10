# Basic Syntax

## Defining modules

We can specify the module at the top of the code:

```d
module myapp

import std.io

// ... code
```

Modules should match directories and files, similar to D's module system.

See [modules](modules.md)

## Defining functions

A simple function with two parameters with type `int`, and returns a `int` value:

```d
fun sum(a int, b int) int {
    return a + b
}
```

Note that in Venus, unlike C or D, type notes come after identifier and function arguments.
This syntax is borrowed from Go, so that we have more consistent flow:

```
DIRECTIVE NAME TYPE
```

All function definitions starts with a directive `fun`.


A shorter function difinition, with an expression body:

```d
fun sum(a int, b int) int = a + b
```

By default, functions are not visible outside its module.
To make them visible outside, you need to declare it `public`:

```d
public
fun sum(a int, b int) int = a + b
```

Function that does not return, i.e. a void function:

```d
fun printSum(a int, b int) void {
    println(a + b)
}
```

`void` could be omitted because its the default return type of a function definition:

```d
fun printSum(a int, b int) {
    println(a + b)
}
```

See [Functions](functions.md)

## Defining local objects

We have two types of objects in Venus:
- value object, denoted with `val`, which is immutable.
- variable object, denoted with `var`, is mutable.

```d
val a int  = 1 // a is a `value` object of type `int`
val b = 2 // the type `int` is inferred by the assignment of number 2
val c int // declared but not initiated. Here the type `int` is required because there is no value to infer
c = 3 // first assignment is its initialization. after that, it can not be modified
c = 4 // Error!: object `c` with value 3 is not mutable!
```

Variable object, that is, it is mutable.

```d
var a int = 1 // `a` is a variable of type int
a = a + 1  // ok
```

# Using string templates

```d
val score = 99
println("Your score is ${100 - score} away from 100") // use an expression in `${..}` inline block.
// output: Your score is 1 away from 100
```

If the expression used is simple enough, you can omit the braces:

```d
val score = 99
println("Your score is $score!")
// output: Your score is 99!
```

See [String templates](string-templates.md)

## Conditional control flows

`if-else` statement:

```d
fun max(a int, b int) int {
    if (a > b) {
        return a
    } else {
        return b
    }
}
```

`if-elseif-else` statement:

```d
fun compare(a int, b int) int {
    if (a > b) return 1
    else if (a = b) return 0
    else return -1
}
```

using `if` as an expression:

```d
max(a int, b int) int = if (a > b) a else b
```
see [if-else](if-else.md)

## Using `switch` expression

```d
var obj;
switch(obj) {
    case 1: print("One")
    case "Hello": print("Greeting")
    case isType[long] : print("long")
    case !isType[string] : print("Not a string")
    else: print("Unknown")
}
```

## Using a `for` loop

```d
for i in [1, 3, 9, 12] {
    print(i)
}
```

you can also use conditions:

var i = 0
for i < 5 {
    println(i++)
}

we can have multiple statements, the last expression is used as condition

for (var i = 0; i < 5) {
    println(i++)
}



## Using range operator

```d
for x in 0 .. 5
    print(x)

if not x in 0 .. 5
    print("X is out of range 0 to 5")
```

By default, range is left-inclusive and right-exclusive:

```d
(0 .. 5) .each (printBy[','])
// output: 0,1,2,3,4
```

see [for-loop](control-flow.md#for-loop)

## Using collections

Iterating over a collection

```d
for (name in names) {
    println(name)
}
```

Check if an item is in the collection

```d
if (name in names) {
    println("Yes")
}
```

## Chaining functional calls

```d

names .filter (startsWith('A'))
      .sort
      .map (toLowerCase)
      .each (println) 

```
