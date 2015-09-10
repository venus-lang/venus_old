# Reading text from a file

# Code

```d
import std.io

main() {
    val file = open('message.txt') // open a file with name 'message.txt' and store it to a value object named 'file'
    for line in file { // read the file line by line. for each line we store the value named 'line'
        println(line)  // print the `line` value. Note: we need `println` here instead of `print` because the new-line char is omitted during reading for portable purposes
    }
}
```

# Explain it

Here we see some new features in the language.

## 1. value assignment

```d
val file = open('message.txt')
```
Here `file` is a value object. the `open` function returns an object of type `std.File`, and using the assignment operator, `=`, the File object is stored in the value object `file` so that we could do further manipulations to it.

The compiler infers the return type of `open` so you don't have to declare the type, as in C. But if you want to be strict, you can declare it by yourself:

```d
val file File = open('message.txt')
```
Here you declare that value `file` must be of type `File`(which is imported from std module, so actually it is `st.File`), so if you assigned it with another type, the comopiler will complain:

```d
val file File = 1 + 2; // Error: 'file' of type 'std.File' cannot be assigned with a value of type 'int'.
```

## 2. for loop

There may be many lines in a text file. So in order to print every line, you have to iterate each line and call println for that line.

For loop is the language structure used to iterate the lines. Acutally, for loop can iterator all kinds of collections with many objects: arrays, file, ranges, streams, etc.

For example, if you have a collection of integers, say `(1, 2, 3, 4)`, you can:

```d
val xs = (1, 2, 3, 4)
for n in xs {
  println("The square of ", n, " is ", n*n);
}
```

this will print the output:

```
The square of 1 is 1
The square of 2 is 4
The square of 3 is 9
The square of 4 is 16
```

The for loop in Venus is very similar to Python, using 'in' operator.

# One-liner

Venus is a functional language, which means we can call functions with functions. So there is a more concise way to iterate a collections:

```d
import std.io

main() {
  open('message.txt').each(println)
}
```

with `each`, we apply function `println` to each line in the File.
