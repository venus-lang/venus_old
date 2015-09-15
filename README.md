# The Venus Programming Language

```d
import std.io

main {
  println("Hello Venus!")
}
```

The Venus Programming Language is a C family language that aims to be:

- **Fast**. Venus is actually a static typed, focusing on zero overhead abstractions and has strong support for compile time meta programming. You can get a lot done even before the program runs. The compiler supports both JIT and AOT modes, and with incremental builing, its compile time should be very fast.
- **Easy**. Venus is a good first language. It is designed with teaching in mind, the syntax is simple and balanced. Venus has every element you want as a scripting language. It has a `script` block for daily simple tasks and it has an interactive shell that integrates bash. 
- **Extensible**. Strong module support. Language expansion with macros.

Venus is influenced by many languages:

- [D](https://dlang.org/) - Venus is actually a 'fork' of D (originally named Mars language), so many of the features comes from D. The language will be implemented in D.
- [Python](https://python.org/) - My main goal for Venus was to design a static and native version of Python. I learned many things from Python's library API, docs and ipython repl.
- [Kotlin](https://kotlin-lang.org/) - I borrowed many syntax from kotlin. I was a fan of kotlin but not such fan of JVM, I hope kotlin would come native too. The first draft of the reference docs is based on kotlin's docs because I once translated them to Chinese and was very familiar with it.
- [Rust](https://rust-lang.org/) - For its memory model and Traits.
- [Go](https://golang.org/) - For its concurrency model.

- Other languages including C/C++, Clojure, Scala, and Javascript. See the [design](docs/reference/design.md) section in the reference

# Why a new language?

My major purpose is to learn how to write a language. 
I'm gonna write down my learning process as a book, as shown below.

And hopefully when I finish the learning, I could come up with a prototype language that is as easy to use as Python, yet as efficient as C.

## The Books

### Designing Venus

#### [Chapter 1: Intro](docs/books/designing-venus/ch01/index.md)
#### [Chapter 2: Milestone 1 - A Better C](docs/books/designing-venus/ch02/index.md)

### Learning Venus

#### [Chapter 1: Tutorial](docs/book/ch01/index.md)
#### [Chapter 2: First Step](docs/book/ch02/index.md)

## Reference

#### [Language design](docs/reference/design.md)
#### [Basic syntax walkthrough](docs/reference/basic-syntax.md)
#### [Basic types](docs/reference/basic-types.md)
#### [Objects](docs/reference/objects.md)
#### [Control flow](docs/reference/control-flow.md)
#### [Functions](docs/reference/functions.md)
#### [Modules](docs/reference/modules.md)
#### [Types](docs/reference/types.md)
#### [Macros](docs/reference/macro.md)



# Ecosystem

My goals for the language ecosystem include:

- REPL: ipython like repl
- Shell: Integrated shell in the repl. Should be able to completely replace bash/zsh
- Builder: Gradle like builder/package manager
- Editor: vim based commandline ide.
- GUI: a native GUI framework based on OpenGL/SDL
- IDE

# TODO list

Before version 1.0, the project is split into many iterations (0.x dot versions) and TODO task goals are set for each iteration.
I'm trying to make each task as clear and practiciable as possible so that with each step finished we get a visible improvement.

### 0.0 - Preparation

* Basic Design
  - [x] Read [kotlin docs](http://kotlinlang.org/docs/reference/).
  - [x] write the first draft of [design docs](docs/reference/index.md)
  - [x] Read [LLVM](http://llvm.org) tutorials
  - [ ] read [D docs](http://dlang.org/spec.html) and update Venus design
  - [ ] read [Rust docs](http://doc.rust-lang.org/stable/book/) and update Venus design
  - [ ] read [Go docs](http://golang.org/doc) and update Venus design
  - [ ] read [Python docs](https://docs.python.org/3/) and update Venus design

* Project bootstrap
  - [ ] Make a new D project
  - [ ] learn [SDC](https://github.com/deadalnix/SDC) - Basic Lexer and Parser
  - [ ] learn [SDC](https://github.com/deadalnix/SDC) - LLVM bindings
  - [ ] translate LLVM tutorial code into D code
  - [ ] refer to [orange](https://github.com/orange-lang/orange) as a startkit reference for its C++/LLVM code

### 0.1 A Basic C like language (M1)

* Minimum language subset
  - [x] design the language, called milestone 1 (M1)
  - [ ] document the language M1
  - [x] write a lexer for M1 (returns a range of Token)
  - [ ] write a parser for M1 (returns an AST tree)
  - [ ] write a basic code generation with LLVM (returns IR/JITed code)
  
* C style procedure programing
* C integration
* C standard lib integration

### 0.2 More C support and a basic stdlib
* More basic types
  - [ ] bit
  - [ ] byte
  - [ ] short
  - [ ] float
  - [ ] double
* Basic `type` system
  - [ ] data type
  - [ ] integrate with C struct
  - [ ] function with data type
* functional programming
* Basic stdlib


### 0.3 Basic OO

* `type` support
  - type definition
  - field
  - creator
  - destructor
  - method
* basic collections
  - range
  - tuple
  - array
  - dict
  - option

### 0.4 Thread and Fiber
- thread/fiber/coroutine
- array/dict lib

### 0.5
- ctfe
- shell
- macro
- other static features

### 0.6
- stdlib

### 0.7
- builder
- text editor

### 0.8
- GUI

### 0.9
- IDE

### 0.10
- cross platform
