# The Venus Programming Language

The Venus Programming Language is a C/C++ family language that aims to provide:

- Easy to learn and use: Should be as easy as Python. 
- Meta Programming: CTFE, AST Macros and other compile time structures 
- Memory safety: RAII and RefCount by default, with occasional GC if you want.
- Incremental & Interactive compilation.

The design is mainly inspired by [The D Programming Lanuage](http://dlang.org/), which as you may have noticed, shared many goals with mine.

# Why a new language?

My major purpose is to learn how to write a language. 
I'm gonna write down my learning process as a book, as shown below.

And hopefully when I finish the learning, I could come up with a prototype language that is as easy to use as Python, yet as efficient as C.


# Ecosystem

My goals for the language ecosystem include:

- REPL: ipython like repl
- Shell: Integrated shell in the repl. Should be able to completely replace bash/zsh
- Builder: Gradle like builder/package manager
- Editor: vim based commandline ide.
- GUI: a native GUI framework based on OpenGL/SDL
- IDE

# Project Status

It is at a very preliminary design state. No code has written yet.

Before writing any code, I have to finish three tasks:

1. [ ] Write the first draft of design docs
2. [ ] Learn llvm
3. [ ] Learn about D's implementation

# Lanuage Design

The Venus programming language is influenced by the following languages:

### D

You might find Venus much like D because I'm writing this language as my fork of D language. 
D is a great language, it is the most flexible language I've seen so far and writing code in D is a very pleasant experience.
I love many features in D and is going to implement them in Venus as well.

But I'm still trying to create a new language rather than stick to using D because:

- I'd like to learn from creating a new language.
- Some of the default settings in the language was proved not the best. For example: final, pure, nothrow
- D is huge. It has too many features and their interactions make it even more complicated. 
- Unlike Python, D is not a good first language. I'd like a language perfect for newbies as well as proffesionals.

I'm using D to implemented Venus.

### C/C++

This is obvious. Just like D, Venus is a C/C++ derivative. Venus will be binary compatible to C, just like D does.

### Python

- modules (a mix of python/D)
- stdlib/docs
- ease of use

### Kotlin/Scala

Some of the syntax are influenced by kotlin/scala

- val, var
- last function parameter expansion

## Hello world

```d
import std.io;

main() {
	println("Hello");
}

```

## The Design Book

## [Chapter 1: Tutorial](book/ch01/index.md)


# Road Map

### V0.1

- procedure programing
- C integration
- C standard lib integration

### V0.2
- functional programming
- thread/fiber/coroutine
- array/dict lib

### V0.3
- class
- repl

### V0.4
- ctfe
- shell

### V0.5
- macro
- other static features

### V0.6
- stdlib

### V0.7
- builder
- text editor

### V0.8
- GUI

### V0.9
- IDE

### V1.0
- cross platform
