module venus.ast;

import venus.context;

class Node {
    Location loc;
    this(Location loc) {
        this.loc = loc;
    }
}

class Declaration : Node {
    this(Location loc) {
        super(loc);
    }
}

class ImportDeclaration : Declaration {
    Name[][] modules;

    this(Location loc, Name[][] modules) {
        super(loc);
        this.modules = modules;
    }
}

class Block : Node {

    this(Location loc) {
        super(loc);
    }
}

class MainBlock : Node {
    Block block;

    this(Location loc, Block block) {
        super(loc);
        this.block = block;
    }
}

class FunctionCall : Node {
    this(Location loc) {
        super(loc);
    }
}

class Arguments : Node {
    this(Location loc) {
        super(loc);
    }
}

class Expression : Node {
    this(Location loc) {
        super(loc);
    }
}

class IdentifierExpression: Expression {
    this(Location loc) {
        super(loc);
    }
}

class StringLiteralExpression: Expression {
    this(Location loc) {
        super(loc);
    }
}