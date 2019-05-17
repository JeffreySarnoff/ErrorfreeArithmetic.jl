const two27 = Float64(1<<27)
const two12 = Float32(1<<12)
const two6  = Float16(1<<6)

"""
    extractscalar

Split a value relative to an integral power of 2

hi is the high order part of p, lo is the residual part
hi + lo === p
"""

for (T,P) in ((:Float64, 53), (:Float32, 24), (:Float16, 11))
  @eval begin
    @inline function extractscalar(value::$T)
        powoftwo =  ldexp(one($T), ($P- exponent(value)) >> 1) # P == precision(Float64)
        return extractscalar(powoftwo, value)
    end
  end
end

function extractscalar(powoftwo::T, value::T) where {T}
   hi = (powoftwo + value) - powoftwo
   lo = value - hi
   return hi, lo
end



"""
    two_cube(a)
    
Computes `s = fl(a*a*a)` and `e1 = err(a*a*a)`.
"""
function two_cube(value::T) where {T}
    hi, lo = extractscalar(value)
    hhh  = three_prod(hi, hi, hi)
    hhl  = three_prod(hi, hi, 3*lo)
    hll  = three_prod(hi, 3*lo, lo)
    lll  = three_prod(lo, lo, lo)
    
    himh = four_sum(hhh[1], hhl[1], hhh[2], hll[1])
    mllo = four_sum(hhl[2], hll[2], lll[1], lll[2])
    hilo = four_sum(himh[1], himh[2], mllo[1], mllo[2])

    return hilo[1], hilo[2]
end

"""
    three_cube(a)
    
Computes `s = fl(a*a*a)` and `e1 = err(a*a*a), e2 = err(e1)`.
"""
function three_cube(value::T) where {T}
    hi, lo = extractscalar(value)
    hhh  = three_prod(hi, hi, hi)
    hhl  = three_prod(hi, hi, 3*lo)
    hll  = three_prod(hi, 3*lo, lo)
    lll  = three_prod(lo, lo, lo)
    
    himh = four_sum(hhh[1], hhl[1], hhh[2], hll[1])
    mllo = four_sum(hhl[2], hll[2], lll[1], lll[2])
    hilo = four_sum(himh[1], himh[2], mllo[1], mllo[2])

    return hilo[1], hilo[2], hilo[3]
end

"""
    four_cube(a)
    
Computes `s = fl(a*a*a)` and `e1 = err(a*a*a), e2 = err(e1), e3 = err(e2)`.
"""
function three_cube(value::T) where {T}
    hi, lo = extractscalar(value)
    hhh  = three_prod(hi, hi, hi)
    hhl  = three_prod(hi, hi, 3*lo)
    hll  = three_prod(hi, 3*lo, lo)
    lll  = three_prod(lo, lo, lo)
    
    himh = four_sum(hhh[1], hhl[1], hhh[2], hll[1])
    mllo = four_sum(hhl[2], hll[2], lll[1], lll[2])
    hilo = four_sum(himh[1], himh[2], mllo[1], mllo[2])

    return hilo
end
