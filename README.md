# ErrorfreeArithmetic.jl
Error-free transformations are used to get results with extra accuracy.


#### Copyright © 2016-2022 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl.svg?branch=main)](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl)  [![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://JeffreySarnoff.github.io/ErrorfreeArithmetic.jl/dev)


-----


## exports

- The number that begins a function name always matches the number of values returned.
    - the values returned are of descending magnitude and non-overlapping when added. 
- The number that begins a function name often matches the number of arguments expected.
    - `two_inv` and `two_sqrt` are single argument functions returning two values

*These are error-free transformations.*

- `two_sum`, `two_diff`, `two_prod`
- `two_square`, `two_cube`
- `three_sum`, `three_diff`, `three_prod`
- `two_fma`, `three_fma`
- `four_sum`, `four_diff`

*These are error-free transformations with magnitude sorted arguments.*

- `two_hilo_sum`, `two_lohi_sum`
- `two_hilo_diff`, `two_lohi_diff`
- `three_hilo_sum`, `three_lohi_sum`
- `three_hilo_diff`, `three_lohi_diff`
- `four_hilo_sum`, `four_lohi_sum`
- `four_hilo_diff`, `four_lohi_diff`

*These are least-error transformations, as close to error-free as possible.*

- `two_inv`, `two_sqrt`
- `two_div`

### naming

The routines named with the prefix `two_` return a two-tuple holding `(high_order_part, low_order_part)`.

Those named with the prefix `three_` return a three-tuple holding `(high_part, mid_part, low_part)`.


## introduction

Error-free transformations return a tuple of the nominal result and the residual from the result (the left-over part).    

Error-free addition sums two floating point values (a, b) and returns two floating point values (hi, lo) such that:    
* `(+)(a, b) == hi` 
* `|hi| > |lo|` and `(+)(hi, lo) == hi`  *abs(hi) and abs(lo) do not share significant bits*

Here is how it is done:

```julia
function add_errorfree(a::T, b::T) where T<:Union{Float64, Float32}
    a_plus_b_hipart = a + b
    b_asthe_summand = a_plus_b_hipart - a
    a_plus_b_lopart = (a - (a_plus_b_hipart - b_asthe_summand)) + (b - b_asthe_summand)
    return a_plus_b_hipart, a_plus_b_lopart
end

a = Float32(1/golden^2)                           #   0.3819_6602f0
b = Float32(pi^3)                                 #  31.0062_7700f0
a_plus_b = a + b                                  #  31.3882_4300f0

hi, lo = add_errorfree(a,b)                       # (31.3882_4300f0, 3.8743_0270f-7)

a_plus_b == hi                                    # true
abs(hi) > abs(lo) && hi + lo == hi                # true

```
The `lo` part is a portion of the accurate value, it is (most of) the residuum that the `hi` part could not represent.    
The `hi` part runs out of significant bits before the all of the accurate value is represented.  We can see this:        
```julia
a = Float32(1/golden^2)                           #   0.3819_6602f0
b = Float32(pi^3)                                 #  31.0062_7700f0

hi, lo = add_errorfree(a,b)                       # (31.3882_4300f0, 3.8743_0270f-7)

a_plus_b_accurate = BigFloat(a) + BigFloat(b)
lo_accurate  = Float32(a_plus_b_accurate - hi)

lo == lo_accurate                                 # true
```

## use

This package is intended to be used in the support of other work.    
All routines expect Float64 or Float32 or Float16 values.


## references

[LO2020] Marko Lange and Shin'ichi Oishi
A note on Dekker’s FastTwoSum algorithm
Numerische Mathematik (2020) 145:383–403
https://doi.org/10.1007/s00211-020-01114-2

[BGM2017] Sylvie Boldo, Stef Graillat, and Jean-Michel Muller
On the robustness of the 2Sum and Fast2Sum algorithms
ACM Transactions on Mathematical Software, Association for Computing Machinery, 2017
https://hal.inria.fr/ensl-01310023

[GMM2007] Stef Graillat, Valérie Ménissier-Morain
Error-Free Transformations in Real and Complex Floating Point Arithmetic
International Symposium on Nonlinear Theory and its Applications (NOLTA'07), Sep 2007, Vancouver, Canada.
Proceedings of International Symposium on Nonlinear Theory and its Applications (NOLTA'07), pp.341-344.
https://hal.archives-ouvertes.fr/hal-01306229

[ORO2006] Takeshi Ogita, Siegfried M. Rump, and Shin'ichi Oishi
Accurate Sum and Dot Product
SIAM J. Sci. Comput., 26(6), 1955–1988.
Published online: 25 July 2006
DOI: 10.1137/030601818

[D1971] T.J. Dekker A floating-point technique for extending the available precision. Numer. Math. 18, 224–242 (1971). https://doi.org/10.1007/BF01397083
