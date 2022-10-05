
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
    two_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c)`.
"""
function two_diff(a::T,b::T,c::T) where {T}
    hi, md, lo = three_maxmag(a, -b, -c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md
end

"""
    two_diff(a, b, c, d)
    
Computes `hi = fl(a-b-c-d)` and `hm = err(hi)`.
"""
function four_diff(a::T,b::T,c::T,d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, -b, -c, -d)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_sum(mdhi, mdlo)
    hi, mdhi = two_sum(hi, mdhi)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_hilo_sum(mdhi, mdlo)
    hi, mdhi = two_hilo_sum(hi, mdhi)
    mdlo += lo
    mdhi += mdlo
    hi, mdhi = two_hilo_sum(hi, mdhi)
    hi, mdhi
end

"""
    three_diff(a, b, c)
    
Computes `hi = fl(a-b-c)` and `md = err(hi), lo = err(md)`.
"""
function three_diff(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, -b, -c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md, lo
end

"""
    three_diff(a, b, c, d)
    
Computes `hi = fl(a-b-c-d)` and `hm = err(hi), ml = err(hm)`.
"""
function four_diff(a::T,b::T,c::T,d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, -b, -c, -d)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_sum(mdhi, mdlo)
    hi, mdhi = two_sum(hi, mdhi)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_hilo_sum(mdhi, mdlo)
    hi, mdhi = two_hilo_sum(hi, mdhi)
    mdlo += lo
    mdhi, mdlo = two_hilo_sum(mdhi, mdlo)
    hi, mdhi = two_hilo_sum(hi, mdhi)
    hi, mdhi, mdlo
end

"""
    four_diff(a, b, c, d)
    
Computes `hi = fl(a-b-c-d)` and `hm = err(hi), ml = err(hm), lo = err(ml)`.
"""
function four_diff(a::T,b::T,c::T,d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, -b, -c, -d)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_sum(mdhi, mdlo)
    hi, mdhi = two_sum(hi, mdhi)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_hilo_sum(mdhi, mdlo)
    hi, mdhi = two_hilo_sum(hi, mdhi)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_hilo_sum(mdhi, mdlo)
    hi, mdhi = two_hilo_sum(hi, mdhi)
    hi, mdhi, mdlo, lo
end


# with arguments sorted by magnitude

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

"""
    four_hilo_diff(a, b, c, d)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c| ≥ |d|`

Computes `hi = fl(a-b-c-d)` and `hm = err(a-b-c-d), ml = err(hm), lo = err(ml)`.
"""
function four_hilo_diff(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_hilo_diff(a,  b)
    t0, t2 = two_hilo_diff(t0,  c)
    hi, t3 = two_hilo_diff(t0,  d)
    t0, t1 = two_hilo_sum(t1, t2)
    hm, t2 = two_hilo_sum(t0, t3) # here, t0 >= t3
    ml, lo = two_hilo_sum(t1, t2)
    return hi, hm, ml, lo
end

"""
    four_hilo_diff(a, b, c, d)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`

Computes `hi = fl(a-b-c-d)` and `hm = err(a-b-c-d), ml = err(hm), lo = err(ml)`.
"""
function four_lohi_diff(d::T,c::T,b::T,a::T) where {T}
    t0, t1 = two_hilo_diff(a,  b)
    t0, t2 = two_hilo_diff(t0,  c)
    hi, t3 = two_hilo_diff(t0,  d)
    t0, t1 = two_hilo_sum(t1, t2)
    hm, t2 = two_hilo_sum(t0, t3) # here, t0 >= t3
    ml, lo = two_hilo_sum(t1, t2)
    return hi, hm, ml, lo
end
