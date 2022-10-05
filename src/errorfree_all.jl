"""
    one_minmag(a, b)

obtains value of least magnitude
"""
one_minmag(a::T, b::T) where {T} = abs(a) < abs(b) ? a : b 

"""
    one_maxmag(a, b)

obtains value of largest magnitude
"""
one_maxmag(a::T, b::T) where {T} = abs(a) < abs(b) ? b : a 

"""
    one_maxmag(a, b, c)

obtains value with largest magnitude
"""
function one_maxmag(a::T, b::T, c::T) where {T}
     one_maxmag(one_maxmag(a, b), c)
end

"""
    one_maxmag(a, b, c, d)

obtains value with largest magnitude
"""
function one_maxmag(a::T, b::T, c::T, d::T) where {T}
     one_maxmag(one_maxmag(a, b), one_maxmag(c, d))
end
    
"""
    two_maxmag(a, b)

orders (a, b) by descending magnitude
"""
two_maxmag(a::T, b::T) where {T} = abs(b) < abs(a) ? (a, b) : (b, a)

"""
    two_maxmag(a, b, c)

obtains two values with largest magnitudes in order of descending magnitude
"""
function two_maxmag(a::T, b::T, c::T) where {T}
     x, y = two_maxmag(a, b)
     x = one_maxmag(x, c)
     two_maxmag(x, y)
end

"""
    two_maxmag(a, b, c, d)

obtains two values with largest magnitudes in order of descending magnitude
"""
function two_maxmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_maxmag(a, b, c)
    two_maxmag(a, b, d)
end

"""
    three_maxmag(a, b, c)

orders (a, b, c) by descending magnitude
"""
function three_maxmag(x::T, y::T, z::T) where {T}
     y, z = two_maxmag(y, z)
     x, z = two_maxmag(x, z)
     x, y = two_maxmag(x, y)
     return x, y, z
end

"""
    four_maxmag(a, b, c, d)

orders (a, b, c, d) by descending magnitude
"""
function four_maxmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_maxmag(a, b)
    c, d = two_maxmag(c, d)
    a, c = two_maxmag(a, c)
    b, d = two_maxmag(b, d)
    b, c = two_maxmag(b, c)
     
    return a, b, c, d
end

#=
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
    one_sum(a, b, c)
    
Computes `fl(a+b+c)`
"""
@inline function one_sum(a::T,b::T,c::T) where {T}
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    md, lo = two_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md = md + lo
    hi = hi + md
    return hi
end

"""
    four_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    t5, lo = two_sum(t1, t3)
    hm, ml = two_sum(t4, t5)
    ml, lo = two_hilo_sum(ml, lo)
    hm, ml = two_hilo_sum(hm, ml)
    hi, hm = two_hilo_sum(hi,hm)
    return hi, hm, ml, lo
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
    one_sum(a, b, c, d)
    
Computes `fl(a+b+c+d)`.
"""
function one_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    t5, t6 = two_sum(t1, t3)
    lo, t7 = two_sum(t4, t5)
    t7 = t7 + t6
    lo, t7 = two_hilo_sum(lo, t7)
    hi = hi + lo
    return hi
end

=#

function vec_sum(x0::T, x1::T, x2::T, x3::T) where {T}
    s3 = x3
    s2, e3 = two_sum(x2, s3)
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    return s0,e1,e2,e3
end

function vsum_errbranch(x::NTuple{4,T}) where {T}
    y = zeros(T, 4)
    r = zeros(T, 4)
    e = zeros(T, 4)
    j = 1
    e[1] = x[1]
    for i = 1:2
        r[i], t = two_sum(e[i], x[i+1])
        if t !== zero(T)
            y[j] = r[i]
            e[i+1] = t
            j += 1
        else    
            e[i+1] = r[i]
        end    
    end
    y[j], y[j+1] = two_sum(e[3], x[4])
    return y
end

function foursumv(x1::T, x2::T, x3::T, x4::T) where {T}
    a1, a2 = two_sum(x1, x2)
    b1, b2 = two_sum(x3, x4)
    c1, c2 = two_sum(a1, b1)
    d1, d2 = two_sum(a2, b2)
    e1to4 = vec_sum(c1,c2,d1,d2)
    y = vsum_errbranch(e1to4)
    return (y...,)
end

"""
    five_sum(a, b, c, d, e)
    
Computes `s = fl(a+b+c+d+e)` and 
    `e1 = err(a+b+c+d), e2 = err(e1), e3 = err(e2), e4 = err(e3)`.
"""
function five_sum(v::T, w::T, x::T, y::T, z::T) where {T}
    t0, t4 = two_sum(y, z)
    t0, t3 = two_sum(x, t0)
    t0, t2 = two_sum(w, t0)
    a, t1  = two_sum(v, t0)
    t0, t3 = two_sum(t3, t4)
    t0, t2 = two_sum(t2, t0)
    b, t1  = two_sum(t1, t0)
    t0, t2 = two_sum(t2, t3)
    c, t1  = two_sum(t1, t0)
    d, e   = two_sum(t1, t2)
    return a, b, c, d, e
end


