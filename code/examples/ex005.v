// returns 14
// chaining functions

fun multiply(a int, b int) int {
    a * b
}

fun divide(a int, b int) int = a / b

main {
   return divide(multiply(7, 6), 3)
}
