
"""
    two_square(a)
Computes `hi = fl(a*a)` and `lo = fl(err(a*a))`.
"""
@inline function two_square(a::T) where {T}
    hi = a * a
    lo = fma(a, a, -hi)
    hi, lo
end

"""
    two_prod(a, b)
Computes `hi = fl(a*b)` and `lo = fl(err(a*b))`.
"""
@inline function two_prod(a::T, b::T) where {T}
    hi = a * b
    lo = fma(a, b, -hi)
    hi, lo
end

@inline max_min(a,b) = abs(a) < abs(b) ? (b,a) : (a,b)

# reduced significance variation of [LO2020] p.14
"""
    two_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `lo = err(hi)`.
"""
function two_prod(a::T, b::T, c::T) where {T}
    s1, t2, t3, t4 = unsafe_four_prod(a, b, c)
    s2 = t2 + t3
    s1, s2 = two_hilo_sum(s1, s2)
    s1, s2
end

function three_prod(a::T, b::T, c::T) where {T}
    thi, tlo = two_prod(b, c)
    shi, smh = two_prod(a, thi)
    sml, slo = two_prod(a, tlo)
    smh, sml = two_hilo_sum(smh, sml)
    sml += slo
    shi, smh = two_hilo_sum(shi, smh)
    smh, sml = two_hilo_sum(smh, sml)
    shi, smh, sml
end

# [LO2020] p.13-14
function unsafe_three_prod(a::T, b::T, c::T) where {T}
    s1, s2, s3, s4 = unsafe_four_prod(a, b, c)
    s2, s3 = two_hilo_sum(s2, s3)
    s3 = s3 + s4
    s1, s2, s3
end

function unsafe_four_prod(a::T, b::T, c::T) where {T}
    thi, tlo = two_prod(b, c)
    shi, smh = two_prod(a, thi)
    sml, slo = two_prod(a, tlo)
    shi, smh, sml, slo
end

#=
   fma algorithms from
   Sylvie Boldo and Jean-Michel Muller
   Some Functions Computable with a Fused-mac
=#

"""
   two_fma(a, b, c)
Computes `hi = fl(fma(a,b,c))` and `lo = fl(err(fma(a,b,c)))`.
"""
function two_fma(a::T, b::T, c::T) where {T}
    hi = fma(a, b, c) 
    hi0, lo0 = two_prod(a, b)
    hi1, lo1 = two_sum(c, lo0)
    hi2, lo2 = two_sum(hi0, hi1)
    lo = ((hi2 - hi) + lo2) + lo1
    return hi, lo
end

"""
   three_fma(a, b, c)
Computes `hi = fl(fma(a,b,c))` and `md = fl(err(fma(a,b,c))), lo = fl(err(md))`.
"""
function three_fma(a::T, b::T, c::T) where {T}
    hi = fma(a, b, c) 
    hi0, lo0 = two_prod(a, b)
    hi1, lo1 = two_sum(c, lo0)
    hi2, lo2 = two_sum(hi0, hi1)
    y = ((hi2 - hi) + lo2)
    md, lo = two_hilo_sum(y, lo1)
    return hi, md, lo
end

