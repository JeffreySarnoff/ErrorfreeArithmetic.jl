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
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_sum(a::T, b::T) where {T}
    hi = a + b
    v  = hi - a
    lo = (a - (hi - v)) + (b - v)
    return hi, lo
end

"""
    ieee_two_sum(a, b)

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
- Handles `Inf` properly.
"""
@inline function ieee_two_sum(a::T, b::T) where {T}
    hi = a + b
    isinf(hi) && return (hi, zero(T))
    v  = hi - a
    lo = (a - (hi - v)) + (b - v)
    return hi, lo
end

"""
   two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_sum(a::T, b::T, c::T) where {T}
    t0, t1 = two_sum(b, c) 
    hi, t0 = two_sum(a, t0)
    t0 += t1
    hi, lo = two_hilo_sum(hi, t0)
    return hi, lo
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c) | isinf(d))
"""
function two_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    lo = t4 + (t1+t3)
    hi, lo = two_hilo_sum(hi, lo)
    return hi, lo
end


"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
- Does not presort magnitudes
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
    ieee_three_sum(a, b, c)

Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
- Does not presort magnitudes
- Handles `Inf` properly.
"""
function ieee_three_sum(a::T, b::T, c::T) where {T}
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    isinf(hi) && return (hi, zero(T), zero(T))
    md, lo = two_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, md, lo
end

"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `md = err(a+b+c+d),  lo = err(s2)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c) | isinf(d))
"""
function three_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    t5, lo = two_sum(t1, t3)
    hm, ml = two_sum(t4, t5)
    ml, lo = two_hilo_sum(ml, lo)
    hm, ml = two_hilo_sum(hm, ml)
    hi, hm = two_hilo_sum(hi,hm)
    return hi, hm, ml
end

"""
   three_hilo_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))
- Unchecked Precondition: abs(a) >= abs(b) >= abs(c)
- Does not presort magnitudes
"""
function three_hilo_sum(a::T, b::T, c::T) where {T}
    md, lo = two_hilo_sum(b, c)
    hi, md = two_sum(a, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi,md,lo
end

#=
function three_hilo_sum(a::T, b::T, c::T) where {T}
    md, lo = two_hilo_sum(b, c)
    hi, md = two_sum(a, md)
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi,md,lo
end
=#

"""
   ieee_fast_three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
- Handles `Inf` properly.
- Unchecked Precondition: abs(a) >= abs(b) >= abs(c)
- Does not presort magnitudes
"""
function ieee_three_hilo_sum(a::T, b::T, c::T) where {T}
    md, lo = two_hilo_sum(b, c) 
    hi, md = two_sum(a, md)
    isinf(hi) && return (hi, zero(T), zero(T))
    md, lo = two_hilo_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, md, lo
end

#=
"""
   three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))
"""
function three_sum(a::T, b::T, c::T) where {T}
    a, b, c = magnitude_mintomax(a, b, c)
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    md, lo = two_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, md, lo
end

"""
   ieee_three_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c), lo = err(md)`.
- Handles `Inf` properly.
"""
function ieee_three_sum(a::T, b::T, c::T) where {T}
    a, b, c = magnitude_mintomax(a, b, c)
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    isinf(hi) && return (hi, zero(T), zero(T))
    md, lo = two_sum(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, md, lo
end
=#

"""
    ieee_fast_four_sum(a, b, c, d)
    
Computes `s1 = fl(a+b+c+d)` and `s2 = err(a+b+c+d),  s3 = err(himd), s4 = err(lomd)`.
- Handles `Inf` properly.
- Does not presort magnitudes
"""
function ieee_fast_four_sum(a::T, b::T, c::T, d::T) where {T}
    s3, s4 = two_sum(c, d)
    s2, s3 = two_sum(b, s3)
    s1, s2 = two_sum(a, s2)
    isinf(s1) && return (s1, zero(T), zero(T), zero(T))
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    return s1, s2, s3, s4
end

"""
    four_sum(a, b, c, d)
    
Computes `s1 = fl(a+b+c+d)` and `s2 = err(a+b+c+d),  s3 = err(himd), s4 = err(lomd)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c) | isinf(d))
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
    ieee_four_sum(a, b, c, d)
    
Computes `s1 = fl(a+b+c+d)` and `s2 = err(a+b+c+d),  s3 = err(himd), s4 = err(lomd)`.
- Handles `Inf` properly.
"""
function ieee_four_sum(a::T, b::T, c::T, d::T) where {T}
    t0, t1 = two_sum(a,  b)
    t2, t3 = two_sum(c,  d)
    hi, t4 = two_sum(t0, t2)
    isinf(hi) && return (hi, zero(T), zero(T), zero(T))    
    t5, lo = two_sum(t1, t3)
    hm, ml = two_sum(t4, t5)
    ml, lo = two_hilo_sum(ml, lo)
    hm, ml = two_hilo_sum(hm, ml)
    hi, hm = two_hilo_sum(hi,hm)
    return hi, hm, ml, lo
end

# arguments sorted by magnitude

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
    two_diff(a, b)

Computes `s = fl(a-b)` and `e = err(a-b)`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_diff(a::T, b::T) where {T}
    hi = a - b
    v  = hi - a
    lo = (a - (hi - v)) - (b + v)
    return hi, lo
end

"""
    ieee_two_diff(a, b)

Computes `s = fl(a-b)` and `e = err(a-b)`.
- Handles `Inf` properly
"""
@inline function ieee_two_diff(a::T, b::T) where {T}
    hi = a - b
    isinf(hi) && return (hi, zero(T))
    v  = hi - a
    lo = (a - (hi - v)) - (b + v)
    return hi, lo
end

"""
   three_diff(a, b, c)
    
Computes `hi = fl(a-b-c)` and `md = err(a-b-c), lo = err(md)`.
- Does not presort magnitudes
"""
function three_diff(a::T, b::T, c::T) where {T}
    md, lo = two_diff(b, c) 
    hi, md = two_sum(a, md)
    md, lo = two_diff(md, lo)
    hi, md = two_hilo_sum(hi, md)
    return hi, md, lo
end

four_diff(a::T, b::T, c::T, d::T) where {T} =
    four_sum(a, -b, -c, -d)

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

#=
"""
    three_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))
"""
function three_diff(a::T,b::T,c::T) where {T}
    a, b, c = magnitude_maxtomin(a, b, c)
    s, t = two_diff(-b, c)
    x, u = two_sum(a, s)
    y, z = two_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    ieee_three_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
- Handles `Inf` properly
"""
function three_diff(a::T,b::T,c::T) where {T}
    a, b, c = magnitude_maxtomin(a, b, c)
    s, t = two_diff(-b, c)
    x, u = two_sum(a, s)
    isinf(x) && return(x, zero(T), zero(T))
    y, z = two_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end
=#

#=
"""
    four_diff(a, b, c, d)
    
Computes `s = fl(a-b-c-d)` and `e1 = err(a-b-c-d), e2 = err(e1), e3 = err(e2)`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c) | isinf(d))
"""
four_diff(a::T, b::T, c::T, d::T) where {T} = four_sum(a, -b, -c, -d)
=#

"""
    ieee_four_diff(a, b, c, d)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
