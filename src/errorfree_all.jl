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


