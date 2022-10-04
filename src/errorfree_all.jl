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
    hi, md, lo = three_maxmag(a, b, c) 
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    hi, md, lo
end

"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
@inline function two_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c)
    # hi = hi + (md + lo)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_sum(hi, md)
    hi, md
end

"""
    one_sum(a, b, c)
    
Computes `fl(a+b+c)`
"""
@inline function one_sum(a::T,b::T,c::T) where {T}
    hi, md, lo = three_maxmag(a, b, c) 
    hi + (md + lo)
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

function foursum(x1::T, x2::T, x3::T, x4::T) where {T}
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
    s, t = two_diff(-b, c)
    hi, u = two_sum(a, s)
    lo = u + t
    hi, lo = two_hilo_sum(hi, lo)
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
    four_diff(a, b, c, d)
    
Computes `hi = fl(a-b-c-d)` and `hm = err(a-b-c-d), ml = err(hm), lo = err(ml)`.
"""
function four_diff(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_diff(a ,  b)
    t0, t2 = two_diff(t0,  c)
    hi, t3 = two_diff(t0,  d)
    t0, t1 = two_sum(t1, t2)
    hm, t2 = two_sum(t0, t3) # here, t0 >= t3
    ml, lo = two_sum(t1, t2)
    return hi, hm, ml, lo
end

"""
    two_square(a)

Computes `hi = fl(a*a)` and `lo = fl(err(a*a))`.
"""
@inline function two_square(a::T) where {T}
    hi = a * a
    lo = fma(a, a, -hi)
    hi, lo
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
   three_fma(a, b, c)

Computes `hi = fl(fma(a,b,c))` and `md = fl(err(fma(a,b,c))), lo = fl(err(md))`.
"""
function three_fma(a::T, b::T, c::T) where {T}
    hi = fma(a, b, c) 
    hi0, lo0 = two_prod(a, b)
    hi1, lo1 = two_sum(c, lo0)
    hi2, lo2 = two_sum(hi0, hi1)
    y = ((hi2 - hi) + lo2)
    md, lo = two_hilo_sum(y, lo1)
    return hi, md, lo
end

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
   two_muladd(a, b, c)

Computes `hi = fl(muladd(a,b,c))` and `lo = fl(err(muladd(a,b,c)))`.
"""
function two_muladd(a::T, b::T, c::T) where {T}
    hi = fma(a, b, c)
    lo = fma(a, b, c-hi)
    return hi, lo
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
