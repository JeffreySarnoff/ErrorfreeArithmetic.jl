## Introduction

An _error-free transformation_ [EFT] is a transformation of a floating point realization of a mathematical operation that preserves the information inherent in the operation.  Ordinary floating point addition of two `Float64` values returns only that information about the sum which fits within a `Float64` variable.  For example, where `flsum` is short for `ordinary_Float64_sum` and `flsum_errorfree` is `flsum with the smaller, usually lost, value`.
```
flsum = 1.0 + 2.0^(-60)
flsum == 1.0
```
An error-free transformation of the floating point sum preserves the full value by returning two quantities.
```
flsum_errorfree = errorfree_sum(1.0, 2.0^(-60))
flsum_errorfree = (1.0, 2.0^(-60))
```
Here is another example
- we will check the result
    - finding it accurate through the last bit of the `lo` part
- we will verify the result
    - determining it obtains and preserves all non-zero value
```
flsum_errorfree = errorfree_sum(sqrt(3.0), sqrt(3.0)/1024)
flsum_errorfree == (1.7337422634356436, 3.686287386450715e-17)

# we can check that the result is as accurate as possible
# (here, through the last bit of the `lo` part) 
bigsum = BigFloat(sqrt(3.0)) + BigFloat(sqrt(3.0)/1024);
hi = Float64(bigsum); lo = Float64(bigsum - Float64(bigsum)); hi, lo
# (1.7337422634356436, 3.686287386450715e-17)

# we can verify that we captured and preserved all the non-zero value
Float64(bigsum - hi - lo) # all non-zero value has been preserved
# 0.0
```
In the literature, the value that disappears in the usual floating point addition is referred to as the `error` [of the sum].  That terminology seems slightly misleading to me. Instead, I use `hi` and `lo` to indicate or to designate the high order and low order values (the most significant and least significant parts). Basic arithmetic _error-free transformations_ (for 2-argument forms of `+`, `-`, and `*`), where the result does not underflow or overflow, share this property.
```
hi, lo = errorfree_transformation(x, y)
hi === arithmetic_operation(x, y)
hi + lo === hi # hi, lo do not overlap
```
There are error-free transformations that return more than 2 values.  The EFTs for the sum of three values and for fma return 3 values, and  that for the sum of four values returns 4 values.  Most of this discussion focuses on 2-argument functions.



