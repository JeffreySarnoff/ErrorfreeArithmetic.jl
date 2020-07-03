##### All floating point types conform to the IEEE754-2019 Standard for Floating Point Arithmetic.
----

We use Float64, Float32 and Float16 types, Signed and Unsigned machine integer types.

``` julia
using Base: IEEEFloat, uinttype

using Base.Math: 
    sign, signbit, 
    exponent, exponent_mask, exponent_bits, exponent_bias, exponent_max,
    significand, significand_mask, significand_bits

# complements `exponent_max`
#  appropriate for use in `ldexp(prevfloat(one(T)), exponent_min(T))`
exponent_min(::Type{T}) where {T<:IEEEFloat} = -exponent_max(T) + 3
exponent_min_subnormal(::Type{T}) where {T<:IEEEFloat} = exponent_min(T) - significand_bits(T)
```

``` julia
# like `Base.uinttype` for Signed, IEEEFloat types
for (F,U,I) in ((:Float64, :UInt64, :Int64), (:Float32, :UInt32, :Int32), 
                (:Float16, :UInt16, :Int16))
  @eval begin
    inttype(::Type{$F}) = $I
    floattype(::Type{$U}) = $F
    floattype(::Type{$I}) = $F
    UIntType(x::$F) = reinterpret(uinttype($F), x)
    IntType(x::$F) = reinterpret(sinttype($F), x)
    FloatType(x::$F) = reinterpret(floattype($F), x)
  end
end
```




[^IEEE754-2019]:
https://ieeexplore.ieee.org/document/8766229


[^Boldo-Daumas-2003]


[^Boldo-Daumas-2003]: 
Sylvie Boldo, Marc Daumas. 
"Properties of two's complement floating point notation"
Intl J Softw Tools Technol Transfer (2003)
Digital Object Identifier (DOI) 10.1007/s10009-003-0120-y
url = https://hal.archives-ouvertes.fr/file/index/docid/157268/filename/BolDau04a.pdf



<sup>[[1]](#boldo-daumas-2003)</sup>

<a name="boldo-daumas-2003"><sup>[1]</sup></a>&nbsp;[Boldo & Daumas 2003]</a>

"Properties of two's complement floating point notation"
Intl J Softw Tools Technol Transfer (2003)
Digital Object Identifier (DOI) 10.1007/s10009-003-0120-y

Properties

@article{article,
author = {Boldo, Sylvie and Daumas, Marc},
title = {Properties of two's complement floating point notations},
year = {2004},
month = {03},
journal = {STTT}, International Journal on Software Tools for Technology Transfer
volume = {5},
pages = {237-246},
doi = {10.1007/s10009-003-0120-y}
url = https://hal.archives-ouvertes.fr/file/index/docid/157268/filename/BolDau04a.pdf
}
Properties of two’s complement floating point notations. 
International Journal on Software Tools for Technology Transfer, Springer Verlag, 2003, 5 (2-3), pp.237-246. 
￿10.1007/s10009-003-0120-y￿. ￿hal-00157268￿

Boldo, Sylvie & Daumas, Marc. (2004). 
Properties of two's complement floating point notations. 
STTT. 5. 237-246. 10.1007/s10009-003-0120-y. 
