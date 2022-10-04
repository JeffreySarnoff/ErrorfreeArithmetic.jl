
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
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    hi, md, lo
end

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
endend

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

