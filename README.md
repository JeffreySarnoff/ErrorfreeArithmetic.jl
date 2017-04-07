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

Error-free addition sums two floating point values (x, y) and returns two floating point values (hi, lo) such that:    
* (+)(x, y) == hi  and  (+)(hi, lo) == hi where |hi| > |lo|


## use

This package is intended to be used in the support of other work.    
All routines expect Float64 or Float32 or Float16 values.

