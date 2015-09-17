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

    Node next() {
        Location loc; // empty
        if (tokens.empty()) {
            return new Node(loc);
        }

        Token front = tokens.front;
        front = nextTok();

        while (front.type != TokenType.End) {
//            writeln("check token:", ctx.getTokenString(front));
            with (TokenType) switch (front.type)  {
                case Begin:
                    break;
                case LineSep:
                    break;
                case Import:
                    return parseImport();
                case Main:
                    return parseMain();
                default:
                    writeln("Unkown Token:", ctx.getTokenString(front));
                    return new Node(front.loc);
            }
            front = nextTok();
        }
        return new Node(loc);
    }

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
    //    writeln("Matching:", type, " with ", ctx.getTokenString(tokens.front));
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

    bool isNext(TokenType type) {

        import std.conv: to;
        return !tokens.empty() && tokens.front.type == type;
    }

    auto parseModuleName() {
        auto mod = [tokens.front.name];
        match(TokenType.Identifier);
        while (tokens.front.type == TokenType.Dot) {
            match(TokenType.Dot);
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

    IdentifierExpr parseIdentifier() {
        Location loc;
        Identifier ident = new Identifier(loc, tokens.front.name);
        match(TokenType.Identifier);
        return new IdentifierExpr(loc, ident);
    }

    StringLiteralExpr parseStringLiteral() {
        Location loc;
        match(TokenType.StringLiteral);
        return new StringLiteralExpr(loc, ctx.getTokenName(tokens.front));
    }

    Expr parseExpression() {
        writeln("parsing..");
        switch (tokens.front.type) {
            case TokenType.Identifier:
                return parseIdentifier();
            case TokenType.StringLiteral:
                return parseStringLiteral();
            default:
                writeln("Error: Unknown expression:", tokens.front);
                return null;
        }
    }

    Expr[] parseArguments() {
        Expr[] es;
        Expr e = parseExpression();
        es ~= e;
        writeln("Parsed one expression");
        while (tokens.front.type == TokenType.Comma) {
            match(TokenType.Comma);
            es ~= parseExpression();
        }
        Location loc;
        return es;
    }

    CallExpr parseFunctionCall() {
        IdentifierExpr callee = parseIdentifier();
        match(TokenType.ParenBegin);
        Expr[] args = parseArguments();
        match(TokenType.ParenEnd);
        Location loc;
        return new CallExpr(loc, callee, args);
    }


    auto parseStatements() {
        // TODO: add other statements
        return parseFunctionCall();
    }

    Block parseBlock() {
        match(TokenType.BraceBegin);
        // parse block body
        if (!isNext(TokenType.BraceEnd)) {
            parseStatements();
        }
        match(TokenType.BraceEnd);
        Location loc;
        return new Block(loc);
    }

    MainBlock parseMain() {
        match(TokenType.Main);
        // parse body
        Block block = parseBlock();
        Location loc;
        return new MainBlock(loc, block);
    }
}

auto parse(TokenRange)(TokenRange tokens, Context ctx) if (isForwardRange!TokenRange) {
    Node n;
    auto p = Parser!TokenRange(n, tokens, ctx);
    return p;
}

unittest {

    void testParse(string code) {
        writeln("> Testing parse for: ", code);
        Context ctx = new Context();
        auto parser = code.lex(ctx).parse(ctx);

        import std.array;
        int n = 0;
        foreach (node; parser) {
            writeln(node); 
        }
    }

    // one line import
    testParse("import std.io");
    // multi import
    testParse(q{
            import std.io;
            import std.net;
    });

    // empty main block
    testParse("main{ }");


    // main block with function call
    testParse(q{ main{println("hello")} });
}