using ErrorfreeArithmetic
using Test

include("bigfloat.jl")
include("randfloat.jl")
include("permute.jl")
include("calc.jl")
include("testfuncs.jl")

#=
function hilo(::Type{T}, x::BigFloat) where {T}
    hi = T(x)
    lo = T(x - hi)
    return hi, lo
end

function himdlo(::Type{T}, x::BigFloat) where {T}
    hi = T(x)
    md = T(x - hi)
    lo = T(x - hi - md)
    return hi, md, lo
end

function isclosest(lo::T, low::T) where {T}
    lo === low || ((abs(lo - low) <= abs(lo - nextfloat(low))) && (abs(lo - low) <= abs(lo - prevfloat(low))))
end


a = sqrt(2.0)
b = sqrt(987654.0)
c = cbrt(456.125)

@test test_two_sum(a, b)
@test test_two_diff(a, b)
@test test_two_square(b)
@test test_two_prod(a, b)
@test test_two_inv(b)
@test test_two_div(a, b)
@test test_two_sqrt(b)

@test test_three_sum(a, b, c)
@test test_three_diff(a, b, c)
@test test_three_prod(a, b, c)
=#
