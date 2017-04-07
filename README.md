# ErrorfreeArithmetic.jl
Error-free transformations are used to get results with extra accuracy.


#### Copyright © 2016-2017 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl)

-----

## exports

*These are error-free transformations.*    

add_errorfree, subtract_errorfree,   
add_inorder_errorfree, subtract_inorder_errorfree,    
square_errorfree,  multiply_errorfree,    
fma_errorfree, fms_errorfree

*This is likely an error-free transformation, though I have not seen a proof.*    
inv_errorfree 

*While these are not strictly error-free transformations, they are very nearly so.*    
*They are as accurate as possible given the working precision.*  

cube_accurately, divide_accurately,    
sqrt_accurately, invsqrt_accurately    

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
SIAM J. Sci. Comput., 26(6), 1955–1988. (34 pages)    
[DOI: 10.1137/030601818](http://dx.doi.org/10.1137/030601818)  
