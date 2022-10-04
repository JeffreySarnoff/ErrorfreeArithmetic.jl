
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

