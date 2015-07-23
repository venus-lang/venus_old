module venus.ast;

import venus.context;

class Node {
    Location loc;
    this(Location loc) {
        this.loc = loc;
    }
}