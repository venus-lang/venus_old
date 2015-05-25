# The Venus Programming Language

The Venus Programming Language is a C/C++ family language that aims to provide:

- **Easy**. It should be easy to learn, use and maintain: Should be as easy as Python, should be a good candidate as first language.
- **Static**. The language is static typed
- **Dynamic**. With `script` blocks, end users can view the language as a dynamic typed language.
- **Fast**. Idiomatic code should run as fast as C/C++/D.
- **Quick**. With incremental compiling and a persistent compiler storage, code blocks that didn't change never need to recompile. 
- **Meta**: CTFE, AST Macros and other cool compile time structures inherited from D.
- **Safe**: Memory safe, RAII and RefCount by default, with occasional thread local GC if you want. Null pointers are also dealt with in the language and you might never see an NPE again.
- **Extensible**: With macros, you can define your own syntax. We'll provide a mechanism to promote popular personal defined syntax into the language. The same machanism will also help extend the std library.
- **Interoperable**: need to be able to talk with C and Javascript. C++/D support are also in consideration.
- **Portable**: Linux, MacOS, Windows. Major target is Ubuntu.
- **Fullstack**: Backend (server), Frontend (dom or even css manipulation), MiddleWare, Shell, and Mobile. All enabled.
- **Bare-metal**: able to run on an Arduino board or Raspberry Pie. Android & iOS support are welcome.

The design is mainly inspired by [The D Programming Lanuage](http://dlang.org/), which as you may have noticed, shared many goals with mine.

Many syntax are borrowed from [The Kotlin Language](http://kotlin-lang.org/).

# Why a new language?

My major purpose is to learn how to write a language. 
I'm gonna write down my learning process as a book, as shown below.

And hopefully when I finish the learning, I could come up with a prototype language that is as easy to use as Python, yet as efficient as C.

# Project Status

It is at a very preliminary design state. No code has written yet.

Before writing any code, I have to finish three tasks:

1. [ ] Write the first draft of design docs
2. [ ] Learn llvm
3. [ ] Learn about D's implementation

## Hello world

```d
import std.io

main() {
	println("Hello")
}

```

## The Book

### [Chapter 1: Tutorial](book/ch01/index.md)


## Reference


### [Language design](docs/reference/design.md)
### [Basic syntax walkthrough](docs/reference/basic-syntax.md)
### [Basic types](docs/reference/basic-types.md)


# Ecosystem

My goals for the language ecosystem include:

- REPL: ipython like repl
- Shell: Integrated shell in the repl. Should be able to completely replace bash/zsh
- Builder: Gradle like builder/package manager
- Editor: vim based commandline ide.
- GUI: a native GUI framework based on OpenGL/SDL
- IDE

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
