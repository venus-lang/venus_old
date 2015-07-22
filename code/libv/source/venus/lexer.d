module venus.lexer;
import std.range;
import std.stdio;
import std.conv;
import std.uni;
import std.utf;
import std.ascii;
alias isUniAlpha = std.uni.isAlpha;
alias isPunct = std.ascii.isPunctuation;
/**
 * Check a char is an operator (and not string/char quotes)
 */
bool isOp(dchar c) {
    return c == '+' || c == '-' || c == '*' || c == '/' 
            || c == '.' || c == '=' 
            || c == '{' || c == '}' || c == '(' || c == ')'
            || c == ',';
}

enum TokenType {
    Invalid = 0, Begin, End,

    // Literals
    Identifier, StringLiteral, CharLiteral, IntLiteral, FloatLiteral,

    // Keywords

    // Object/Type
    Val, Var, Ptr, Ref,

    // Builtin Type
    Bit, Byte, Char, Short, Int, Long, Float, Double,

    
    // Control flow
    Do, Else, If, While, 

    // Seperators
    BlockBegin, BlockEnd,
    ParenBegin, ParenEnd,

    // Operators
    Plus, // '+'
    Minus, // '-'
    Star, // '*'
    Slash, // '/'
    Dot, // '.'
    Assign, // "="
    Comma, // ','

    // Language
    Import, Extern, LineSep,
}

public {
    auto getOperatorsMap() {
        with(TokenType) return [
            "+" : Plus,
            "-" : Minus,
            "*" : Star,
            "/"	: Slash,
            "." : Dot,
            "=" : Assign,
            "{": BlockBegin,
            "}": BlockEnd,
            "(": ParenBegin,
            ")": ParenEnd,
            ",": Comma,
        ];

    }

    auto getKeywordsMap() {
        with(TokenType) return [
            // built-in types
            "val": Val,
            "var": Var,
            "ptr": Ptr,
            "ref": Ref, 
            "bit": Bit,
            "byte": Byte,
            "char": Char,
            "short": Short,
            "int": Int,
            "long": Long,
            "float": Float,
            "double": Double,
            // Control flow
            "do": Do,
            "if": If,
            "else": Else,
            "while": While,
            // language block
            "import": Import,
            "extern": Extern,
        ];
    }

}

private {
    enum Reserved = ["__ctor", "__dtor", "__vtbl"];

    enum Prefill = [
        // Linkages
        "C", "D", "C++", "Windows", "System", "Pascal", "Java", "Venus",
        // Version
        "Linux", "OSX",
        // Generated
        "init", "length", "max", "min", "sizeof", "create",
        // Scope
        "exit", "success", "failure",
        // Main
        "main", "_vmain",
        // Attribute
        "property", "unsafe", "dynamic", "alloc",

    ];

    auto getNames() {
        auto identifiers = [""];
        foreach (k, _; getOperatorsMap()) {
            identifiers ~= k;
        }
        foreach (k, _; getKeywordsMap()) {
            identifiers ~= k;
        }

        return identifiers ~ Reserved ~ Prefill;
    }

    enum Names = getNames();

    static assert(Names[0] == "");

    auto getLookups() {
        uint[string] lookups;
        foreach (uint i, id; Names) {
            lookups[id] = i;
        }
        return lookups;
    }

    enum Lookups = getLookups();

    enum Keywords = getKeywordsMap();
}

struct Name {
private:
    uint id;
    
    this(uint id) {
        this.id = id;
    }
public:
    string toString(const ref NameManager nm) const {
        return nm.names[id];
    }
    
    @property
    bool isEmpty() const {
        return this == BuiltinName!"";
    }
    
    @property
    bool isReserved() const {
        return id < (Names.length - Prefill.length);
    }
    
    @property
    bool isDefined() const {
        return id != 0;
    }
}

template BuiltinName(string name) {
    private enum id = Lookups.get(name, uint.max);
    static assert(id < uint.max, name ~ " is not a builtin name.");
    enum BuiltinName = Name(id);
}

struct NameManager {
private:
    string[] names;
    uint[string] lookups;
    
    // make it not copyable
    @disable this(this);
    
package:
    static get() {
        return NameManager(Names, Lookups);
    }
    
public:
    auto getName(string s) {
        if (auto id = s in lookups) {
            return Name(*id);
        }
        
        // Do not keep around slice of potentially large input.
        s = s.idup; // similar problem to old java's string
        
        auto id = lookups[s] = cast(uint) names.length;
        names ~= s;
        
        return Name(id);
    }
    
    string printToken(Token tok) {
        return "Token[" ~ tok.type.to!string ~ "," ~ tok.name.to!string ~ "," ~ tok.name.toString(this) ~ "]";
    }
    
    void printLookups() {
        writeln("Lookups:", lookups);
        writeln("Names:", names);
    }
}

/** Context **/
final class Context {
    NameManager nameManager;
    alias nameManager this;

    this() {
        nameManager = NameManager.get();
    }
}

/** Lexer **/

struct Token {
    TokenType type;
    Name name;
}


struct Lexer(R) {
    
    Token t;
    R r;
    
    Context context;
    
    uint line = 1;
    uint index = 0;
    
    @property auto front() inout {
        return t;
    }
    
    void popFront() {
        t = getNextToken();
    }
    
    @property auto save() inout {
        return inout(Lexer)(t, r, context, line, index);
    }
    
