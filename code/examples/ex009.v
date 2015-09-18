// returns: 55
// fibonacci
//
fun fib(n int) int = if (n < 2) n else fib(n - 2) + fib(n - 1)

main {
    return fib(10)
}
