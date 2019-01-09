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

function extractscalar(powoftwo::T, value::T) where {T<:IEEEFloat}
   hi = (powoftwo + value) - powoftwo
   lo = value - hi
   return hi, lo
end
