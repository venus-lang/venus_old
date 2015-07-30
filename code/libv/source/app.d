import std.stdio;
import venus.lexer;
import venus.context;
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
    foreach (tok; lexer) {
        writeln(tok);
    }
    writeln("lexer done");
}
