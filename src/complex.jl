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
