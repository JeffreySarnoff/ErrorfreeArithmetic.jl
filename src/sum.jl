
"""
    one_sum(a, b)
Computes `fl(a+b)`.
"""
@inline function one_sum(a::T, b::T) where {T<:Real}
    return a + b
end

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

@inline function two_sum(a::T, b::T) where {T}
    hi = a + b
    b1 = hi - a
    eb = b - b1
    a1 = hi - b1
    ea = a - a1
    lo = ea + eb
    return hi, lo
end

"""
    one_sum(a, b, c)
    
Computes `fl(a+b+c)`
"""
@inline function one_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md += lo
    hi += md
    hi
end

"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md
end

"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
"""
function three_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md, lo
end

#=
"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_sum(a::T, b::T, c::T) where {T}
    s, t   = two_sum(b, c)
    hi, u  = two_sum(a, s)
    lo     = u + t
    two_hilo_sum(hi, lo)
end
=#
#=
function two_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md
end 


function three_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md, lo
end

@inline function two_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md
end

"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
"""
function three_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md, lo
end
=#

"""
    one_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)`.
"""
function two_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mh, ml, lo = four_maxmag(a, b, c, d)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi += mh
    hi
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(mh), lo = err(ml)`.
"""
function two_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mh, ml, lo = four_maxmag(a, b, c, d)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi, mh
end

"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `mh = err(hi), ml = err(hm)`.
"""
function three_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mh, ml, lo = four_maxmag(a, b, c, d)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi, mh, ml
end

"""
    four_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mh, ml, lo = four_maxmag(a, b, c, d)
    # pair hi,ml and mh,lo, follow algorithm 4
    # Jean-Michel Muller, Laurence Rideau.
    # Formalization of double-word arithmetic, and comments on
    sh, sl = two_hilo_sum(hi, mh)
    th, tl = two_hilo_sum(ml, lo)
    sl, th = two_sum(sl, th)
    sh, sl = two_hilo_sum(sh, sl)
    th, tl = two_hilo_sum(th, tl)
    sl, th = two_sum(sl, th)
    sh, sl = two_hilo_sum(sh, sl)
    sh, sl, th, tl
end
#=
function four_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mh, ml, lo = four_maxmag(a, b, c, d)
    # pair hi,ml and mh,lo, follow algorithm 4 
    # Jean-Michel Muller, Laurence Rideau. 
    # Formalization of double-word arithmetic, and comments on
    sh, sl = two_sum(hi, mh)
    th, tl = two_sum(ml, lo)
    c = sl + th
    vh, vl = two_hilo_sum(sh, c)
    w = tl + vl
    zh, zl = two_hilo_sum(vh, w)
    zh, zl, vh, w
end

#=
"""
    four_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mh, ml, lo = four_maxmag(a, b, c, d)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi, mh  = two_hilo_sum(hi, mh)
    mh, ml  = two_hilo_sum(mh, ml)
    ml, lo  = two_hilo_sum(ml, lo)
    hi, mh, ml, lo
end
=#

#=
"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `mh = err(hi), ml = err(hm)`.
"""
function three_sum(a::T, b::T, c::T, d::T) where {T}
    hi, t1 = two_sum(a ,  b)
    hi, t2 = two_sum(hi,  c)
    hi, t3 = two_sum(hi,  d)
    t1, t2, t3 = three_maxmag(t1, t2, t3)
    md, t2 = two_hilo_sum(t1, t2)
    lo = t2 + t3
    md, lo = two_sum(md, lo)
    return hi, md, lo
end
=#

"""
    one_sum(a, b, c, d)
    
Computes `fl(a+b+c+d)`
"""
@inline function one_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, b, c, d) 
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_sum(mdhi, mdlo)
    hi, mdhi = two_sum(hi, mdhi)
    mdlo, lo = two_hilo_sum(mdlo, lo)
    mdhi, mdlo = two_hilo_sum(mdhi, mdlo)
    hi, mdhi = two_hilo_sum(hi, mdhi)
    mdlo += lo
    mdhi += mdlo
    hi += mdhi
    hi
end

#=
"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `lo = err(hi)`.
"""
function two_sum(a::T, b::T, c::T, d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, b, c, d)
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
   three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `md = err(hi), lo = err(md)`.
"""
function three_sum(a::T, b::T, c::T, d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, b, c, d)
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
    four_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_sum(a::T,b::T,c::T,d::T) where {T}
    hi, mdhi, mdlo, lo = four_maxmag(a, b, c, d)
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
=#

# args sorted by decreasing magnitude
=#

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
    two_lohi_sum(a, b, c, d)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`

Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_lohi_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_lohi_sum(a ,  b)
    t0, t2 = two_lohi_sum(t0,  c)
    hi, t3 = two_lohi_sum(t0,  d)
    t0, t1 = two_lohi_sum(t1, t2)
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
    two_lohi_sum(a, b, c, d)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`

Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_lohi_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_lohi_sum(a ,  b)
    t0, t2 = two_lohi_sum(t0,  c)
    hi, t3 = two_lohi_sum(t0,  d)
    t0, t1 = two_lohi_sum(t1, t2)
    lo = t0 + t3
    return hi, lo
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
    three_lohi_sum(a, b, c)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`

Computes `hi = fl(a+b+c+d)`, `mh = err(hi), ml = err(mh), lo = err((ml)`.
"""
function three_lohi_sum(a::T, b::T, c::T, d::T) where {T}
    md, lo = two_lohi_sum(a, b)
    hi, md = two_sum(c, md)
    md, lo = two_lohi_sum(lo, md)
    hi, md = two_lohi_sum(md, hi)
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