    @property bool empty() const {
        return r.empty() || t.type == TokenType.End;
    }
    
private:
    auto getNextToken() {
        while (1) {
            if (r.empty()) return lexEnd();
            dchar f = r.front;
            switch (f) {
                case '\0':
                    return lexEnd();
                case ' ', '\t', '\v', '\f':
                    popChar();
                    continue;
                case '\n', '\r', ';':
                    return lexLineSep();
                case '/':
                    popChar();
                    switch (r.front) {
                        case '/', '*':
                            lexComment(f);
                            continue;
                        default: // '/' operator
                            return lexOperator(f);
                    }
                case '0': .. case '9':
                    return lexNumeric();
                case '"' :
                    return lexString();
                case '\'':
                    return lexChar();
                case '+', '-', '*', '=', '.', '{', '}', '(', ')', ',': // TODO: use operator map here. What if D has pattern matching...
                    popChar();
                    return lexOperator(f);
                default:
                    return lexIdentifier();
            }
        }
    }
    
    void popChar() {
        r.popFront();
        ++index;
    }
    
    auto nextChar() {
        r.popFront();
        ++index;
        if (r.empty()) 
            return EOF;
        return r.front;
    }
    
private: // lex parts
    Token lexLineSep() {
        auto c = r.front;
        Token tok;
        tok.type = TokenType.LineSep;
        string name;
        if (c == '\n') {
            name = "\\n";
            ++line;
            popChar();
        }
        else if (c == '\r') {
            c = nextChar();
            if (c == '\n') {
                popChar();
                name = "\\r\\n";
            } else {
                name = "\\r";
            }
            ++line;
        } else { // ';'
            name = ";";
            popChar();
        }
        tok.name = context.getName(name);
        return tok;
    }   
    

    
    Token lexNumeric() {
        Token tok;
        tok.type = TokenType.IntLiteral;
        //tok.name = r.front;
        string name;
        auto c = r.front;
        while (c.isDigit || c == '.') {
            name ~= c;
            c = nextChar();
        }
        tok.name = context.getName(name);
        return tok;
    }
    
    Token lexString() {
        Token tok;
        string name;
        popChar(); // '"'
        auto c = r.front;
        while (c != '"') {
            name ~= c;
            c = nextChar();
        }
        popChar(); // '"'
        
        tok.type = TokenType.StringLiteral;
        tok.name = context.getName(name);
        return tok;
    }

    Token lexChar() {
        Token tok;
        popChar(); // '\''
        auto c = r.front;
        string name;
        while (c != '\'') {
            name ~= c;
            c = nextChar();
        }
        popChar(); // '\'
        tok.type = TokenType.CharLiteral;
        tok.name = context.getName(name);
        return tok;
    }

    Token lexIdentifier() {
        
        auto c = r.front;
        if (!c.isIdChar) {
            writeln("lex error at:", r);
            assert(0, "Wrong identifier!");
        }
        Token tok;
        string name;
        while (c.isIdChar) {
            name ~= c;
            c = nextChar();
        }
        
        tok.name = context.getName(name);
        if (auto tokType = name in Keywords) {
            tok.type = *tokType;
        } else {
            tok.type = TokenType.Identifier;
        }
        return tok;
    }
    
    Token lexEnd() {
        Token tok;
        tok.type = TokenType.End;
        return tok;
    }
    
    
    // TODO: argument 'dchar f' here is unintuitive....
    Token lexOperator(dchar f) {
        Token tok;
        string name;
        auto c = f;
        if (c.isOp) { 
            name ~= c;
            c = r.front;
        }
        while (c.isOp) {
            name ~= c;
            c = nextChar();
        }
        if (auto tokType = name in getOperatorsMap()) {
            tok.type = *tokType;
        } else {
            writeln("Unknown operator:", name);
            assert("0", "Lex Error");
        }
        tok.name = context.getName(name);
        return tok;
    }

    void lexComment(dchar head) {
        //popChar(); // pop the already checked '/'
        auto c = r.front;
        if (c == '/') { // one line comment
            while (c != '\n' && c != '\r') {
                c = nextChar();
            }
            
            popChar();
            if (c == '\r') {
                if (r.front == '\n') popChar();
            }
            ++line;
        } else if (c == '*') {
        Pump: while (1) {
                while (c != '*' && c != '\r' && c != '\n') {
                    c = nextChar();
                }
                
                auto match = c;
                c = nextChar();
                switch (match) {
                    case '*':
                        if (c == '/') {
                            popChar();
                            break Pump;
                        }
                        break;
                    case '\r':
                        if (c == '\n') {
                            c = nextChar();
                        }
                        
                        line++;
                        break;
                    case '\n':
                        line++;
                        break;
                    default:
                        assert(0, "Unreachable in lexComment.");
                }
            }
        }
    }

}

auto lex(R)(R r, Context ctx) if (isForwardRange!R) {

    auto lexer = Lexer!R();
    lexer.r = r.save;
    lexer.context = ctx;
    lexer.t.type = TokenType.Begin;

    return lexer;
}

auto isIdChar(C)(C c) {
    static if (is(C == char)) {
        return c == '_' || isAlphaNum(c);
    } else static if (is(C == wchar) || is(C == dchar)) {
        return isUniAlpha(c);
    } else {
        static assert(0, "This function is only for character types");
    }
}

unittest {
    Context ctx = new Context();
    string code = q{
        // one-line comment
        /*
         * This is multiline comment and should be ignored by the compiler
         */
        import std.io

        extern double sin(double d);
        int add(int a, int b) {
            return a + b
        }

        double times(double c, double d) {
            return c * d
        }

        main {
            println("hello")

                var a = 1.1
                val c = 'a'
                1 + 2 
                2 - 3 
                4 * 5 
                6 / 7
        }
        
    };
    auto lexer = lex(code, ctx);
    foreach (tok; lexer) {
        writeln(ctx.printToken(tok));
    }
}

