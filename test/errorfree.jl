# 512. (sigbits + extrabits) * (4 + 1) [4+1 from renormalize(a,b,c,d,e)]
const BigFloatOldPrec = precision(BigFloat)
const BigFloatPrec = nextpow(2, ((Base.significand_bits(Float64) + 1 + 36) * 5)) 
setprecision(BigFloat, BigFloatPrec)

function correct_two_sum(aa::T, bb::T) where {T}
    aa, bb = sort([aa,bb,cc], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    s = a + b
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_two_sum(aa::T, bb::T, cc::T) where {T}
    aa, bb, cc = sort([aa,bb,cc], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    s = a + b + c
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_two_sum(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    d = BigFloat(dd)
    s = a + b + c + d
    hi = T(s)
    lo = T(s - hi)
    return hi, lo
end

function correct_three_sum(aa::T, bb::T, cc::T) where {T}
    aa, bb, cc = sort([aa,bb,cc], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    s = a + b + c
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_three_sum(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    d = BigFloat(dd)
    s = a + b + c + d
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_three_sum(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    aa, bb, cc, dd, mm = sort([aa,bb,cc,dd,mm], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    d = BigFloat(dd)
    m = BigFloat(mm)
    s = a + b + c + d + m
    hi = T(s)
    md = T(s - hi)
    lo = T(s - hi - md)
    return hi, md, lo
end

function correct_four_sum(aa::T, bb::T, cc::T, dd:T) where {T}
    aa, bb, cc, dd = sort([aa,bb,cc,dd], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    d = BigFloat(dd)
    s = a + b + c + d
    hi = T(s)
    mdhi = T(s - hi)
    mdlo = T(s - hi - mdhi)
    lo = T(s - hi - mdhi - mdlo)
    return hi, mdhi, mdlo, lo
end

function correct_four_sum(aa::T, bb::T, cc::T, dd:T, mm::T) where {T}
    aa, bb, cc, dd, mm = sort([aa,bb,cc,dd,mm], lt=!isless)
    a = BigFloat(aa)
    b = BigFloat(bb)
    c = BigFloat(cc)
    d = BigFloat(dd)
    m = BigFloat(mm)
    s = a + b + c + d + m
    hi = T(s)
    mdhi = T(s - hi)
    mdlo = T(s - hi - mdhi)
    lo = T(s - hi - mdhi - mdlo)
    return hi, mdhi, mdlo, lo
end
