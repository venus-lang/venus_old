module venus.parser;
import std.range;
import std.stdio;

import venus.context;
import venus.lexer;
import venus.ast;


struct Parser(TokenRange) {
private:
    TokenRange tokens;
    Context ctx;
public:
    this(TokenRange tokens, Context ctx) {
        this.tokens = tokens;
        this.ctx = ctx;
    }
    
    auto parse() {
        if (tokens.empty()) {
            return;
        }

        Token front = tokens.front;
        writeln(ctx.getTokenString(front));
        tokens.popFront();
        while (front.type != TokenType.End) {
            writeln("parsing:", ctx.getTokenString(front));
            with (TokenType) switch (front.type)  {
                case Begin:
                    break;
                case LineSep:
                    break;
                case Import:
                    writeln("Got Import");
                    parseImport();
                    break;
                default:
                    writeln("Unkown Token:", ctx.getTokenString(front));
                    break;
            }
            front = next();
        }
        return;
    }

    Token next() {
        tokens.popFront();
        if (!tokens.empty()) {
            return tokens.front;
        } else {
            Token t;
            t.type = TokenType.End;
            t.name = ctx.getName("FIN");
            return t;
        }
    }

    Token parseImport() {
        Token front = next(); // pop 'import'
        return front;
    }
}

auto parse(TokenRange)(TokenRange tokens, Context ctx) if (isForwardRange!TokenRange) {
    auto p = Parser!TokenRange(tokens, ctx);
    p.parse();
}

unittest {

    Context ctx = new Context();
    string code = q{
        // one-line comment
        /*
         * This is multiline comment and should be ignored by the compiler
         */
        import std.io
            
    };
    writeln("Parsing:");
    code.lex(ctx).parse(ctx);
}