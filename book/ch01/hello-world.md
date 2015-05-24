# Hello World

# Code

```d
import std.io;

main() {
	println("Hello World!");
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

1. import the standard I/O library module `std.io` so that we can call the `println` function in that module.
2. define an entry point of the program with `main()`, in C this would be

```c
int main() {
}
```

where `int` is the return type of the function, `main` is the name of the function and `()` means this function takes no arguments.

but in Venus, just like in D, the compiler (and runtime) will handle the process return code so that we don't need to manage it, so we can just say

```d
void main() {
}
```

and in Venus, `void` is a default situation if you omit the return type of a function, so you can just type

```d
main() {
  // code here	...
}
```

3. call the `println(...)` function to print a message to the console. Here `ln` means after the message we want a new line.

`println(...)` is similar to this code in C:

```c
printf("Hello World!\n");
```
