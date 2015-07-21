import std.stdio;
import venus.lexer;
import std.range;

void main()
{
	string code = `
		1 + 1
	`;

    writeln("lexing:");
    writeln(code);
    writeln("----");
	Context context = new Context();
	writeln("var:", context.getName("var"));
	auto lexer = lex(code, context);
    writeln("lexer done");
	foreach (tok; lexer) {
		writeln("TOK:", tok);
	}
	writeln("Edit source/app.d to start your project.");
}
