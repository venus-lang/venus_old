module venus.lexer;
import std.range;
import std.stdio;
import std.conv;
import std.uni;
import std.utf;
alias isUniAlpha = std.uni.isAlpha;

enum TokenType {
    Invalid = 0,
    Begin, 
    End,

    // Literals
    Identifier,
    StringLiteral,
    CharacterLiteral,
    IntegerLiteral,
    FloatLiteral,

    // Keywords

    // Object/Type
    Val,
    Var,
    Ptr,
    Ref,

    // Builtin Type
    Bit,
    Byte,
    Char,
    Short,
    Int,
    Long,
    Float,
    Double,

    
    // Control flow
    Do,
    Else,
    If,
    While,

    // Operators
    Plus, // '+'
    Minus, // '-'
    Star, // '*'
    Slash, // '/'
    Dot, // '.'
    Assign, // "="

    // Language
    Import,
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

public {
    auto getOperatorsMap() {
        with(TokenType) return [
            "+" : Plus,
            "-" : Minus,
            "*" : Star,
            "/"	: Slash,
            "." : Dot,
            "=" : Assign,
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

auto lex(R)(R r, Context ctx) if (isForwardRange!R) {

    struct Lexer {

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
                    case ' ', '\t', '\v', '\f', '\n', '\r':
                        lexWhiteSpace(r);
                        continue;
                    case '/':
                        popChar();
                        switch (r.front) {
                            case '/', '*':
                                writeln("Comment..");
                                lexComment(f);
                                continue;
                            default:
                                return lexOperator(f);
                        }
                    case '0': .. case '9':
                        writeln("lexNumeric");
                        return lexNumeric(r);
                        //				case `"` :
                        //					return lexString(r);
                        //				case `'`:
                        //					return lexChar(r);
                    case '+', '-', '*', '=', '.': // TODO: '/'
                        popChar();
                        return lexOperator(f);
                    default:
                        writeln("lexDefault");
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
            return r.front;
        }

    private: // lex parts
        void lexWhiteSpace(R r) {
            auto c = r.front;
            if (c == '\n') {
                ++line;
                popChar();
            }
            else if (c == '\r') {
                c = nextChar();
                if (c == '\n') {
                    popChar();
                }
                ++line;
            } else {
                popChar();
            }
        }	

        void lexComment(dchar head) {
            //popChar(); // pop the already checked '/'
            auto c = r.front;
            writeln("comment front:", c);
            if (c == '/') { // one line comment
                while (c != '\n' && c != '\r') {
                    c = nextChar();
                    writeln("checking:", c);
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

        
        Token lexNumeric(R r) {
            Token tok;
            tok.type = TokenType.IntegerLiteral;
            //tok.name = r.front;
            popChar();
            return tok;
        }

        Token lexIdentifier() {

            writeln("Identifier:");
            Token tok;
            string name;
            auto c = r.front;
            while (c.isIdChar) {
                name ~= c;
                c = nextChar();
                writeln("r.front:", c);
            }
            writeln("name:", name);
            tok.name = context.getName(name);
            tok.type = TokenType.Identifier;
            return tok;
        }

        Token lexEnd() {
            Token tok;
            tok.type = TokenType.End;
            return tok;
        }

        Token lexOperator(dchar f) {
            Token tok;
            /*
            if (auto tokType = (f in getOperatorsMap())) {
                tok.type = *tokType;
            } else {
                writeln("Unknown operator:", f);
            }
            popChar();
            return tok;
*/
            switch (f) {
                case '+':
                    tok.type = TokenType.Plus;
                    break;
                case '-':
                    tok.type = TokenType.Minus;
                    break;
                case '*':
                    tok.type = TokenType.Star;
                    break;
                case '/':
                    tok.type = TokenType.Slash;
                    break;
                case '=':
                    tok.type = TokenType.Assign;
                    break;
                case '.':
                    tok.type = TokenType.Dot;
                    break;
                default:
                    writeln("Unknown operation", f);
                    break;
            }
            popChar();
            return tok;
        }
    }

    auto lexer = Lexer();
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
    string code = `//a
    /* b
    */
    import std.io
    var a
    1 + 1
    1 - 1
    1 * 1
    1 / 2`;
	auto lexer = lex(code, ctx);
	foreach (tok; lexer) {
		writeln("TOK:", ctx.printToken(tok));
	}
}

