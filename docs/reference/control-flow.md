# Control Flow

Venus provide the traditional `if-else`, `while`, `switch` control flow structures, but with some caveats

## if-else 

In venus, if-else statement is also an expression, so it returns a value that you can assign to an object:

```d
val a = 1
val b = 2
val int c = if (a > b) { return b } else { return a }

// you can omit `return` at the last statement, and because there is only one statement at each part, also omit the braces:
val int c = if (a > b) b else a
```

Traditional usage is also ok:

```d
val a = 1
val b = 2

var c = 0
if (a > b)
	c = a
else
	c = b
```

## for loop

for loop an iterator a sequence of any type, including arrays, tuples, ranges, lists, dicts and other containers that support the range interface

use for with `in` operator to loop a sequence:

```d
for (item in collection) {
	print(item)
}

// one-line statement can omit the braces, also, the parentheses can also be omitted
for item in collection print(item)
```

if you want to take steps, or in reverse order

```d
import std.range

// take step of 3
for (item in collection.step[3]) println(item)

// in reverse order
for (item in collection.reverse) println(item)
```

if you want to know the index in the sequence, you can use a tuple

```d
import std.range
for (idx, item in collection.pairs) println("collection($idx) == $item")
```

if you want to modify items when iterating, use a ref

```d
var collection = [1, 2, 3]
for (ref item in collection) item = item + 1
// now collection == [2, 3, 4]

// the above statement is similar to a more functional style
collection.each { it = it + 1 }
```

## While loops

There are two types of while loops:

- while loop do a test before each loop:
```d
x = 0 
while (x < 10) {
	x = x + 1 
}
```d
- `do-while` loop make the test after each loop:
```d
do {
	val x = readLine()
} while (x != EOF)
```
- 'do-while-do' loop make the test mid of each loop:
```d
do {
	val line = readLine()  // this block will run each time
} while (line != EOF) {
	parse(line)  // this block will not run at the last loop when the test is failed
}
```


