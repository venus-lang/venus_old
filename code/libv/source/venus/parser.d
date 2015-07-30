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
        front = nextTok();

        while (front.type != TokenType.End) {
            writeln("check token:", ctx.getTokenString(front));
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

    void match(TokenType type) {
        auto token = tokens.front;
        
        if(token.type != type) {
            import venus.exception;
            import std.conv, std.string;
            
            auto error = format("expected '%s', got '%s'.", to!string(type), to!string(token.type));
            
            // throw new CompileException(token.location, error);
            Location loc;
            throw new CompileException(loc, error);
        }
        
        tokens.popFront();
    }

    auto parseModuleName() {
        auto mod = [tokens.front.name];
        match(TokenType.Identifier);
        while (tokens.front.type == TokenType.Dot) {
            tokens.popFront();
            mod ~= tokens.front.name;
            match(TokenType.Identifier);
        }
        return mod;
    }

    ImportDeclaration parseImport() {
        Token front = nextTok(); // pop 'import'
        Name[][] modules = [parseModuleName()];
        return new ImportDeclaration(front.loc, modules);
    }
}

auto parse(TokenRange)(TokenRange tokens, Context ctx) if (isForwardRange!TokenRange) {
    Node n;
    auto p = Parser!TokenRange(n, tokens, ctx);
    return p;
}

unittest {

    void testParse(string code) {
        Context ctx = new Context();
        auto parser = code.lex(ctx).parse(ctx);

        import std.array;
        foreach (node; parser) {
    //        writeln(node); 
        }
    }

    writeln("Testing parse");
    testParse("import std.io");
}