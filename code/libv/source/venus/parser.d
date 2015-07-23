module venus.parser;
import std.range;
import std.stdio;

import venus.context;
import venus.lexer;
import venus.ast;


struct Parser(TokenRange) {
    Node n;
    TokenRange tokens;
    Context ctx;

    @property auto front() inout {
        return n;
    }
    
    void popFront() {
        n = next();
    }
    
    @property auto save() inout {
        return inout(Parser)(n, tokens, ctx);
    }
    
    @property bool empty() const {
        return tokens.empty();
    }
    
    Node next() {
        Location loc; // empty
        if (tokens.empty()) {
            return new Node(loc);
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
                    return parseImport();
                default:
                    writeln("Unkown Token:", ctx.getTokenString(front));
                    return new Node(front.loc);
            }
            front = nextTok();
        }
        return new Node(loc);
    }

    Token nextTok() {
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

    ImportDeclaration parseImport() {
        Token front = nextTok(); // pop 'import'
        Name[][] modules;
        return new ImportDeclaration(front.loc, modules);
    }
}

auto parse(TokenRange)(TokenRange tokens, Context ctx) if (isForwardRange!TokenRange) {
    Node n;
    auto p = Parser!TokenRange(n, tokens, ctx);
    return p;
}

unittest {

    Context ctx = new Context();
    string code = q{
        // one-line comment
        /*
         * This is multiline comment and should be ignored by the compiler
         */
        import std.io;
            
    };
    writeln("Parsing:");
    auto parser = code.lex(ctx).parse(ctx);

    /**
    foreach (n; parser) {

    }
*/
}