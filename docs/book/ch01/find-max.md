# Find Max Number

# Code

```d
/*
 * Define a new max function
 * @returns the bigger one of the two parameters
 */
int larger(int a, int b) {
	if (a >= b) return a
	else return b
}

main() {
	val array = [1, 4, 3, 9, 2];
	var result = int.MIN // use the smallest integer possible for a start
	for (n in array) {
		result = larger(result, n)
	}
	println("The max element in array %array is %result") 
}

```

# Explain it

### 1. Define a new function
First we define a new function `int max(int a, int b)` to compare two numbers and get the larger one.

You can add functionalities to your codebase by defining new functions. 
Then later you can use it just like standard functions. (Which is defined by the standard library coder).

Function definitions are the same with C/C++/D, with some subtle caveats. See the reference chapter for [function definitions](/docs/reference/functions/definition.md) for details.

For a simple explanation, the new function:

```d
int larger(int a, int b) {
	... // implementation 
}
```

- is named `larger`, 
- and has two parameters:
  - a, with type int
  - b, with type int
  so `larger()` can take two integer parameters
- returns an value of type int
- the code in `{..}` block is its implementation

### 2. compare values with if-else statement

We can use if-else statement to try and compare. 
You can see the details of if-else statement in the [reference document - if-else section](/docs/reference/statement/if-else.md).

```d
if (a >= b) return a
else return b
```


# One-liner

Because the `larger` function is acutally defined in std.math as `max`, you can use `max` directly.

we can apply `max` to an array with the `reduce` function defined in std.range

```d
import std.math
import std.range

void main() {
	println( [1, 4, 3, 9, 2].reduce(max, int.MIN) ) // output: 9
}
```