- Handles `Inf` properly
"""
ieee_four_diff(a::T, b::T, c::T, d::T) where {T} = ieee_four_sum(a, -b, -c, -d)

"""
    two_square(a)

Computes `hi = fl(a^2)` and `lo = fl(err(a^2))`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_square(a::T) where {T}
    hi = a * a
    lo = fma(a, a, -hi)
    hi, lo
end

"""
    two_prod(a, b)

Computes `hi = fl(a*b)` and `lo = fl(err(a*b))`.
- Unchecked Precondition: !(isinf(a) | isinf(b))
"""
@inline function two_prod(a::T, b::T) where {T}
    hi = a * b
    lo = fma(a, b, -hi)
    hi, lo
end

"""
    ieee_two_prod(a, b)

Computes `hi = fl(a*b)` and `lo = fl(err(a*b))`.
- Handles `Inf` properly
"""
@inline function ieee_two_prod(a::T, b::T) where {T}
    hi = a * b
    isinf(hi) && return (hi, zero(T))
    lo = fma(a, b, -hi)
    hi, lo
end

"""
    three_prod(a, b, c)


Computes `hi = fl(a*b*c)` `md = fl(a*b*c - hi)` and `lo = fl(err(md))`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c))

a,b,c = (3.141592653589793, 0.5641895835477563, 1.4142135623730951)
julia> three_prod3(a,b,c)
(2.5066282746310007, -1.4371699047167184e-16, -4.4346586356447294e-35)

julia> three_prod3(c,a,b)
(2.5066282746310007, -1.4371699047167186e-16, 2.4607556701800172e-32)
"""
function three_prod(a::T, b::T, c::T) where {T}
    a, b = maxmin(a,b)
    a, c = maxmin(a,c)
    b, c = maxmin(b,c)
    abhi, ablo = two_prod(a, b)
    hi, abhiclo = two_prod(abhi, c)
    ablochi, abloclo = two_prod(ablo, c)
    md, lo, tmp  = three_sum(ablochi, abhiclo, abloclo)
    hi, md = two_sum(hi, md)
    return hi, md, lo
