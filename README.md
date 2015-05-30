# The Venus Programming Language

```d
import std.io

main {
  println("Hello Venus!")
}
```

The Venus Programming Language is a C family language that aims to be:

- **Easy**. It should be easy to learn, use and maintain: Should be as easy as Python, should be a good candidate as first language.
- **Static**. The language is static typed
- **Dynamic**. With `script` blocks, end users can view the language as a dynamic typed language.
- **Fast**. Idiomatic code should run as fast as C/C++/D.
- **Quick**. With incremental compiling and a persistent compiler storage, code blocks that didn't change never need to recompile. 
- **Meta**: Templates, `static` blocks, CTFE, AST Macros and other cool compile time structures.
- **Safe**: Memory safe, RAII and RefCount by default, with occasional thread local GC if you want. Null pointers are also dealt with in the language and you might never see an NPE again.
- **Concurrent**: Fiber, channel, coroutines. Even the language itself will be concurrent.
- **Extensible**: With macros, you can define your own syntax. We'll provide a mechanism to promote popular personal defined syntax into the language. The same machanism will also help extend the std library.
- **Interoperable**: need to be able to talk with C and Javascript. C++/D support are also in consideration.
- **Portable**: Linux, MacOS, Windows. Major target is Ubuntu.
- **Fullstack**: Backend (server), Frontend (dom or even css manipulation), MiddleWare, Shell, and Mobile. All enabled.
- **Bare-metal**: able to run on an Arduino board or Raspberry Pie. Android & iOS support are welcome.

The language in influenced by many languages:

- [D](https://dlang.org/) - Venus is actually a 'fork' of D (originally named Mars language), so many of the features comes from D. The language will be implemented in D.
- [Python](https://python.org/) - My main goal for Venus was to design a static and native version of Python. I learned many things from Python's library API, docs and ipython repl.
- [Kotlin](https://kotlin-lang.org/) - I borrowed many syntax from kotlin. I was a fan of kotlin but not such fan of JVM, I hope kotlin would come native too. The first draft of the reference docs is based on kotlin's docs because I once translated them to Chinese and was very familiar with it.
- Other languages including C/C++, Go, Clojure, Scala, Rust and Javascript. See the [design](docs/reference/design.md) section in the reference

# Why a new language?

My major purpose is to learn how to write a language. 
I'm gonna write down my learning process as a book, as shown below.

And hopefully when I finish the learning, I could come up with a prototype language that is as easy to use as Python, yet as efficient as C.

# Project Status

It is at a very preliminary design state. No code has written yet.

Before writing any code, I have to finish three tasks:

1. [ ] Write the first draft of design docs
2. [ ] Learn [LLVM](http://llvm.org) basics and make it into a chapter for the book.
3. [ ] Learn about D's implementation, especially [SDC](https://github.com/deadalnix/SDC) because it is written in idiomatic D.


## The Book

#### [Chapter 1: Tutorial](book/ch01/index.md)
#### [Chapter 2: First Step](book/ch02/index.md)

## Reference

#### [Language design](docs/reference/design.md)
#### [Basic syntax walkthrough](docs/reference/basic-syntax.md)
#### [Basic types](docs/reference/basic-types.md)
#### [Objects](docs/reference/objects.md)
#### [Control flow](docs/reference/control-flow.md)
#### [Functions](docs/reference/functions.md)
#### [Modules](docs/reference/modules.md)
#### [Types](docs/reference/types.md)



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
