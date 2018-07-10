using ErrorfreeArithmetic

try
    using Test
catch
    using Base.Test
end

BigFloat(x::T) where {T<:IEEEFloat} = convert(BigFloat, x)

function hilo(::Type{T} x::BigFloat) where {T<:IEEEFloat}
    hi = T(x)
    lo = T(x - hi)
    return hi, lo
end

function himdlo(::Type{T} x::BigFloat) where {T<:IEEEFloat}
    hi = T(x)
    md = T(x - hi)
    lo = T(x - hi - md)
    return hi, md, lo
end

function calc_two_sum(a::T, b::T) where {T<:IEEEFloat}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa + bb
    return hilo(T, ab)
end

function calc_two_diff(a::T, b::T) where {T<:IEEEFloat}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa - bb
    return hilo(T, ab)
end

function calc_two_prod(a::T, b::T) where {T<:IEEEFloat}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa * bb
    return hilo(T, ab)
end

function calc_two_div(a::T, b::T) where {T<:IEEEFloat}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa / bb
    return hilo(T, ab)
end

function calc_two_sqrt(a::T) where {T<:IEEEFloat}
    aa = BigFloat(a)
    ab = sqrt(aa)
    return hilo(T, ab)
end

function isclosest(lo::T, low::T) where {T<:IEEEFloat}
    lo === low || ((abs(lo - low) <= abs(lo - nextfloat(low))) && (abs(lo - low) <= abs(lo - prevfloat(low))))
end

function test_two_sum(a::T, b::T) where {T<:IEEEFloat}
    hi, lo = two_sum(a, b)
    high, low = calc_two_sum(a, b)
    hi === high && lo === low
end

function test_two_diff(a::T, b::T) where {T<:IEEEFloat}
    hi, lo = two_diff(a, b)
    high, low = calc_two_diff(a, b)
    hi === high && lo === low
end

function test_two_prod(a::T, b::T) where {T<:IEEEFloat}
    hi, lo = two_prod(a, b)
    high, low = calc_two_prod(a, b)
    hi === high && lo === low
end

function test_two_sqrt(a::T) where {T<:IEEEFloat}
    hi, lo = two_sqrt(a)
    high, low = calc_two_sqrt(a)     
    hi === high && isclosest(lo, low)
end

function test_two_div(a::T, b::T) where {T<:IEEEFloat}
    hi, lo = two_div(a, b)
    high, low = calc_two_div(a, b)     
    hi === high && isclosest(lo, low)
end



a = sqrt(2.0)
b = sqrt(987654.0)

@test test_two_sum(a, b)
@test test_two_diff(a, b)
@test test_two_prod(a, b)
@test test_two_sqrt(a, b)
@test test_two_div(a, b)
