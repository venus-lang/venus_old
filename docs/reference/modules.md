# Modules

A source file may start with a module declaration:

```d
module my.hello_module

hello() {
	print("hello");
}

type MyType { 
	// ...
}
```

If the file starts with a module declaration, all functions and types in the file are contained in this module.

So, for the above example, `hello()` is actually `my.hello_module.hello()`, and `MyType` is `my.hello_module.MyType`

### module block

With module blocks, we can declare multiple modules in one file

```d
module my.hello_module {
	hello() {
		// ...
	}
	// ...
}

module my.other_module {
	hello() { // we can have same names in different modules
	}
	// ...
}
```

And even with hierarchies to declare nested modules

```d
module my {
	module hello_module {
		hello() {
			// ...
		}
		module tree {
			type tree {
				// ...
			}
		}
	}
}
```

## Using a module

To use functions and types in a module, we need to import them.
The Venus standard libraries are contained in module `std`

```d
import std.io // imports all symbols from module std.io

main {
	println("Hello") // println is actually std.io.println(), after import, we can use the simple name instead of full name
	std.io.println("hello") // full name is also OK.
}
```

If we put `import` statement at the head of a scope, then we can use it in every place in the scope.
In the above example, we import `std.io` at the head of the file, so it is seen throughout the file.

We can also put the `import` statement in other places to give more control:

```d
main {
	import std.io  // we only import std.io in `main`
	println("Hello")
}

hello(string name) {
	println(name) // ERROR! println is not imported!
}
```

Here `std.io` is imported in `main`, so using `println` in `hello()` will be a compiler error because `hello()` is out of the scope of `main`.

## Selective imports

If we want to import only one symbol from a module:

```d
import std.io.println
```

Here we import `println` , and other symbols like `print` are not seen.

If we want to import more than one symbols:

```d
import std.io { println, File }
import std.io print, getchar // ignoring the braces is OK here
```

If we need an alias of the symbol imported, perhaps to avoid name conflict with another module, 
or we just want a shorter name
we can use:

```d
import std.io { println: prtln, File }

main {
	prtln("Hello!") // prtln is an alias of std.io.println
}
```

Here println is aliased, but File stays the same.

## Visibility

Symbols defined in a module are visible only if they are public:

```d
import std.io

module my.hello {
	public hello {
		saySomething()  // calling functions in the same module is OK
		println("hello")
	}

	saySomething {
		println("hehehe...")
	}
}

main {
	import my.hello
	hello("world!") // ok, because `hello` is declared public
	saySomething() // ERORR! `saySomething()` is not visible
}
```

