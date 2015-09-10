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

class Identifier : Node {
    Name name;

    this(Location loc, Name name) {
        super(loc);
        this.name = name;
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

class CallExpr : Expr {
    Expr callee;
    Expr[] args;
    this(Location loc, Expr callee, Expr[] args) {
        super(loc);

        this.callee = callee;
        this.args = args;
    }
}

class Expr: Node {
    this(Location loc) {
        super(loc);
    }
}

enum BinaryOp {
    Add,
    Sub,
    Mul,
    Div
}

class BinaryExpr : Expr {
    Expr lhs;
    Expr rhs;

    BinaryOp op;

    this(Location loc, BinaryOp op, Expr lhs, Expr rhs) {
        super(loc);
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }
}

class IdentifierExpr: Expr {
    Identifier identifier;

    this(Location loc, Identifier ident) {
        super(loc);
        this.identifier = ident;
    }

}

class StringLiteralExpr: Expr {
    private string value;
    this(Location loc, string value) {
        super(loc);
        this.value = value;
    }

    override string toString() {
        return "'" ~ value ~ "'";
    }
}