# Pool

Instead of GC, Venus provide object pools for object lifetime management.

You can get an object from a pool, using `ref` (readonly) or `ptr` (for mutable)

```d
import std.pool
ptr o = pool.get[string]
ref o1 = pool.get[string]

pool.release(o)
pool.release(o1)
```

and the pool will automatically manage the object's lifecycle for you.