end

@inline maxmin(a,b) = abs(a) < abs(b) ? (b,a) : (a,b)


"""
    ieee_three_prod(a, b)

Computes `hi = fl(a*b*c)` `md = fl(a*b*c - hi)` and `lo = fl(err(md))`.
- Handles `Inf` properly
"""
function ieee_three_prod(a::T, b::T, c::T) where {T}
    a, b = maxmin(a,b)
    a, c = maxmin(a,c)
    b, c = maxmin(b,c)
    abhi, ablo = two_prod(a, b)
    hi, abhiclo = two_prod(abhi, c)
    isinf(hi) && return (hi, zero(T), zero(T))
    ablochi, abloclo = two_prod(ablo, c)
    md, lo, tmp  = three_sum(ablochi, abhiclo, abloclo)
    hi, md = two_sum(hi, md)
    return hi, md, lo
end

"""
    four_prod(a, b, c, d)
????????????

Computes `hi = fl(a*b*c*d)` `mdhi = fl(a*b*c*d - hi)`  `mdlo = fl(a*b*c*d - hi - mdhi)` and `lo = fl(err(mdlo))`.
- Unchecked Precondition: !(isinf(a) | isinf(b) | isinf(c) | isinf(d))
"""
function four_prod(a::T, b::T, c::T, d::T) where {T}
    abchi, abcmd, abclo = three_prod(a, b, c)
    abchidhi, abchidlo = two_prod(abchi, d)
    abcmddhi, abcmddlo = two_prod(abcmd, d)
    abclodhi, abclodlo = two_prod(abclo, d)
    abcmddhi, abcmddlo, abclodhi = three_sum(abcmddhi, abcmddlo, abclodhi)
    abchidlo, abcmddhi, abcmddlo = three_sum(abchidlo, abcmddhi, abcmddlo)
    abcmddlo += abclodhi + abclodlo
    abchidhi, abchidlo, abcmddhi = three_sum(abchidhi, abchidlo, abcmddhi)
    return abchidhi, abchidlo, abcmddhi, abcmddlo
end
    
"""
    ieee_four_prod(a, b, c, d)

Computes `hi = fl(a*b*c*d)` `mdhi = fl(a*b*c*d - hi)`  `mdlo = fl(a*b*c*d - hi - mdhi)` and `lo = fl(err(mdlo))`.
- Handles `Inf` properly
"""
function ieee_four_prod(a::T, b::T, c::T, d::T) where {T}
    abchi, abcmd, abclo = three_prod(a, b, c)
    abchidhi, abchidlo = two_prod(abchi, d)
    isinf(abchidhi) && return (abchidhi, zero(T), zero(T), zero(T))
    abcmddhi, abcmddlo = two_prod(abcmd, d)
    abclodhi, abclodlo = two_prod(abclo, d)
    abcmddhi, abcmddlo, abclodhi = three_sum(abcmddhi, abcmddlo, abclodhi)
    abchidlo, abcmddhi, abcmddlo = three_sum(abchidlo, abcmddhi, abcmddlo)
    abcmddlo += abclodhi + abclodlo
    abchidhi, abchidlo, abcmddhi = three_sum(abchidhi, abchidlo, abcmddhi)
    return abchidhi, abchidlo, abcmddhi, abcmddlo
end

function three_fma(a::T, b::T, c::T) where {T<:Real}
    x = fma(a,b,c)
    u1, u2 = two_prod(a,b)
    a1, z  = two_sum(c, u2)
    b1, b2 = two_sum(u1, a1)
    y = (b1 - x) + b2
    y,z = two_hilo_sum(y,z)
    return (x,y,z)
end
#=
function four_sum(a::T, b::T, c::T, d::T) where {T}
    hm, ml, lo = three_sum(b, c, d)
    hi, hm, ml = three_sum(a, hm, ml) 
    hm, ml, lo = three_sum(hm, ml, lo)
    hi, hm, ml = three_hilo_sum(hi, hm, ml)
    return hi, hm, ml, lo
end

