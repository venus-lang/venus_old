# Chapter 2: Milestone 1, a better C

Rome wasn't build in a day.

To make a language as ambitious and complex as Venus, we need a very solid base. 
As what we want to achieve is a better D, which is a better C++, which is an enhanced C, we need to look back and start with C first. So we need a better C first.

C is a much simpler language compared to C++ or D, so we can attack it with more ease and strengthen our understanding of the compiler in the process. We won't do OO or high-level compile time magic here. But C has its warts and can be narly, like macros, which I'm not inclined to implement. So we won't write the exact C language, instead, we'll design a language that has similar complexity to C, but should look simpler in most cases.

Here is what I want to get in the first Milestone:

- function definition and calling
- basic builtin types including `int`, `double` and `char`
- basic control flows including `if-else`, `while`, `for` and `switch`
- module and import instead of textual inclusion
- basic static-if and/or version blocks to replace text macros in C
- immutability first, variables second
- able to call extern C functions

Here is what M1 would look like:

```d
// comment
import std.io // module and import

// extern C function/constant declaration
extern double sin(double arg)
extern PI

// define a new function
double toRadian(int degree) {
    return degree*PI/180
}

// main block
main {
    // value definition and assignment
    val degree = 30

    // variable definition
    var result
    
    // assignment with a function call
    result = sin(toRadian(degree))

    // call println function in std.io module
    println("sin(30°)=", result)
}
```
