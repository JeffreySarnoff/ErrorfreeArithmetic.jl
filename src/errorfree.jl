# fastest sorting by decreasing magnitude
@inline amaxmin(x::T, y::T) where {T} = ifelse( abs(x) < abs(y), (y,x), (x,y) )

@inline function amaxmin(x::T, y::T, z::T) where {T}
    y, z = amaxmin(y, z)
    x, z = amaxmin(x, z)
    x, y = amaxmin(x, y)
    return x, y, z
end


#=
"Concerning the division [and sqrt], the elementary rounding error is
generally not a floating point number, so it cannot be computed
exactly. Hence we cannot expect to obtain an error
free transformation for the division. ...
This means that the computed approximation is as good as
we can expect in the working precision."
-- http://perso.ens-lyon.fr/nicolas.louvet/LaLo05.pdf
"While the sqrt algorithm [and division] is not strictly an errorfree transformation,
it is known to be reliable and is recommended for general use."
-- https://hal-ens-lyon.archives-ouvertes.fr/ensl-00545591v2/document
=#

@inline function two_div(a::T, b::T) where {T}
     hi = a / b
     lo = fma(-hi, b, a)
     lo /= b
     return hi, lo
end

@inline function two_sqrt(a::T) where {T}
    hi = sqrt(a)
    lo = fma(-hi, hi, a)
    lo /= 2
    lo /= hi
    return hi, lo
end

#=

"""
    two_sum(a, b)

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_sum(a::T, b::T) where {T<:Real}
    hi = a + b
    v  = hi - a
    lo = (a - (hi - v)) + (b - v)
    return hi, lo
end


"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
@inline function two_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = amaxmin(a, b, c) 
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md += lo
    return hi, md
end


"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
"""
function three_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = amaxmin(a, b, c) 
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    return hi, md, lo
end

"""
    two_diff(a, b)

Computes `s = fl(a-b)` and `e = err(a-b)`.
"""
@inline function two_diff(a::T, b::T) where {T}
    hi = a - b
    v  = hi - a
    lo = (a - (hi - v)) - (b + v)
    return hi, lo
end

"""
    three_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
"""
function three_diff(a::T,b::T,c::T) where {T}
    s, t = two_diff(-b, c)
    x, u = two_sum(a, s)
    y, z = two_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end


"""
    two_prod(a, b)

Computes `hi = fl(a*b)` and `lo = fl(err(a*b))`.
"""
@inline function two_prod(a::T, b::T) where {T}
    hi = a * b
    lo = fma(a, b, -hi)
    hi, lo
end

"""
    two_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `lo = err(hi)`.
"""
function two_prod(a::T, b::T, c::T) where {T}
    t,  k = two_prod(a, b)
    hi, e = two_prod(t, c)
    md, lo = two_fma(c, k, e)
    hi, md = two_hilo_sum(hi, md)
    md += lo
    return hi, md
end

"""
    three_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `md = err(a*b*c), lo = err(md)`.
"""
function three_prod(a::T, b::T, c::T) where {T}
    t,  k = two_prod(a, b)
    hi, e = two_prod(t, c)
    md, lo = two_fma(c, k, e)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    return hi, md, lo
end

#=
   three_fma algorithm from
   Sylvie Boldo and Jean-Michel Muller
   Some Functions Computable with a Fused-mac
=#

"""
   two_fma(a, b, c)

Computes `hi = fl(fma(a,b,c))` and `lo = fl(err(fma(a,b,c)))`.
"""
function two_fma(a::T, b::T, c::T) where {T}
    hi = fma(a, b, c) 
    hi0, lo0 = two_prod(a, b)
    hi1, lo1 = two_sum(c, lo0)
    hi2, lo2 = two_sum(hi0, hi1)
    lo = ((hi2 - hi) + lo2) + lo1
    return hi, lo
end

"""
   three_fma(a, b, c)

Computes `hi = fl(fma(a,b,c))` and `md = fl(err(fma(a,b,c))), lo = fl(err(md))`.
"""
function three_fma(a::T, b::T, c::T) where {T}
    hi = fma(a, b, c) 
    hi0, lo0 = two_prod(a, b)
    hi1, lo1 = two_sum(c, lo0)
    hi2, lo2 = two_sum(hi0, hi1)
    y = (hi2 - hi) + lo2
    md, lo = two_hilo_sum(y, lo1)
    return hi, md, lo
end

# with arguments sorted by magnitude

"""
    two_hilo_sum(a, b)

*unchecked* requirement `|a| ≥ |b|`

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_hilo_sum(a::T, b::T) where {T}
    hi = a + b
    lo = b - (hi - a)
    return hi, lo
end

"""
    two_hilo_sum(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_hilo_sum(a::T, b::T, c::T) where {T}
    lo, t = two_hilo_sum(b, c)
    hi, lo = two_sum(a, lo)
    lo += t
    hi, lo = two_hilo_sum(hi, lo)
    return hi, lo
end

"""
    three_hilo_sum(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `x = fl(a+b+c)` and `y = err(a+b+c), z = err(y)`.
"""
function three_hilo_sum(a::T, b::T, c::T) where {T}
    md, lo = two_hilo_sum(b, c)
    hi, md = two_sum(a, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi,md,lo
end

"""
    two_hilo_diff(a, b)
    
*unchecked* requirement `|a| ≥ |b|`

Computes `hi = fl(a-b)` and `lo = err(a-b)`.
"""
@inline function two_hilo_diff(a::T, b::T) where {T}
    hi = a - b
    lo = (a - hi) - b
    hi, lo
end

"""
    three_hilo_diff(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `x = fl(a-b-c)` and `y = err(a-b-c), z = err(y)`.
"""
function three_hilo_diff(a::T,b::T,c::T) where {T}
    md, lo = two_hilo_sum(-b, -c)
    hi, md = two_sum(a, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi,md,lo 
end


=#
