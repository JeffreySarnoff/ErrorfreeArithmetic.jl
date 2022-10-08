# <n>_hilo_sum here
# <n>_lohi_sum follows

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
    two_hilo_sum(a, b, c, d)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c| ≥ |d|`
Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_hilo_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_hilo_sum(a ,  b)
    t0, t2 = two_hilo_sum(t0,  c)
    hi, t3 = two_hilo_sum(t0,  d)
    t0, t1 = two_hilo_sum(t1, t2)
    lo = t0 + t3
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
    three_hilo_sum(a, b, c, d)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c| ≥ |d|`
Computes `hi = fl(a+b+c+d)`, `mh = err(hi), ml = err(lo), lo = err(ml)`.
"""
function three_hilo_sum(a::T, b::T, c::T, d::T) where {T}
    md, lo = two_hilo_sum(b, c)
    hi, md = two_sum(a, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, mh, ml, lo
end

"""
    four_hilo_sum(a, b, c, d)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c| ≥ |d|`
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_hilo_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_hilo_sum(a ,  b)
    t0, t2 = two_hilo_sum(t0,  c)
    hi, t3 = two_hilo_sum(t0,  d)
    t0, t1 = two_hilo_sum(t1, t2)
    hm, t2 = two_hilo_sum(t0, t3) # here, t0 >= t3
    ml, lo = two_hilo_sum(t1, t2)
    return hi, hm, ml, lo
end

# <n>_lohi_sum here
# <n>_hilo_sum preceeds

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
    two_lohi_sum(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`
Computes `hi = fl(a+b+c)` and `lo = err(hi)`.
"""
function two_lohi_sum(a::T, b::T, c::T) where {T}
    lo, t = two_lohi_sum(b, c)
    hi, lo = two_sum(a, lo)
    lo += t
    hi, lo = two_hilo_sum(hi, lo)
    return hi, lo
end

"""
    two_lohi_sum(a, b, c, d)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`
Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_lohi_sum(a::T,b::T,c::T, d::T) where {T}
    t0, t1 = two_lohi_sum(a ,  b)
    t0, t2 = two_lohi_sum(t0,  c)
    hi, t3 = two_lohi_sum(t0,  d)
    t0, t1 = two_lohi_sum(t1, t2)
    lo = t0 + t3
    return hi, lo
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
    four_lohi_sum(a, b, c, d)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_lohi_sum(d::T,c::T,b::T,a::T) where {T}
    t0, t1 = two_hilo_sum(a ,  b)
    t0, t2 = two_hilo_sum(t0,  c)
    hi, t3 = two_hilo_sum(t0,  d)
    t0, t1 = two_hilo_sum(t1, t2)
    hm, t2 = two_hilo_sum(t0, t3)
    ml, lo = two_hilo_sum(t1, t2)
    return hi, hm, ml, lo
end
