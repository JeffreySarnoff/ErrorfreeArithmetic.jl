## A Guide to Function Names

_all error-free transformations are named following the same pattern_

`<how many values to return>_<arithmetic operation to perform>(<arguments>)`

The number of arguments accepted is not used in the function name, only the number of values to be returned appears.
All arguments are of a shared floating-point type, most often `Float64`.

For example, there are three signatures for the function `two_sum`, which returns the sum of the arguments in two values.
- `high, low = two_sum(a, b)`, `high, low = two_sum(a, b, c)`, `high, low = two_sum(a, b, c, d)`

`high` is the most significant part of the sum, `low` is the least significant part of the sum.

