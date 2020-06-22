# 512. (sigbits + extrabits) * (4 + 1) [4+1 from renormalize(a,b,c,d,e)]
const BigFloatOldPrec = precision(BigFloat)
const BigFloatPrec = nextpow(2, ((Base.significand_bits(Float64) + 1 + 36) * 5)) 
setprecision(BigFloat, BigFloatPrec)

# select one of these two approaches
# bigfloat(x) = BigFloat(string(x))
bigfloat(x) = BigFloat(x)


greatermagnitude(x,y) = abs(y) < abs(x) ? (x, y) : (y, x)

# error-free sums

function correct_two_sum(aa::T, bb::T) where {T}
    aa, bb = sort([aa,bb,cc], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    s = a + b
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_two_sum(aa::T, bb::T, cc::T) where {T}
    aa, bb, cc = sort([aa,bb,cc], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    s = a + b + c
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_two_sum(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    s = a + b + c + d
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_three_sum(aa::T, bb::T, cc::T) where {T}
    aa, bb, cc = sort([aa,bb,cc], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    s = a + b + c
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_three_sum(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    s = a + b + c + d
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_three_sum(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    aa, bb, cc, dd, mm = sort([aa,bb,cc,dd,mm], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    m = bigfloat(mm)
    s = a + b + c + d + m
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_four_sum(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    s = a + b + c + d
    hi = T(s)
    mdhi = T(s - hi)
    mdlo = T(s - hi - mdhi)
    lo = T(s - hi - mdhi - mdlo)
    return hi, mdhi, mdlo, lo
end

function correct_four_sum(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    aa, bb, cc, dd, mm = sort([aa,bb,cc,dd,mm], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    m = bigfloat(mm)
    s = a + b + c + d + m
    hi = T(s)
    mdhi = T(s - hi)
    mdlo = T(s - hi - mdhi)
    lo = T(s - hi - mdhi - mdlo)
    return hi, mdhi, mdlo, lo
end

# error-free diffs

function correct_two_diff(aa::T, bb::T) where {T}
    bb = -bb
    return correct_two_sum(aa, bb)
end

function correct_two_diff(aa::T, bb::T, cc::T) where {T}
    bb, cc = -bb, -cc
    return correct_two_sum(aa, bb, cc)
end

function correct_two_diff(aa::T, bb::T, cc::T, dd:T) where {T}
    bb, cc, dd = -bb, -cc, -dd
    return correct_two_sum(aa, bb, cc, dd)
end

function correct_three_diff(aa::T, bb::T, cc::T) where {T}
    bb, cc = -bb, -cc
    return correct_three_sum(aa, bb, cc)
end

function correct_three_diff(aa::T, bb::T, cc::T, dd:T) where {T}
    bb, cc, dd = -bb, -cc, -dd
    return correct_three_sum(aa, bb, cc, dd)
end

function correct_three_diff(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    bb, cc, dd, mm = -bb, -cc, -dd, -mm
    return correct_four_sum(aa, bb, cc, dd, mm)
end

function correct_four_diff(aa::T, bb::T, cc::T, dd:T) where {T}
    bb, cc, dd = -bb, -cc, -dd
    return correct_four_sum(aa, bb, cc, dd)
end

function correct_four_diff(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    bb, cc, dd, mm = -bb, -cc, -dd, -mm
    return correct_four_sum(aa, bb, cc, dd, mm)
end

# error-free products

function correct_two_prod(aa::T, bb::T) where {T}
    aa, bb = sort([aa,bb,cc], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    s = a * b
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_two_prd(aa::T, bb::T, cc::T) where {T}
    aa, bb, cc = sort([aa,bb,cc], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    s = a * b * c
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_two_prod(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    s = a * b * c * d
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_three_prod(aa::T, bb::T, cc::T) where {T}
    aa, bb, cc = sort([aa,bb,cc], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    s = a * b * c
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_three_prod(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    s = a * b * c * d
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_three_prod(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    aa, bb, cc, dd, mm = sort([aa,bb,cc,dd,mm], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    m = bigfloat(mm)
    s = a * b * c * d * m
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_four_prod(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    s = a * b * c * d
    hi = T(s)
    mdhi = T(s - hi)
    mdlo = T(s - hi - mdhi)
    lo = T(s - hi - mdhi - mdlo)
    return hi, mdhi, mdlo, lo
end

function correct_four_prod(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    aa, bb, cc, dd, mm = sort([aa,bb,cc,dd,mm], lt=greatermagnitude)
    a = bigfloat(aa)
    b = bigfloat(bb)
    c = bigfloat(cc)
    d = bigfloat(dd)
    m = bigfloat(mm)
    s = a * b * c * d * m
    hi = T(s)
    mdhi = T(s - hi)
    mdlo = T(s - hi - mdhi)
    lo = T(s - hi - mdhi - mdlo)
    return hi, mdhi, mdlo, lo
end

