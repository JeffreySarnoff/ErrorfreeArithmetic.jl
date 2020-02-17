"""
    div_rem(x, y)

Computes `quotient = fl(x/y)` and `remainder = x - quotient*y` such that `(x-remainder) / y = quotient`.
"""
@inline function div_rem(x::T, y::T) where {T}
   quotient = x / y
   remainder = fma(-y, quotient, x)
   return quotient, remainder
end

"""
    sqrt_rem(x)

Computes `root = fl(sqrt(x))` and `remainder = x - root*root` such that `sqrt(x-remainder) = root`.
"""
@inline function sqrt_rem(x::T) where {T}
   root = sqrt(x)
   remainder = fma(-root, root, x)
   return root, remainder
end

#=
   Those remainders are exact.
   For more informations, applications and additional references, see the introduction of
   Sylvie Boldo and Jean-Michel Muller
   Some Functions Computable with a Fused-mac
=#