"""
    five_sum(a, b, c, d, e)
    
Computes `hi = fl(a+b+c+d+e)` and `mdhi = err(a+b+c+d), mdmd = err(mdhi),  mdlo = err(mdmd), lo = err(mdlo)`.
"""
function five_sum(a::T, b::T, c::T, d::T, e::T) where {T}
    mdhi, mdmd, mdlo, lo = four_sum(b, c, d, e)
    hi, mdhi, mdmd, mdlo = four_sum(a, mdhi, mdmd, lo) 
    mdhi, mdmd, mdlo, lo = four_sum(mdhhi, mdmd, mdlo, lo)
    hi, mdhi, mdmd, mdlo = four_hilo_sum(hi, mdhi, mdmd, mdlo) 
    return hi, mdhi, mdmd, mdlo, lo
end

"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `md = err(a+b+c)`.
"""
function two_sum(a::T, b::T, c::T) where {T}
    md, lo = two_sum(b, c) 
    hi, md = two_sum(a, md)
    md  += lo
    hi, md = two_hilo_sum(hi, md)
    return hi, md
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d)`.
"""
function two_sum(a::T, b::T, c::T, d::T) where {T}
    hm, ml, lo = three_sum(b, c, d)
    hi, hm, ml = three_sum(a, hm, ml)
    hm, ml = two_sum(hm, ml, lo)
    hm += ml
    hi, hm = two_hilo_sum(hi, hm)
    return hi, hm
end

"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(md)`.
"""
function three_sum(a::T, b::T, c::T, d::T) where {T}
    hm, ml, lo = three_sum(b, c, d)
    hi, hm, ml = three_sum(a, hm, ml) 
    hm, ml = two_sum(hm, ml, lo)
    hi, hm, ml = three_hilo_sum(hi, hm, ml)
    return hi, hm, ml
end

"""
    four_sum(a, b, c, d, e)
    
Computes `hi = fl(a+b+c+d+e)` and `mdhi = err(a+b+c+d), mdmd = err(mdhi),  mdlo = err(mdmd)`.
"""
function four_sum(a::T, b::T, c::T, d::T, e::T) where {T}
    mdhi, mdmd, mdlo, lo = four_sum(b, c, d, e)
    hi, mdhi, mdmd, mdlo = four_sum(a, mdhi, mdmd, lo) 
    mdhi, mdmd, mdlo = three_hilo_sum(mdhhi, mdmd, mdlo, lo)
    hi, mdhi, mdmd, mdlo = four_hilo_sum(hi, mdhi, mdmd, mdlo) 
    return hi, mdhi, mdmd, mdlo
end

#=
function two_sum(a::T,b::T,c::T) where {T}
    t1 = a + b
    v  = t1 - a
    
    lo = (a - (t1 - v)) + (b - v)
    hi = t1 + c
    
    v  = hi - t1
    t3 = (t1 - (hi - v)) + (c - v)
    lo += t3
    
    return hi, lo
end
=#

"""
    four_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `hm = err(a+b+c+d), ml = err(hm), lo = err(ml)`.
