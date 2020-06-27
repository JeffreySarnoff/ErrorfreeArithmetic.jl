@inline min_max(x,y) = ifelse(abs(x) < abs(y), (x,y) , (y,x))
@inline max_min(x,y) = ifelse(abs(y) < abs(x), (x,y) , (y,x))

function mintomax(a::T, b::T, c::T, d::T) where {T}
    a, b = min_max(a, b)
    c, d = min_max(c, d)
    a, c = min_max(a, c)
    b, d = min_max(b, d)
    b, c = min_max(b, c)
    return a, b, c, d
end

function maxtomin(a::T, b::T, c::T, d::T) where {T}
    a, b = max_min(a, b)
    c, d = max_min(c, d)
    a, c = max_min(a, c)
    b, d = max_min(b, d)
    b, c = max_min(b, c)
    return a, b, c, d
end

function normalize(a::T, b::T, c::T, d::T) where {T}
    a, b, c, d = mintomax(a, b, c, d)
    t = v = zeros(T, 4)
    s, t[4] = two_hilo_sum(a, b)
    s, t[3] = two_hilo_sum(c, s)
    t[1], t[2] = two_hilo_sum(d, s)
    k = 1
    for i=1:4
        s, e = two_hilo_sum(s, t[i])
        if !iszero(e)
            v[k] = s
            s = e
            k += 1
        end
    end    
    return (v...,)    
end

function vec_sum(x0::T, x1::T, x2::T, x3::T) where {T}
    s3 = x3
    s2, e3 = two_sum(x2, s3)
    s1, e2 = two_sum(x1, s2)
    s0, e1 = two_sum(x0, s1)
    return s0,e1,e2,e3
end

function vecsum_errbranch(x::NTuple{4,T}) where {T}
    y = r = e = zeros(T, 4)
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

function fast_vecsum_errbranch(x::NTuple{4,T}) where {T}
    y = zeros(T, 4)
    j = 1
    # e[1] = x1
    # i = 1
    r, t = two_sum(x[1], x[2])
    if t !== zero(T)
       y[j] = r
       e = t
       j += 1
    else
       e = r
    end
    # i = 2
    r, t = two_sum(e, x[3])
    if t !== zero(T)
       y[j] = r
       e = t
       j += 1
    else
       e = r
    end

    y[j], y[j+1] = two_sum(e, x[4])
    return y
end


function fast_vecsum_errbranch(x1::T,x2::T,x3::T,x4::T) where {T}
    y = zeros(T, 4)
    j = 1
    # e[1] = x1
    # i = 1
    r, t = two_sum(x1, x2)
    if t !== zero(T)
       y[j] = r
       e = t
       j += 1
    else
       e = r
    end
    # i = 2
    r, t = two_sum(e, x3)
    if t !== zero(T)
       y[j] = r
       e = t
       j += 1
    else
       e = r
    end

    y[j], y[j+1] = two_sum(e, x4)
    return y
end

function quadword(x1::T, x2::T, x3::T, x4::T) where {T}
    a1, a2 = two_sum(x1, x2)
    b1, b2 = two_sum(x3, x4)
    c1, c2 = two_sum(a1, b1)
    d1, d2 = two_sum(a2, b2)
    e1to4 = vec_sum(c1,c2,d1,d2)
    y = vecsum_errbranch(e1to4)
    return (y...,)
end

@inline function fast_quadword(x1::T, x2::T, x3::T, x4::T) where {T}
    a,b,c,d = maxtomin(x1,x2,x3,x4)
    a1, a2 = two_hilo_sum(a, b)
    b1, b2 = two_hilo_sum(c, d)
    c1, c2 = two_hilo_sum(a1, b1)
    d1, d2 = two_hilo_sum(a2, b2)
    return fast_vecsum_errbranch(c1,c2,d1,d2)
end


function tst4(n,x)
  for i=1:n
      h0,a0,b0,l0 = fourrands_hi2lo(x)
      h,a,b,l = quadword(h0,a0,b0,l0); hi,hm,lm,lo=fast_quadword(l,h,b,a)
      if (h,a,b,l) != (hi,hm,lm,lo)
         error("($h0,$a0,$b0,$l0): $h, $a, $b, $l != $hi, $hm, $lm, $lo")
      end
   end
 end

#=
Fast Quadruple Precision Arithmetic Library on Parallel Computer SR11000/J2
Takahiro Nagai, Hitoshi Yoshida, Hisayasu Kuroda, and Yasumasa Kanada
M. Bubak et al. (Eds.): ICCS 2008, Part I, LNCS 5101, pp. 446–455, 2008.
(c) Springer-Verlag Berlin Heidelberg 2008
=#

function two_sum_sr(ahi::T, alo::T, bhi::T, blo::T) where {T}
    t, r = two_sum(ahi, bhi)
    e = r + alo + blo
    hi = t + e
    lo = t - hi + e
    return hi, lo
end

function two_diff_sr(ahi::T, alo::T, bhi::T, blo::T) where {T}
    t, r = two_diff(ahi, bhi)
    e = r + alo - blo
    hi = t + e
    lo = t - hi + e
    return hi, lo
end
    
function two_prod_sr(ahi::T, alo::T, bhi::T, blo::T) where {T}
    r  = ahi * blo
    t  = fma(alo, bhi, r)
    hi = fma(ahi, bhi, t)
    r  = fma(ahi, bhi, -hi)
    lo = t + r
    return hi, lo
end

function two_divide_sr(ahi::T, alo::T, bhi::T, blo::T) where {T}
     d1 = inv(bhi)
     m1 = ahi * d1
     e1 = -fma(bhi, m1, -ahi)
     m1 = fma(d1, e1, m1)
     m2 = -fma(bhi, m1, ahi)
     m2 += alo
     m2 = -fma(blo, m1, -m2)
     m3 = d1 * m2
     m2 = -fma(bhi, m3, -m2)
     m2 = fma(d1, m2, m3)
     hi = m1 + m2
     e2 = m1 - hi
     lo = m2 + e2
     return hi, lo
end

#=
Quadruple-precision BLAS using Bailey’s arithmetic with FMA instruction
Susumu YAMADA, Toshiyuki IMAMURA, Takuya Ina, Yasuhiro IDOMURA, Narimasa SASA, Masahiko MACHIDA
iWAPT 2017
=#

function two_sum_ba(ahi::T, alo::T, bhi::T, blo::T) where {T}
    p1 = ahi + alo # p1 == ahi
    p2 = p1 - ahi  # p2 == 0.0
    1o = (ahi - (p1 - p2)) + (bhi - p2)
    hi = p1
    lo = lo + alo + blo
    s1 = hi + lo
    lo = lo - (s1 - hi)
    hi = s1
    return hi, lo
end

function two_sum_ba(ahi::T, alo::T, bhi::T, blo::T) where {T}
    #p1 = ahi + alo # p1 == ahi
    #p2 = p1 - ahi  # p2 == 0.0
    #lo = (ahi - (ahi - 0.0)) + (bhi - 0.0)
    lo = bhi
    hi = ahi
    lo = lo + alo + blo
    s1 = hi + lo
    lo = lo - (s1 - hi)
    hi = s1
    return hi, lo
end
    
function two_prod_ba(ahi::T, alo::T, bhi::T, blo::T) where {T}
    p1 = ahi * bhi
    p2 = fma(ahi, bhi, -p1)
    # p2 = p2 + (alo * bhi) + (ahi * blo)
    p2 = fma(alo, bhi, p2) + (ahi * blo)
    hi = p1 + p2
    lo = p2 - (hi - p1)
    return hi, lo
end
    
