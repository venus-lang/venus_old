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
	int id
	int depth
	string name
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

We call this the `create` function for each type, because it creates one object of the type.
You can also write out the `create` for clarity:

```d
val node = Node.create() // same as Node()
```

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
val dict = {id: 1, depth: 1, name: "NodeC"}
val n1 = Node(dict)
```

## Custom Creators

In the above code, the compiler generates default creators for you.
But if you want to control the initialization process your self, you can define your own creators instead of using the default ones.

Define a function inside a type with name `create` to override the default creators:

```d
type Node {
	int id
	int depth
	string name

	// Your own creator
	create(int id, int depth, string name) {
		this.id = id
		this.depth = depth
		this.name = "MyOwn" + name // a little twist ...
	}

}

val node = Node(id=0, depth=1, name="Node1")
print(node.name) // output: MyOwnNode1

// now you can not call the default creator with no parameters:
val node2 = Node() // ERROR!: creator with paramters () is not defined!

```

In `create` function, you can use `this` to differenciate from the field from the parameter in case they have the same name.

## Mutable types 

Be default, Types in Venus are immutable. To make a type with mutable fields as in traditional C++/D, you must use `var` on the type and all variable fields:

```d
import std.count
var type Sum {
	int id  // immutable
	var int sum  // mutable

	create() {
		id = nextId[Sum, int]()
	}

	add(int b) {
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
	int id
	int depth
	string name
}

// instead of calling `create`, you can call `builder`:

var builder = Node.builder()

// and you can now modify the partially builded object `node` here:
builder.id = 15
builder.depth = 2
builder.name = "New Name"

// now when you're done building, call `create` to make a new instance
val node = builder.create()


// using `with` block, you can make things simpler:

val node = with(Node.builder) {
	id = 15
	depth = 2
	// do some things at your pace
	print("I'm gonna have some coffee..")

	name = "New Name"
	// ok, done
	create()
}
```

## In Depth: Field alignment

In C, you can specify the alignment of each field in a struct, to make the whole data more align in the memory, thus increase efficiency.