"""
#=
@inline function four_sum(x1::T, x2::T, x3::T, x4::T) where {T}
    a,b,c,d = maxtomin(x1,x2,x3,x4)
    a1, a2 = two_hilo_sum(a, b)
    b1, b2 = two_hilo_sum(c, d)
    c1, c2 = two_hilo_sum(a1, b1)
    d1, d2 = two_hilo_sum(a2, b2)
    return fast_vecsum_errbranch(c1,c2,d1,d2)
end
=#
#=
function four_sum(a::T,b::T,c::T,d::T) where {T}
    a,b,c,d = maxtomin(a,b,c,d)
    t0, t1 = two_sum(a ,  b)
    t0, t2 = two_sum(t0,  c)
    hi, t3 = two_sum(t0,  d)
    t0, t1 = two_sum(t1, t2)
    hm, t2 = two_sum(t0, t3) # here, t0 >= t3
    ml, lo = two_sum(t1, t2)
    return hi, hm, ml, lo

end
=#

@inline function vecsum(x1, x2)
    return two_sum(x1, x2)
end

@inline function vecsum(x1, x2, x3)
    s2, s3 = two_sum(x2, x3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3
end

@inline function vecsum(x1, x2, x3, x4)
    s3, s4 = two_sum(x3, x4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3, s4
end

function vecsum(x1, x2, x3, x4, x5)
    s4, s5 = two_sum(x4, x5)
    s3, s4 = two_sum(x3, s4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3, s4, s5
end

function vecsum(x1, x2, x3, x4, x5, x6)
    s5, s6 = two_sum(x5, x6)
    s4, s5 = two_sum(x4, s5)
    s3, s4 = two_sum(x3, s4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3, s4, s5, s6
end

function vecsum(x1, x2, x3, x4, x5, x6, x7)
    s6, s7 = two_sum(x6, x7)
    s5, s6 = two_sum(x5, s6)
    s4, s5 = two_sum(x4, s5)
    s3, s4 = two_sum(x3, s4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3, s4, s5, s6, s7
end

function vecsum(x1, x2, x3, x4, x5, x6, x7, x8)
    s7, s8 = two_sum(x7, x8)
    s6, s7 = two_sum(x6, s7)
    s5, s6 = two_sum(x5, s6)
    s4, s5 = two_sum(x4, s5)
    s3, s4 = two_sum(x3, s4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3, s4, s5, s6, s7, s8
end

@inline function vec_hilo_sum(x1, x2, x3)
    s2, s3 = two_sum(x2, x3)
    s1, s2 = two_hilo_sum(x1, s2)
    return s1, s2, s3
end

@inline function vec_hilo_sum(x1, x2, x3, x4)
    s3, s4 = two_sum(x3, x4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_hilo_sum(x1, s2)
    return s1, s2, s3, s4
end


function vecsum_hilo(x1, x2, x3)
    s2, s3 = two_sum(x2, x3)
    s1, s2 = two_sum(x1, s2)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    return s1, s2, s3
end

function vecsum_hilo(x1, x2, x3, x4)
    s3, s4 = two_sum(x3, x4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    return s1, s2, s3, s4
end


function vecsum_hilo(x1, x2, x3, x4)
    s1, s2, s3, s4 = vecsum(x1, x2, x3, x4)
    s1, s2, s3, s4 = vec_hilo_sum(s1, s2, s3, s4)
    return vec_hilo_sum(s1, s2, s3, s4)
end


@inline function vecsum(x1, x2, x3, x4, x5)
    s4, s5 = two_sum(x4, x5)
    s3, s4 = two_sum(x3, s4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    return s1, s2, s3, s4, s5
end

function vecsum2(x1, x2, x3)
    s2, s3 = two_sum(x2, x3)
    s1, s2 = two_sum(x1, s2)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    return s1, s2, s3
end

function vecsum3(x1, x2, x3)
    s2, s3 = two_sum(x2, x3)
    s1, s2 = two_sum(x1, s2)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    s2, s3 = two_hilo_sum(s2, s3)
    s1, s2 = two_hilo_sum(s1, s2)
    return s1, s2, s3
end

function vecsum2(x1, x2, x3, x4)
    s3, s4 = two_sum(x3, x4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(a1, s2)
    return s1, s2, s3, s4
end

function vecsum3(x1, x2, x3, x4)
    s3, s4 = two_sum(x3, x4)
    s2, s3 = two_sum(x2, s3)
    s1, s2 = two_sum(x1, s2)
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(a1, s2)
    s3, s4 = two_sum(s3, s4)
    s2, s3 = two_sum(s2, s3)
    s1, s2 = two_hilo_sum(a1, s2)
    return s1, s2, s3, s4
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
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `md = err(a+b+c+d), lo = err(md)`.
"""
function three_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a ,  b)
    t0, t2 = two_sum(t0,  c)
    hi, t3 = two_sum(t0,  d)
    t0, t1 = two_sum(t1, t2)
    hm, t2 = two_sum(t0, t3) # here, t0 >= t3
    ml     = t1 + t2
    return hi, hm, ml
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_sum(a::T,b::T,c::T,d::T) where {T}
    t0, t1 = two_sum(a ,  b)
    t0, t2 = two_sum(t0,  c)
    hi, t3 = two_sum(t0,  d)
    t0, t1 = two_sum(t1, t2)
    lo     = t0 + t3
    return hi, lo
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
    a1 = hi + b
    b1 = hi - a1
    lo = (a - a1) - (b + b1)
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

"""
    three_prod(a, b, c)
    
Computes `hi = fl(a*b*c)` and `md = err(a*b*c), lo = err(md)`.
"""
function three_prod(a::T, b::T, c::T) where {T}
    abhi, ablo = two_prod(a, b)
    hi, abhiclo = two_prod(abhi, c)
    ablochi, abloclo = two_prod(ablo, c)
    md, lo, tmp  = three_sum(ablochi, abhiclo, abloclo)
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
     dhi = hi2 - hi
     lo3 = lo1 + lo2
     lo = dhi + lo3
     return hi, lo
end

