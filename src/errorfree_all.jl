# vec_sum

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

# reduced significance variation of [LO2020] p.14
"""
    two_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `lo = err(hi)`.
"""
function two_prod(a::T, b::T, c::T) where {T}
    s1, t2, t3, t4 = unsafe_four_prod(a, b, c)
    s2 = t2 + t3
    s1, s2
end

# [LO2020] p.14
function three_prod(a::T, b::T, c::T) where {T}
    s1, t2, t3, t4 = unsafe_four_prod(a, b, c)
    s2, t5 = two_hilo_sum(t2, t3)
    s3 = t5 + t4
    s1, s2, s3
end

# [LO2020] p.13
function unsafe_four_prod(a::T, b::T, c::T) where {T}
    thi, tlo = two_prod(b, c)
    shi, smh = two_prod(a, thi)
    sml, slo = two_prod(a, tlo)
    shi, smh, sml, slo
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

