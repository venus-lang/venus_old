# Functions

## Define a new function

We define a new function to add two integer numbers together:

```d
fun add(a int, b int) int {
    return a + b
}
```

This function is trivial, but it shows the standard format of a function definition:

```d
fun FunctionName(ParamType param, ParamType param, ....) ReturnType {
    FunctionBody
}
```

So the function `add` has two parameters, an `int` parameter a, and an `int` parameter b, and returns an `int` value.

## Parameters

A function can define zero or one or more parameters, each with its own type.

```d
val ch = getChar() // getChar() has zero parameters
val absolute = abs(-1) // abs() has one parameter
val sum = add(1, 3) // add() has two parameters
val str = substr(text, 0, 5) // substr() has three parameters

print("This", "world", "is", "full", "of", "suprises") //  print() can have any number of parameters, that is, print() is a var-arg functions
```

## Pure functions

In venus, functions are `pure` unless declared `impure`. 
A pure function must:
- be consistent: thati is, it returns the same value when called with the same set of parameters.
- no side effect: it does not mutate a global state.

With these two constraints, calling a pure function is safe across threads and there is no need to worry about synchronization,
making it easy to scale up to multi-core and massive concurrency.
Its behavior is very deterministic, so their will be more opportunities for the compiler to optimise.

In venus, `print` functions are viewed as pure because the printed message is readonly. Pure and I/O will be discussed in the I/O section.

In order to hold the pure constraints, parameters passed in are by default not mutable.

So if you define a pure function, you can not modify the parameter value in the function body:

```d
fun add(a int, b int) {
    a = a + 1 // ERROR!: parameter `a` of pure function `add` is readonly!
    return a + b
}
```

To make the code more effient, unlike C/C++/D, a parameter is by default a readonly reference to the passed in argument.

it is as if you defined the function in this way:

```d
fun add(ref a int, ref b int) int {
	// ...
}
```

#### Note for C++/D programmers
this is the same in C++/D as:

```d
int add(const int& a, const int& b) pure {
	// ...
}
```

### Mutating parameter

To modify the passed in argument, you need:
- specify the function `impure`
- add a `ptr` attribute to the argument

```d
impure fun negate(ptr num int) {
    num = - num
}

var a = 10
negate(a)
print(a) // output: -10
```

### Copy parameter

In other situations, you might want to copy the passed in argument.
You can specify thie behavior with `copy` attribute:

```d
int add(copy a int, copy b int) {
    // here both `a` and `b` are a copy of the value
    // ...
}
```

Copy the passed in argument into a mutable `var` is the default behavior in C++/D functions,
In Venus, we can write that as:

```d
impure int add(copy var a int, copy var b int) {
	// ...
}
```

## Default Parameter value

You can specify a default value for parameters. So if the caller omit that parameter when he calls, the default value is used.

```d
fun createWindow(title string, width int = 400, height int = 300) {
  // actual code
}

// Now if you call it omiting the width and height
createWindwo("Hello")
// This new window will have width=400 and height=300
```

## Calling with parameter names

If a function has many parameters, with similar types, calling it would be very hard to read, for example:

```d
fun createWindow(title string, width int=400, height int=300, x int=0, y int=0, style int=0) {
  // ...
}

// calling
createWindow(
	"HelloWindow",
    600,
    400,
    0,
    200,
    3
)
```

you can see when there are too many parameters, you might get lost with what each parameter means.

With named parameters, we can make the code much readable:

```d
createWindow(
    title="HelloWindow",
    width=400,
    height=300,
    x = 0,
    y = 200,
    style = 3
)

```
together with default parameters, we can omit some parameters, and only specify the ones we care

```d
createWindow(
    title="",
    style = 5
)
``` 

### Void functions

If a function returns no meaningful value, we call it void functions.

you can add `void` as the return type, as C/C++/D does:

```d
fun sayHello(message string) void {
   // ...
}
```

`void` is optional in function definition, so we can say:

```d
fun sayHello(message string) {
  // ...
}
```

