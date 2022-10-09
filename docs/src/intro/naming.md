
_all error-free transformations are named following the same pattern_

`<how many values to return>_<arithmetic operation to perform>(<arguments>)`

The number of arguments accepted is not used in the function name, only the number of values to be returned appears.
All arguments are of a shared floating-point type, most often `Float64`.

For example, there are three signatures for the function `two_sum`, which returns the sum of the arguments in two values.
- `high, low = two_sum(a, b)`, `high, low = two_sum(a, b, c)`, `high, low = two_sum(a, b, c, d)`

`high` is the most significant part of the sum, `low` is the least significant part of the sum.

### examples

For the arithmetic operation `sum`, these are the error-free transformations available.

- `high = one_sum(a)`, `high = one_sum(a, b)`, `high = one_sum(a, b, c)`, `high = one_sum(a, b, c, d)` 
- `high, low = two_sum(a, b)`, `high, low = two_sum(a, b, c)`, `high, low = two_sum(a, b, c, d)`
- `high, mid, low = three_sum(a, b, c)`, `high, mid, low = three_sum(a, b, c, d)`
- `high, midhigh, midlow, low = four_sum(a, b, c, d)`

For the arithmetic operation `product`, these are the error-free transformations available.

- `high, low = two_prod(a, b)`, `high, low = two_prod(a, b, c)`
- `high, mid, low = three_prod(a, b, c)`


