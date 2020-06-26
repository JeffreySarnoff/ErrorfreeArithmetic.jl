"""
    ufp(x)
    
unit in the first place    
"""
ufp(x::T) where {T} = iszero(x) ? x : 2.0^(floor(log2(abs(x))))

"""
    ulp(x)
    
unit in the last place    
"""
ulp(x::T) where {T} = 2.0^(exponent(x)-precision(T)+1)

"""
    uls(x)
    
unit in the last significant place    
"""
uls(x::T) where {T} = ulp(x) * 2.0^(trailing_zeros(isignificand(x)))

"""
     significand_multiplier(T)
     
The scale applied to the integer form of a significand 
"""
significand_multiplier(::Type{T}) where {T} = T(2.0)^(-precision(R)+1)

"""
     isignificand(x)
     
The significand of `x` as an integer
"""
isignificand(x::T) where {T} = convert(Signed, fld(significand(x), signficand_multiplier(T)))

