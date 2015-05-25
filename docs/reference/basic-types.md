# Basic Types

Venus comes with built-in types like numbers, strings and dicts, and you can create your own type with the `type` statement. We'll introduce the built-in types first, which would cover most common tasks hopefully. And then you will see how to define your own type.

## Numbers

Venus handles numbers similar to C/C++/D, but has some differences.

Venus has these number types with different bitwidth:

| Type | Alias | Bit Width | Desc |
| --- | --- | --- | --- |
| i8 | byte, char | 8 | 8 bit integer |
| i16 | short | 16 | 16 bit integer |
| i32 | int | 32 | 32 bit integer |
| i64 | long | 64 | 64 bit integer |
|    |  | | |
| u8 | ubyte, uchar | 8 | 8 bit unsigned integer |
| u16 | ushort | 16 | 16 bit unsigned integer |
| u32 | uint | 32 | 32 bit unsigned integer |
| u64 | ulong | 64 | 64 bit unsigned integer |
| | | | |
| f32 | float | 32 | 32 bit float number |
| f64 | double | 64 | 64 bit float number |
| | | | |

