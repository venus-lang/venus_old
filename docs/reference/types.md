# Types

Venus is made of objects and functions.

All objects in Venus are of a type:

- `10` is of type `int`
- `'c'` is of type `char`
- `true` is of type `bool`
- `"Hello"` is of type `string`

Types are called `struct` or `class` in D and other languages.
To make things clear, we unify all these concepts into one `type`.


You can make your own custom types by defining a new `type`.


```d
type Node {
    val id int
    val depth int
    val name string
}
```

Here we define a new type called 'Node', it might be a node in a tree.
The node type has four fields:
- id, of type `int`
- depth, also of type `int`
- name, of type `string`

You can see that there is no limit for fields, you can define any of them

Now to create a new instance of the type 'Node', you can use the apply function on the Type as if it is a function:

```d
val node = Node() // creates a new Node object
```

We call this the `new` function, or a construtor. You can also write out the `new` function name, but that is not encouraged.

```d
val node = Node.new() // same as Node()
```

## Type members

Other than fields, we can embed other members in a type:

- Methods: member functions that work closely on the type.
- Properties: functions that work like fields which you can get/set, and also take control of it.
- Nested types: we can define types inside type definition. 

These things are discussed in further sections.

## Object initialization

When an object is created, each field is initialized with an default value of its type.

You can get the initial value of a type with `init` property:

```d
val a = int.init // int.init == 0

val n = Node() 

assert (n.id == 0)
assert (n.depth == 0) 
assert (n.name == "") // string.init = ""
```

You can also give a initial value for each field by calling the creator with parameters.

```d
val n = Node(0, 1, "NodeA")

// for clarity, you can specify parameter names
val n1 = Node(id=1, depth=1, name="NodeB")

// also with a dict
val n2 = Node{id: 1, depth: 1, name: "NodeC"}
```

## Custom Creators

In the above code, the compiler generates default constructor for you.
But if you want to control the initialization process your self, you can define your own constructor instead of using the default ones.

Define a function inside a type with name `new` to override the default constructors:

```d
type Node {
    val id int
    val depth int
    val name string

    // Your own constructor
    fun new(id int, depth int, name string) {
        this.id = id
        this.depth = depth
        this.name = "MyOwn" + name // a little twist ...
    }

}

val node = Node(id=0, depth=1, name="Node1")
print(node.name) // output: MyOwnNode1

// now you can not call the default creator with no parameters:
val node2 = Node() // ERROR!: constructor with empty paramters () was not defined!

```

In `create` function, you can use `this` to differenciate from the field from the parameter in case they have the same name.

## Object destruction

You might allocate resources when creating an object, such like allocating a memory block, opening a file handle, a network socket or a lock.

In Venus, these resources can be released when the object is destructed (e.g. out of scope).

To release resources on destruction, define a `destruct` method in the type:

```d
import std.io
type Text {
    val path string
    private val file File

    fun new(path string) {
        this.path = path
        this.file = open(file) // open the file resource
    }

    fun die() {
        this.file.close() // release it
    }
}
```

## Mutable types

Be default, Types in Venus are immutable. To make a type with mutable fields as in traditional C++/D, you must use `var` on the type and all variable fields:

```d
import std.count
var type Sum {
    val id int // immutable
    var sum int // mutable

    fun create() {
        id = nextId[Sum, int]()
    }

    fun add(b int) void {
        sum += b
    }
}

var s = Sum()
print(s.sum) // output: 0
s.add(5)
print(s.sum) // output: 5
```

In the above code, Sum.id is still immutable (it gets initialized by a counter and never changes), and Sum.sum is mutable and must be signed as `var`


## Builders

For immutable types, sometimes you might want to initialize it step by step, but the creator can be called only once and nothing you can do to modify the object further.
For these situations, Venus provides `Builders` to help you build your object at your own pace and release it when you're done:

```d
type Node {
    val id int
    val depth int
    val name string
}

// instead of calling `create`, you can call `builder`:
var b = Node.builder()

// and you can now modify the partially builded object `node` here:
b.id = 15
b.depth = 2
b.name = "New Name"

// now when you're done building, call `build` to make a new instance
val node = b.build()


// using `with` block, you can make things simpler:

val node = with(Node.builder) {
    id = 15
    depth = 2
    // do some things at your pace
    print("I'm gonna have some coffee..")

    name = "New Name"
    // ok, done
    build()
}
```

# Type interactions

Types can interact with each other:

- composition: we can combine two or more types together to get a more complicated type. Just like Lego blocks
- subtyping: we can create a new type based on a existing type, with little tweaks for our needs.
- type calculations: we can calculate type relations at compile time, with operations similar to numbers (`+`, `-`, `*`, `/`, and `|`, `&`)

## Type composition

we can make a composite of other types using `has` operator in a type definition:

```d
type Wings {
    public val length int
    fun fly() int {
        println("Flying up high")
        return 5 // meters
    }
}

type Bird {
    has wings Wings
    val name string

    fun new(name string, wingLength int) {
        this.wings = Wings(wingLength)
    }
}

val chuck = Bird("chuck", 5)
chuck.fly()

assert(chuck.isInstance!Bird) // true
assert(chuck.isInstance!Wings) // false
assert(chuck.hasInstance!Wings) // true
```

Here a `Bird` has `Wings`, so it can do anything that `Wings` does--by using its `Wings`--including `fly()`.

With composition, we have a way to do traditional `has-a` relation in Object Oriented programming.

We call `Wings` a `part` of `Bird`.

A type can have many parts:

```d
type Bird with Wings, Legs, Heart {
    //...
}
```


## Type Inheritance

When you have got a base type, you can define a sub type that `inherit` from the base type,
that is, an object of the sub type is an instance of the base type.
We call it `is-a` relationship in Object Oriented jargon.

```
type Base {
    id int
}

type Sub : Base {

}

val obj = Sub()
assert (obj.type == Sub) // true
assert (obj.isInstance!Sub) // true
assert (obj.isInstance!Base) // true
```

Venus does not support multiple base types, 
so one type can only inherit from one base type.
To emulate that in Venus, you can use interfaces or composition when appropriate.

## Method override

When you define a subtype that inherit from a base type, you can override the behavior of some of its methods:

```d
type Base {
    virtual fun run() void {
        println("run base")
    }
}

type Derived : Base {
    override fun run() void {
        super.run()
        println("Run Derived")
    }
}

val d = Derived()
d.run()
// output:
// run base
// Run Derived
```

Note: You can only override methods annotated with `virtual`.

You can call a method of base type in sub type with `super.method()`.

### subtype initialization


## Interfaces

Interface is a abstract contract that defines what to do. It is usually consisted of a set of methods.
In venus, we use `api` keyword to indicate an interface

```d
api Runnable {
    fun run() void
}

type Human: Runnable {
    fun run() void {
        print("I'm a running guy...")
    }
}
```

Typically interfaces does not have method implementations, all methods in an interface are by default `virtual`

You can combine interfaces to make code more readable.

```d
api Humanoid = static { Runnable + Walkable + Talkable + NeedSleep }
```

## Data types

In many cases, we have types used only as data:
- no methods
- all fields are public
- need to be able to be easily as primary data types
- able to control the memory layout 

For this, Venus provide a special kind of type: data type:

```d
data Point {
    val x int  // these fields are public by default, unlike types
    val y int
}

val p = Point(x=1, y=2)

// Compiler will generate a `copy` method to easily convert data values
val p1 = p.copy(y=3)  // p1 = Point(x=1, y=3)
val p2 = p.copy(x=4) // p2 = Point(x=4, y=2)
val p3 = p.copy(x=5, y=6) // you can move with all fields modified

// data types has a default to string implementation
val str = p.toString() // str == "Point(x=1, y=2)"

// data types has toJSON and parseJSON fields
val json = p.toJSON() // json == '{"x":1,"y":2}'
val p5 = Point.parseJSON('{"x":1,"y":2}')

// and binary serialization
val bytes = p.encode()
val p6 = Point.decode(bytes) // p6 == p

// Data types also support destructuring
val x, y = p  // x == 1, y == 2
```
