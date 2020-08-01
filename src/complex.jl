#=
from "Error-free transformations in real and complex floating point arithmetics"
by Stef Graillat and Valérie Ménissier-Morain
2007 International Symposium on Nonlinear Theory and its Applications
NOLTA'07, Vancouver, Canada, September 16-19, 2007
=#
@inline function two_sum(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_sum(a.re, b.re)
    hi2, lo2 = two_sum(a.im, b.im)
    hi = Complex{T}(hi1, hi2)
    lo = Complex{T}(lo1, lo2)
    return hi, lo
end

@inline function two_diff(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_diff(a.re, b.re)
    hi2, lo2 = two_diff(a.im, b.im)
    hi = Complex{T}(hi1, hi2)
    lo = Complex{T}(lo1, lo2)
    return hi, lo
end

#=
from "Error-free transformations in real and complex floating point arithmetics"
by Stef Graillat and Valérie Ménissier-Morain
2007 International Symposium on Nonlinear Theory and its Applications
NOLTA'07, Vancouver, Canada, September 16-19, 2007
=#
@inline function four_prod(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_prod(a.re, b.re)
    hi2, lo2 = two_prod(a.im, b.im)
    hi3, lo3 = two_prod(a.re, b.im)
    hi4, lo4 = two_prod(a.im, b.re)
    hi5, lo5 = two_sum(hi1, -hi2)
    hi6, lo6 = two_sum(hi3, hi4)
    p = Complex{T}(hi5, hi6)
    q = Complex{T}(lo5, lo6)
    r = Complex{T}(lo1, lo3)
    s = Complex{T}(-lo2, lo4)
    return p,q,r,s
end

@inline function two_prod(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_prod(a.re, b.re)
    hi2, lo2 = two_prod(a.im, b.im)
    hi3, lo3 = two_prod(a.re, b.im)
    hi4, lo4 = two_prod(a.im, b.re)
    hi5, lo5 = two_sum(hi1, -hi2)
    hi6, lo6 = two_sum(hi3, hi4)
    p = Complex{T}(hi5, hi6)
    r = one_sum(lo5, lo1, -lo2)
    s = one_sum(lo6, lo3, lo4)
    q = Complex{T}(r, s)
    return p,q
end

#=
try different orders
a,b,c =
(1.4142135623730951 + 0.7071067811865476im, 1.4142135623730953e-15 + 7.071067811865476e-16im, 5.026525695313479 + 7.080698751085013im)
=#
"""
    three_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `md = err(a*b*c), lo = err(md)`.
"""
function three_prod(a::Complex{T}, b::Complex{T}, c::Complex{T}) where {T}
    abhi, ablo = two_prod(a, b)
    hi, abhiclo = two_prod(abhi, c)
    ablochi, abloclo = two_prod(ablo, c)
    md, lo, tmp  = three_sum(ablochi, abhiclo, abloclo)
    return hi, md, lo
end
