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
    return (hi, lo)
end
#=
@inline function two_sum(a::T, b::T) where {T}
    hi = a + b
    b1 = hi - a
    eb = b - b1
    a1 = hi - b1
    ea = a - a1
    lo = ea + eb
    return hi, lo
end
=#

"""
    one_sum(a, b, c)
    
Computes `fl(a+b+c)`
"""
function one_sum(x0::T, x1::T, x2::T) where {T}
    s2 = x2
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s1 = e1 + e2
    s0 + s1
end

"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_sum(x0::T, x1::T, x2::T) where {T}
    s2 = x2
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s1, e2 = two_sum(e1, e2)
    s0, e1 = two_hilo_sum(s0, s1)
    e1 += e2
    (s0, e1)
end

"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
"""
function three_sum(x0::T, x1::T, x2::T) where {T}
    s2 = x2
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s1, e2 = two_sum(e1, e2)
    s0, e1 = two_hilo_sum(s0, s1)
    e1, e2 = two_hilo_sum(e1, e2)
    (s0, e1, e2)
end

"""
    one_sum(a, b, c, d)
    
Computes `fl(a+b+c+d)`
"""
@inline function one_sum(x0::T, x1::T, x2::T, x3::T) where {T}
    s3 = x3
    s2, e3 = two_sum(x2, s3)
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s2, e3 = two_sum(e2, e3)
    s1, e2 = two_sum(e1, s2)
    s0, e1 = two_hilo_sum(s0, s1)
    e2 += e3
    e1 += e2
    s0 += e1
    return s0
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(mh), lo = err(ml)`.
"""
function two_sum(x0::T, x1::T, x2::T, x3::T) where {T}
    s3 = x3
    s2, e3 = two_sum(x2, s3)
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s2, e3 = two_sum(e2, e3)
    s1, e2 = two_sum(e1, s2)
    s0, e1 = two_hilo_sum(s0, s1)
    e2 += e3
    e1 += e2
    s0, e1 = two_hilo_sum(s0, e1)
    return (s0, e1)
end

"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `mh = err(hi), ml = err(hm)`.
"""
function three_sum(x0::T, x1::T, x2::T, x3::T) where {T}
    s3 = x3
    s2, e3 = two_sum(x2, s3)
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s2, e3 = two_sum(e2, e3)
    s1, e2 = two_sum(e1, s2)
    s0, e1 = two_hilo_sum(s0, s1)
    e2 += e3
    e1, e2 = two_hilo_sum(e1, e2)
    s0, e1 = two_hilo_sum(s0, e1)
    return (s0, e1, e2)
end

"""
    four_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
function four_sum(x0::T, x1::T, x2::T, x3::T) where {T}
    s3 = x3
    s2, e3 = two_sum(x2, s3)
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    s2, e3 = two_sum(e2, e3)
    s1, e2 = two_sum(e1, s2)
    s0, e1 = two_hilo_sum(s0, s1)
    e2, e3 = two_hilo_sum(e2, e3)
    e1, e2 = two_hilo_sum(e1, e2)
    s0, e1 = two_hilo_sum(s0, e1)
    return (s0, e1, e2, e3)
end

