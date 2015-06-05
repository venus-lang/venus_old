import std.stdio;
import venus.lexer;
import std.range;

void main()
{
	string code = `
		1 + 1
	`;

	Context context = new Context();
	writeln("var:", context.getName("var"));
	auto lexer = lex(code, context);
	foreach (tok; lexer) {
		writeln(tok);
	}
	writeln("Edit source/app.d to start your project.");
}