### Return values

We use `return` to return a value in function body.

```d
fun add(a int, b int) int {
    return a + b
}
```

By default, the last statement is the return value of a block,
so we can omit the `return` keyword here

```d
fun add(a int, b int) int {
    a + b
}
```

## Omiting the braces

When the function body has only one expression, you can omit the `{}` braces and use a `=` instead:

```d
fun add(a int, b int) = a + b
```

## Function literals (Lambdas)

At times you might want to quickly define a tiny function to use right away,
you don't even need to name it.
for convenience, Venus provides a syntax to write function literals.

NOTE: Functiona literals are also called `lambda`s. 

For example, you might want to do a quick filter with an array to select the even numbers:

```d
fun isEven(num int) bool {
    return num % 2 == 0
}

val arr = [1, 2, 3, 4, 5]
val filtered = arr.filter(isEven)
print(filtered) // output: [2, 4]
```

With lambda, you can write:

```d
arr.filter ( x => x % 2 == 0 )
```

Lambda syntax is as follows:

```d
Parameter_List => Function_Body_Expression
```

So the lambda `x => x % 2 == 0` has a parameter `x`, its type is inferred by `arr`'s element type; it returns a `bool` value, as inferred from the `==` expression.

Without type inference, you might need to write a more verbose form:

```d
arr.filter ( (x int) bool => x % 2 == 0 )
```

Because in most cases, when you want to use lambdas, you only want one paremeter, so we provide an even simpler form:

```d
arr.filter ( it % 2 == 0 )
```

`it` is a new key word that represent the sole parameter in the lambda.


## Variable number of parameters.

you can add `...` at the end of parameter list to indicate that the function takes variable length parameters.

there are two situations:

1. You want multiple parameters of a same type:

```d
int sum(int numbers ...) {
   var res = 0
   for n in numbers {
     res += n
   }
   return res
}

int n = sum(1, 2, 3, 4) // n == 10
```

Here you can use the parameter name to access the calling parameters as a collection.

2. You want multiple parameters of any type:

```d
void printMany(...) {
	for arg in arguments {
    	print(arg)
    }
    print(';')
}

println("a", "b", "c") 
// output: a, b, c,;
```

Here you use the reserved keyword `arguments` to access the actuall calling parameters.

### calling another vararg function inside a vararg function

When you want to call another vararg function with the vararg parameter in hand, you need to spread it. Otherwise you are just calling with a single parameter with a collection type.  Use the static function `spread` to do this:

```d
void printMany(...) {
	println(arguments.spread)
}
```

# Using functions in a method style (UFCS)

Usually we call a function like this:

```d
add(1, 2)
```

For types we have methods for them:

```d
val string s = "abc"
val t = s.toUpper() // toUpper() is a method of type string
```

using the method style calling here is intuitive, and if you have to call multiple methods in a row, it can be chained:

```d
val arr = [1, 5, 2, 3, 4]
arr.filter(isEven)   // returns [1, 5, 3]
   .sort()   //  returns [1, 3, 5]
   .map(negate) // returns [-1, -3, -5]
   .join(",") // returns "-1,-3,-5"
```

In this calling style, the code is much more readable and clear.

There are cases when you have a third party type, and want to extend its syntax by adding a method to it, but you don't have access to its code.

To make all the above things possible, Venus provides a compiler rule for calling functions:

- all functions can be called as if it is a method of its first parameter.

That is, if we define a function:

```d
fun string.toInt(s this) int {
    var res = 0
    for (ch in s) {
        if (ch.isDigit) {
            int n = ch.toInt  // assume we already have this method
                res = res*10 + n
        }
        if (!ch.isDigit) { // if there is a char that is not number, the string is not a valid number format, so we return 0 as the default value
            return 0
        }
    }
    return res
}

val s = "125"
// now we can call toInt as if it is a method of string
val n = s.toInt() // n == 125
```

Actually, you might have guessed, the "methods" we called for array, are actually all free functions that has array as the first parameter in the standard library.
