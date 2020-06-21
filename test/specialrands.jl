# generate random 2,3,4-tuples designed to exercise error-free transformations
    
fullseparation(::Type{T}) where {T} =  Base.significand_bits(T) + 3
bitoverlap(::Type{T}, nbits) where {T} = fullseparation(T) - nbits

# bitoverlap needs to be < 27 for threerands_hi2lo(Float64) to preclude lo == 0.0
# bitoverlap needs to be < 19 for fourrands_hi2lo(Float64)  to preclude lo == 0.0

function tworands_sep(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:fld(separation,3)))
    loshift = hishift - separation
    hi = rand(T) * 2.0^hishift
    lo = rand(T) * 2.0^loshift
    return hi, lo
end

function tworands_hilo(::Type{T}, overlap=0; shift=0) where {T}
    hi, lo = tworands_sep(T, bitoverlap(T, overlap))
    shift = 2.0^shift
    return hi*shift, lo*shift
end

tworands_hi2lo(overlap=0; shift=0) = tworands_hilo(Float64, overlap; shift=shift)

function threerands_sep(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:fld(separation,3)))
    mdshift = hishift - separation
    loshift = mdshift - separation
    hi = rand(T) * 2.0^hishift
    md = rand(T) * 2.0^mdshift
    lo = rand(T) * 2.0^loshift
    return hi, md, lo
end

function threerands_randsep(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:fld(separation,3)))
    mdshift = hishift - separation
    loshift = mdshift - rand(fld(separation,3):separation)
    hi = rand(T) * 2.0^hishift
    md = rand(T) * 2.0^mdshift
    lo = rand(T) * 2.0^loshift
    return hi, md, lo
end

function threerands_himdlo(::Type{T}, overlap=0; shift=0) where {T}
    hi, md, lo = threerands_sep(T, bitoverlap(T, overlap))
    shift = 2.0^shift
    return hi*shift, md*shift, lo*shift
end

function threerands_randhimdlo(::Type{T}, overlap=0; shift=0) where {T}
    hi, md, lo = threerands_randsep(T, bitoverlap(T, overlap))
    shift = 2.0^shift
    return hi*shift, md*shift, lo*shift
end

threerands_hi2lo(overlap=0; shift=0) = threerands_himdlo(Float64, overlap; shift=shift)
threerands_randhi2lo(overlap=0; shift=0) = threerands_randhimdlo(Float64, overlap; shift=shift)

function fourrands_sep(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:fld(separation,3)))
    hmshift = hishift - separation
    lmshift = hmshift - separation
    loshift = lmshift - separation
    hi = rand(T) * 2.0^hishift
    hm = rand(T) * 2.0^hmshift
    lm = rand(T) * 2.0^lmshift
    lo = rand(T) * 2.0^loshift
    return hi, hm, lm, lo
end

function fourrands_randsep(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:fld(separation,3)))
    hmshift = hishift - separation
    lmshift = hmshift - rand(fld(separation,3):separation)
    loshift = lmshift - rand(fld(separation,3):separation)
    hi = rand(T) * 2.0^hishift
    hm = rand(T) * 2.0^hmshift
    lm = rand(T) * 2.0^lmshift
    lo = rand(T) * 2.0^loshift
    return hi, hm, lm, lo
end

function fourrands_hihmlmlo(::Type{T}, overlap=0; shift=0) where {T}
    hi, hm, lm, lo = fourrands_sep(T, bitoverlap(T, overlap))
    shift = 2.0^shift
    return hi*shift, hm*shift, lm*shift, lo*shift
end

function fourrands_randhihmlmlo(::Type{T}, overlap=0; shift=0) where {T}
    hi, hm, lm, lo = fourrands_randsep(T, bitoverlap(T, overlap))
    shift = 2.0^shift
    return hi*shift, hm*shift, lm*shift, lo*shift
end

fourrands_hi2lo(overlap=0; shift=0) = fourrands_hihmlmlo(Float64, overlap; shift=shift)
fourrands_randhi2lo(overlap=0; shift=0) = fourrands_randhihmlmlo(Float64, overlap; shift=shift)
