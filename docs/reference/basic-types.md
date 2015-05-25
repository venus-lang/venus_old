# Basic Types

Venus comes with built-in types like numbers, strings and dicts, and you can create your own type with the `type` statement. We'll introduce the built-in types first, which would cover most common tasks hopefully. And then you will see how to define your own type.

## Numbers

Venus handles numbers similar to C/C++/D, but has some differences.

Venus has these number types with different bitwidth:

| Type | Alias | Bit Width | Desc |
| --- | --- | --- | --- |
| i8 | byte | 8 | 8 bit integer |
| i16 | short | 16 | 16 bit integer |
| i32 | int | 32 | 32 bit integer |
| i64 | long | 64 | 64 bit integer |
|    |  | | |
| u8 | ubyte | 8 | 8 bit unsigned integer |
| u16 | ushort | 16 | 16 bit unsigned integer |
| u32 | uint | 32 | 32 bit unsigned integer |
| u64 | ulong | 64 | 64 bit unsigned integer |
| | | | |
| f32 | float | 32 | 32 bit float number |
| f64 | double | 64 | 64 bit float number |
| | | | |

### Number literals

you can write numbers in the code so that the compiler gets its type directly:

```d
val a = 123 // default type: int
val uint b = 123 // declare it is an uint
val c = 1000L // long integers tails with a capital 'L'
val d = 0x1F // hex numbers starts with '0x'
val big_number = 1000_000_000 // for long numbers, you can add '_' to make it clearer
val e = 0b10001 // binary numbers starts with '0b'

val f = 0.23 // default to doubles
val g = 12. // also double
val h = 0.9e12 // scientific
val i = 0.12f // floats
```
