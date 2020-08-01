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

@inline function one_sum(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_sum(a.re, b.re)
    hi2, lo2 = two_sum(a.im, b.im)
    hi = Complex{T}(hi1, hi2)
    return hi
end

two_hilo_sum(a::Complex{T}, b::Complex{T}) where {T<:Real} = two_sum(a, b)
one_hilo_sum(a::Complex{T}, b::Complex{T}) where {T<:Real} = one_sum(a, b)

@inline function two_diff(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_diff(a.re, b.re)
    hi2, lo2 = two_diff(a.im, b.im)
    hi = Complex{T}(hi1, hi2)
    lo = Complex{T}(lo1, lo2)
    return hi, lo
end

@inline function one_diff(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_diff(a.re, b.re)
    hi2, lo2 = two_diff(a.im, b.im)
    hi = Complex{T}(hi1, hi2)
    return hi
end

two_hilo_diff(a::Complex{T}, b::Complex{T}) where {T<:Real} = two_diff(a, b)
one_hilo_diff(a::Complex{T}, b::Complex{T}) where {T<:Real} = one_diff(a, b)

#=
from "Error-free transformations in real and complex floating point arithmetics"
by Stef Graillat and Valérie Ménissier-Morain
2007 International Symposium on Nonlinear Theory and its Applications
NOLTA'07, Vancouver, Canada, September 16-19, 2007
N.B. modified to order q,r,s 
=#
@inline function four_prod(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_prod(a.re, b.re)
    hi2, lo2 = two_prod(a.im, b.im)
    hi3, lo3 = two_prod(a.re, b.im)
    hi4, lo4 = two_prod(a.im, b.re)
    hi5, lo5 = two_diff(hi1, hi2)
    hi6, lo6 = two_sum(hi3, hi4)
    p = Complex{T}(hi5, hi6)
    q = Complex{T}(lo5, lo6)
    r = Complex{T}(lo1, lo3)
    s = Complex{T}(-lo2, lo4)
    r, s = two_sum(r, s)
    q, r = two_sum(q, r)
    return p, q, r, s
end

@inline function three_prod(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_prod(a.re, b.re)
    hi2, lo2 = two_prod(a.im, b.im)
    hi3, lo3 = two_prod(a.re, b.im)
    hi4, lo4 = two_prod(a.im, b.re)
    hi5, lo5 = two_diff(hi1, hi2)
    hi6, lo6 = two_sum(hi3, hi4)
    p = Complex{T}(hi5, hi6)
    q = Complex{T}(lo5, lo6)
    r = Complex{T}(lo1, lo3)
    s = Complex{T}(-lo2, lo4)
    q, r = two_sum(q, r, s)
    return p, q, r
end

@inline function two_prod(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_prod(a.re, b.re)
    hi2, lo2 = two_prod(a.im, b.im)
    hi3, lo3 = two_prod(a.re, b.im)
    hi4, lo4 = two_prod(a.im, b.re)
    hi5, lo5 = two_diff(hi1, hi2)
    hi6, lo6 = two_sum(hi3, hi4)
    p = Complex{T}(hi5, hi6)
    re = one_sum(lo5, lo1, lo2)
    im = one_sum(lo6, lo3, lo4)
    q = Complex{T}(re, im)
    return p, q
end

@inline function one_prod(a::Complex{T}, b::Complex{T}) where {T<:Real}
    hi1, lo1 = two_prod(a.re, b.re)
    hi2, lo2 = two_prod(a.im, b.im)
    hi3, lo3 = two_prod(a.re, b.im)
    hi4, lo4 = two_prod(a.im, b.re)
    hi5, lo5 = two_diff(hi1, hi2)
    hi6 = hi3 + hi4
    p = Complex{T}(hi5, hi6)
    return p
end

