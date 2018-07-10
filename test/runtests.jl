using ErrorfreeArithmetic
using Base.Test

function correct_add{T<:AbstractFloat}(a::T, b::T)
     aa = convert(BigFloat, a)
     bb = convert(BigFloat, b)
     ab = aa + bb
     hi = T(ab)
     lo = T(ab - hi)
     return hi, lo
end

function correct_multiply{T<:AbstractFloat}(a::T, b::T)
     aa = convert(BigFloat, a)
     bb = convert(BigFloat, b)
     ab = aa * bb
     hi = T(ab)
     lo = T(ab - hi)
     return hi, lo
end

@test two_sum(sqrt(pi), sqrt(catalan)) == correct_add(sqrt(pi), sqrt(catalan))
@test two_prod(sqrt(pi), sqrt(catalan)) == correct_multiply(sqrt(pi), sqrt(catalan))

@test two_sum(1/sqrt(pi), 1/sqrt(catalan)) == correct_add(1/sqrt(pi), 1/sqrt(catalan))
@test two_prod(1/sqrt(pi), 1/sqrt(catalan)) == correct_multiply(1/sqrt(pi), 1/sqrt(catalan))