"""
   two_muladd(a, b, c)

Computes `hi = fl(muladd(a,b,c))` and `lo = fl(err(muladd(a,b,c)))`.
"""
function two_muladd(a::T, b::T, c::T) where {T}
     hi = fma(a, b, c)
     c_minus_hi = c - hi
     lo = muladd(a, b, c_minus_hi)
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
    three_hilo_sum(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `x = fl(a+b+c)` and `y = err(a+b+c), z = err(y)`.
"""
function three_hilo_sum(a::T,b::T,c::T) where {T}
    s, t = two_hilo_sum(b, c)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_lohi_sum(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `x = fl(a+b+c)` and `y = err(a+b+c), z = err(y)`.
"""
function three_lohi_sum(a::T,b::T,c::T) where {T}
    s, t = two_hilo_sum(b, a)
    x, u = two_hilo_sum(c, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_hilo_sum(a, b, c, d)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c| ≥ |d|`

Computes `x = fl(a+b+c+d)` and `y = err(a+b+c+d), z = err(y)`.
"""
function three_hilo_sum(a::T, b::T, c::T, d::T) where {T}
    y, z, lo = three_hilo_sum(b, c, d)
    x, y, z  = three_hilo_sum(a, y, z)
    y, z, lo = three_hilo_sum(y, z, lo)
    x, y, z  = three_hilo_sum(x, y, z)
    return x, y, z
end

"""
    three_lohi_sum(a, b, c, d)
    
*unchecked* requirement `|d| ≥ |c| ≥ |b| ≥ |a|`

Computes `x = fl(a+b+c+d)` and `y = err(a+b+c+d), z = err(y)`.
"""
function three_lohi_sum(a::T, b::T, c::T, d::T) where {T}
    y, z, lo = three_lohi_sum(b, c, d)
    x, y, z  = three_lohi_sum(a, y, z)
    y, z, lo = three_lohi_sum(y, z, lo)
    x, y, z  = three_lohi_sum(x, y, z)
    return x, y, z
end

"""
    three_hilo_diff(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `x = fl(a-b-c)` and `y = err(a-b-c), z = err(y)`.
"""
function three_hilo_diff(a::T,b::T,c::T) where {T}
    s, t = two_hilo_diff(b, -c)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_lohi_diff(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `x = fl(a-b-c)` and `y = err(a-b-c), z = err(y)`.
"""
function three_lohi_diff(c::T,b::T,a::T) where {T}
    s, t = two_hilo_diff(b, -c)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
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

function four_hilo_sum2(a::T, b::T, c::T, d::T) where {T}
    hm, ml, lo = three_hilo_sum(b, c, d)
    hi, hm, ml = three_hilo_sum(a, hm, ml) 
    hm, ml, lo = three_hilo_sum(hm, ml, lo)
    hi, hm, ml = three_hilo_sum(hi, hm, ml)
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


#=
A note on Dekker’s FastTwoSum algorithm
by Marko Lange and Shin’ichi Oishi
Numerische Mathematik
https://doi.org/10.1007/s00211-020-01114-2
Received: 13 December 2017 / Revised: 16 March 2020
© Springer-Verlag GmbH Germany, part of Springer Nature 2020
=#

function threeprod(x1::T, x2::T, x3::T) where {T}
   s1, s2, s3, s4 = four_sum_three_product(x1, x2, x3)
   s2, s3 = two_hilo_sum(s2, s3)
   s3 += s4
   return s1, s2, s3
end
    
function four_sum_three_product(x1::T, x2::T, x3::T) where {T}
    thi, tlo = two_prod(x2, x3)
    s1, s2 = two_prod(x1, thi)
    s3, s4 = two_prod(x1, tlo)
    return s1, s2, s3, s4
end

function twosum(p1,p2,p3)
    e = 0
    s = p1
    x = p2 + s
    z = x - p2
    y = (p2-(x-z)) + (x-z)
    e = e + y
    s = x
    x = p3 + s
    z = x - p3
    y = (p3 - (x-z)) + (x-z)
    e = e + y
    s = x
    return s, e
 end

function twosum(p1,p2,p3,p4)
    e = 0
    s = p1
    x = p2 + s
    z = x - p2
    y = (p2-(x-z)) + (x-z)
    e = e + y
    s = x
    x = p3 + s
    z = x - p3
    y = (p3 - (x-z)) + (x-z)
    e = e + y
    s = x
    x = p4 + s
    z = x - p4
    y = (p4 - (x-z)) + (x-z)
    e = e + y
    s = x
    return s, e
 end

    
    
=#
