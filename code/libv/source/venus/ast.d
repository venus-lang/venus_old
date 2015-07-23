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