# The Venus Programming Language

The Venus Programming Language is a C family language that aims to be **fast**, **easy** and **extensible**:

```d
main {
  // Hello world
  println("Hello Venus!")
  
  // Read a file and count lines
  import std.io: open // local import
  var n = 0
  for line in open("data.txt") {
    println(line)
    n = n + 1
  }
  println("total lines: $n")
  
  // Start a HTTP server
  import std.net
  http.server {
    get("/") {
      response.OK("Hello from HTTP Server")
    }
  }
  
  // Call bash
  import std.shell
  bash {
    grep -Hirn 'var' . | wc -l > var_lines.txt
    cat var_lines
  }
  
  // SQL query
  import std.db.postgre
  var db = connect('localhost'; db='student', user='user', pwd='pwd')
  val girls = db.query { select id, name, age from students where gender = 'F' }
  for (id, name, age) in girls {
    println(id, name, age)
  }
}
```


#### Fast

- **Runs fast**. Venus runs **as fast as C**. It is a native, static typed language, focusing on zero overhead abstractions and has strong support for compile time meta programming. 
- **Compiles fast**. The typical turnaround time should be **1 second or less**. The compiler supports both JIT and AOT modes. With two level incremental compilation, and a distributed database storing the compiled entities, you barely need to recompile a function twice. 
- **Concurrent and distributed**. The language and compiler itself is concurrent and distributed.

#### Easy

- **Easy to learn**. Venus is a good first language. It is designed with teaching in mind, the syntax is simple and balanced. Although the syntax is more C flavor, you will find it as simple and elegant as python. Documentation is a key part of the language, so we have integrated docs.
- **Easy to use**. Venus is interactive. it has a great shell repl that integrates with Bash. With `script` blocks, it has got every element you might need as a scripting language. Like python, the standard library should contain most common tools for your daily use with very good documentation.
- **Easy to maintain**. Venus directly support unit testing and auto testing. Contract programming like in D is also planned. The code you wrote should be fairly easy to refactor. Venus comes with a builder that could automatically resolve dependencies and manage projects deployments.

#### Extensible

- **Strong module support**. A python like module system with distributed module repository.
- **Two level language design**. Venus is consisted of two levels: a low level C like language, focusing on functional programming, is called venus-core, implemented in D; and a high level D like language, focusing on meta programming, is called venus-ext, implemented in venus-core. High level paramdimes like OO, ARC and GC are all implemented on top of venus-core.
- **Language expansion tools**. We have macros and compiler hooks for making extensions to the language syntax. We will also design a process to incorporate third party extensions into the standard bunle.

Venus is inspired by many languages:

- [D](https://dlang.org/) - Venus is actually a 'fork' of D (originally named Mars language), is more like a D3 in my mind, so many of the features comes from D. The compiler is implemented in D, and the language is binary compatible with D.
- [C](https://en.wikipedia.org/wiki/C_%28programming_language%29) - Venus is designed to be binary compatible with C, and the standard library will be based on libc. C integration is a major feature of the language, so we'll provide tools for calling 3rd party C libraries.
- [Python](https://python.org/) - My main goal for Venus was to design a static and native version of Python. I learned many things from Python's library API, docs and ipython repl. You might find Venus to be a C flavored python.
- [Kotlin](https://kotlin-lang.org/) - I borrowed many syntax from kotlin. I was a fan of kotlin but it was limited in  JVM, while I want to go native. The first draft of the reference docs is based on kotlin's docs because I once translated them to Chinese and was very familiar with it.
- [Julia](http://julialang.org/) - For its shell, IDE and scientific and ploting libraries.
- [Go](https://golang.org/) - For its concurrency model and some syntax.
- [Rust](https://rust-lang.org/) - For its memory model and Traits.
- Other languages including C++, Java, Clojure, Scala, and Javascript.

# Why a new language?

Because it's fun. Creating a new language and learn some of the best languages in the process is a must experience for every programmer. I'm gonna write down my learning process as a book.

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
