# ErrorfreeArithmetic.jl
Errorfree transformations are used to get results that are as accurate as possible.


#### Copyright © 2016-2017 by Jeffrey Sarnoff.  Released under the MIT License.

-----

[![Build Status](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl.svg?branch=master)](https://travis-ci.org/JeffreySarnoff/ErrorfreeArithmetic.jl)

-----

## exports

* these are errorfree transformations    
add_errorfree, subtract_errorfree, 
add_inorder_errorfree, subtract_inorder_errorfree,
square_errorfree,  multiply_errorfree,
inv_errorfree, fma_errorfree, fms_errorfree,
* while these are not strictly errorfree transformations, they are very nearly so and as accurate as possible   
cube_accurately, divide_accurately, sqrt_accurately, invsqrt_accurately

## introduction

Errorfree transformations return a tuple of the nominal result and the residual from the result (the left-over part).    

