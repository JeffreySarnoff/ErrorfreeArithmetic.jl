# `two_sum`
`two_sum` is the name of the function that performs an error-free transformation on the sum of two values.
The original version of `two_sum`:
```
function two_sum(a, b)
    hi = a + b
    b_implicit = hi - a
    a_implicit = hi - b_implicit
    b_roundoff = b - b_implicit
    a_roundoff = a - a_implicit
    lo = a_roundoff + b_roundoff
    return hi, lo
end

function two_sum2(a, b)
    hi = a + b
    b_implicit = hi - a
    a_implicit = hi - b
    b_roundoff = b - b_implicit
    a_roundoff = a - a_implicit
    lo = a_roundoff + b_roundoff
    return hi, lo
end
```
the short form
```
function two_sum(a, b)
    hi = a + b
    b1 = hi - a
    lo = (a - (hi - b1)) + (b - b1)
    return hi, lo
end
```
# lo = (a - (hi - b)) + (b - (hi - a))

