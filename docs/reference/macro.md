# Macros

Macros in Venus is a very different beast compared to that in C/C++, it's not a text based replacement mechanism, rather, it is a complete interactive mechanism with the compiler. You might want to call it a plugin system for the language.

Here is a simplest form:

```d
macro loop {
	return {
		while (true) {
			$body
		}
	}
}
```

You can use it as if `loop` is a defined language feature:

```d
import std.io, std.thread

main {
	var n = 0
	loop { // $body goes here
		println("Hello $n")
		thread.sleep_sec(2)
	}
}
```

This will translate to 


```d
import std.io, std.thread

main {
	var n = 0
	while (true) {
		println("Hello $n")
		thread.sleep_sec(2)
	}
}
```

## compiler hooks


```d
macro mymacro {
	// hooks for lexer
	pre_lex(string body) {
		// do some pre lexing text based computations
	}

	on_lex(Token tok) {
		// callback on each token lexed in this macro
	}

	post_lex(TokenRange tokens) {
		// manipulate the tokens after lexing
	}

	TokenRange override_lexer(string body) {
		// completely redefine the lexer for yourself
		// you get the code body as input, and should return a range of Tokens
		// TODO: you might want to extend new TokenTypes
	}

	// hooks for parser
	pre_parse(ASTNode root) {
		// prepare for the parser
	}

	on_parse(ASTNode node) {
		// callback on each node parsed in this macro
	}

	post_parse(ASTNode root) {
		// manipulate the ast tree after parsing
	}

	ASTNode override_parser(TokenRange tokens) {
		// completely redefine the lexer for yourself
	}

	return {
		// return a macro replaced code block
	}
}
```
