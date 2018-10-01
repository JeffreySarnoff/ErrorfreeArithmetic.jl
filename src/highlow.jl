const two27 = Float64(1<<27)

"""
extractScalar 

Splits value relative to an integral power of 2.

hi is the high order part of p, lo is the residual part
hi + lo === p
"""
function extractScalar(value::Float64)
   hi = (two27 + value) - two27
   lo = value - hi
   return hi, lo
end

function one_cube(value::Float64)
   hi, lo = extractscalar(value)
   return two_cube(hi, lo)
end

function two_cube(hi::T, lo::T) where {T<:AbstractFloat}
    hhh  = three_mul(hi, hi, hi)
    hhl  = three_mul(hi, hi, 3*lo)
    hll  = three_mul(hi, 3*lo, lo)
    lll  = three_mul(lo, lo, lo)
    
    himh = four_sum(hhh[1], hhl[1], hhh[2], hll[1])
    mllo = four_sum(hhl[2], hll[2], lll[1], lll[2])
    hilo = four_sum(himh[1], himh[2], mllo[1], mllo[2])

    return hilo[1], hilo[2], hilo[3]
end


