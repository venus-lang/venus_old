# Functions

## Define a new function

We define a new function to add two integer numbers together:

```d
int add(int a, int b) {
	return a + b
}
```

This function is trivial, but it shows the standard format of a function definition:

```d
ReturnType FunctionName(ParamType param, ParamType param, ....) {
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

## Default Parameter value

You can specify a default value for parameters. So if the caller omit that parameter when he calls, the default value is used.

```d
createWindow(string title, int width=400, int height=300) {
  // actual code
}

// Now if you call it omiting the width and height
createWindwo("Hello")
// This new window will have width=400 and height=300
```

## Calling with parameter names

If a function has many parameters, with similar types, calling it would be very hard to read, for example:

```d
createWindow(string title, int width=400, int height=300, int x=0, int y=0, int style=0) {
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
void sayHello(string message) {
   // ...
}
```

`void` is optional in function definition, so we can say:

```d
sayHello(string message) {
  // ...
}
```

### Return values

We use `return` to return a value in function body.

```d
int add(int a, int b) {
	return a + b
}
```

By default, the last statement is the return value of a block,
so we can omit the `return` keyword here

```d
int add(int a, int b) {
	a + b
}
```

## Omiting the braces

When the function body has only one expression, you can omit the `{}` braces and use a `=` instead:

```d
int add(int a, int b) = a + b
```

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
int toInt(string s) {
	int res = 0
	for (ch in s) {
    	if (ch.isDigit) {
        	int n = ch.toInt  // assume we already have this method
            res = res*10 + n
        }
    	if (!ch.isDigit) { // if there is a char that is not number, the string is not a valid number format, so we return 0 as the default value
        	return 0
        }
    } 
}

val s = "125" 
// now we can call toInt as if it is a method of string
val n = s.toInt() // n == 125
```

This is called Unified Function Calling Syntax (UFCS) in D. And is a very much liked feature of the language.

Actually, you might have guessed, the "methods" we called for array, are actually all free functions that has array as the first parameter in the standard library.
