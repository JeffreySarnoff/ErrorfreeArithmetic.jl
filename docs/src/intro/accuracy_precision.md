## Accuracy and Precision

`Accuracy` codifies correctness. `Precision` conveys exactness.

The two common values for Accuracy are *absolute error* and *relative error*.
- absolute error `abserr` measures the magnitude of the distance from the true value that holds for the obtained value.
    - `abserr(truevalue, obtainedvalue) = abs(truevalue - obtainedvalue)`
- relative error `relerr` meassure the proportional difference of the true value and  the obtained value.
    - `relerr(truevalue, obtainedvalue) = abserr(truevalue, obtainedvalue) / truevalue`
 
Precision is given by the number of significant bits in a binary floating point value.
