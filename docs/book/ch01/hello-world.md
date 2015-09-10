# Hello World

# Code

```d
import std.io

main {
    println("Hello World!")
}
```

# How to run it

- Save the above code to a file named 'hello.v'
- Open your favorite terminal/console, and change to the directory that hello.v is in.
- Type in the command:

```
venus hello.v
```

- you will get an output:

```
>Hello World!
>
```

# Explain it

The code does three things:

### 1. import the standard I/O library module `std.io` 

so that we can call the `println` function in that module.

### 2. define an entry point of the program with `main`, in C this would be

unlike C, using a function `int main() {...}` to define the entry point, Venus directly support the `main` block.

Code in main block will be the entry point of a program.

### 3. call the `println(...)` function to print a message to the console. 

Here `ln` means after the message we want a new line.

`println(...)` is similar to this code in C:

```c
printf("Hello World!\n")
```
