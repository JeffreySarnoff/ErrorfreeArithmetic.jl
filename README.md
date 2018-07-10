# ErrorfreeArithmetic.jl
Error-free transformations are used to get results with extra accuracy.


#### Copyright © 2016-2017 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl)

-----

## exports

*These are error-free transformations.*    

- two_sum, two_diff, two_sum_sorted, two_diff_sorted
- three_sum, three_diff, three_sum_sorted, three_diff_sorted
- two_square, two_cube, three_cube
- two_prod, three_prod
- three_fma


*While these are not strictly error-free transformations,*    
*they are as accurate as possible given the working precision.*  

- two_inv, two_div, two_sqrt

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

Takeshi Ogita, Siegfried M. Rump, and Shin'ichi Oishi    
Accurate Sum and Dot Product    
SIAM J. Sci. Comput., 26(6), 1955–1988.    
Published online: 25 July 2006    
[DOI: 10.1137/030601818](http://dx.doi.org/10.1137/030601818)  

Stef Graillat, Valérie Ménissier-Morain    
Error-Free Transformations in Real and Complex Floating Point Arithmetic    
International Symposium on Nonlinear Theory and its Applications (NOLTA'07), Sep 2007, Vancouver, Canada.     
Proceedings of International Symposium on Nonlinear Theory and its Applications (NOLTA'07), pp.341-344.    
https://hal.archives-ouvertes.fr/hal-01306229    

Sylvie Boldo, Stef Graillat, and Jean-Michel Muller    
On the robustness of the 2Sum and Fast2Sum algorithms    
ACM Transactions on Mathematical Software, Association for Computing Machinery, 2017    
https://hal.inria.fr/ensl-01310023    

