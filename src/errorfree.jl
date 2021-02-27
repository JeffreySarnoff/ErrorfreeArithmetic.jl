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
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    md, lo = two_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md = md + lo
    hi, md = two_hilo_sum(hi, md)
    return hi, md
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    t5, t6 = two_sum(t1, t3)
    lo, t7 = two_sum(t4, t5)
    t7 = t7 + t6
    lo, t7 = two_hilo_sum(lo, t7)
    hi, lo = two_hilo_sum(hi, lo)
    return hi, lo
end

"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
"""
function three_sum(a::T, b::T, c::T) where {T}
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    md, lo = two_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, md, lo
end

"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `md = err(a+b+c+d), lo = err(md)`.
"""
function three_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    t5, t6 = two_sum(t1, t3)
    md, lo = two_sum(t4, t5)
    lo = lo + t6
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
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

@inline max_min(a,b) = abs(a) < abs(b) ? (b,a) : (a,b)

"""
    three_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `md = err(a*b*c), lo = err(md)`.
"""
function three_prod(a::T, b::T, c::T) where {T}
    a, b = max_min(a,b)
    a, c = max_min(a,c)
    b, c = max_min(b,c)
    abhi, ablo = two_prod(a, b)
    hi, abhiclo = two_prod(abhi, c)
    ablochi, abloclo = two_prod(ablo, c)
    md, lo, tmp  = three_sum(ablochi, abhiclo, abloclo)
    hi, md = two_sum(hi, md)
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
    two_lohi_sum(a, b)

*unchecked* requirement `|b| ≥ |a|`

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_lohi_sum(a::T, b::T) where {T}
    hi = b + a
    lo = a - (hi - b)
    return hi, lo
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
    two_lohi_diff(a, b)
    
*unchecked* requirement `|b| ≥ |a|`

Computes `hi = fl(a-b)` and `lo = err(a-b)`.
"""
@inline function two_lohi_diff(a::T, b::T) where {T}
    hi = b - a
    lo = (b - hi) - a
    hi, lo
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
    three_lohi_sum(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `x = fl(a+b+c)` and `y = err(a+b+c), z = err(y)`.
"""
function three_lohi_sum(a::T,b::T,c::T) where {T}
    md, lo = two_lohi_sum(a, b)
    hi, md = two_sum(c, md)
    md, lo = two_lohi_sum(lo, md)
    hi, md = two_lohi_sum(md, hi)
    return hi,md,lo
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

"""
    three_lohi_diff(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `x = fl(a-b-c)` and `y = err(a-b-c), z = err(y)`.
"""
function three_lohi_diff(c::T,b::T,a::T) where {T}
    three_lohi_sum(c, -b, -a)
end
