# generate random 2,3,4-tuples designed to exercise error-free transformations
    
fullseparation(::Type{T}) where {T} =  Base.significand_bits(T) + 3
bitoverlap(::Type{T}, nbits) where {T} = fullseparation(T) - nbits

function tworands(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:5))
    loshift = hishift - separation
    hi = rand(T) * 2.0^hishift
    lo = rand(T) * 2.0^loshift
    return hi, lo
end

function tworandsoverlap(::Type{T}, overlap) where {T}
    return tworands(T, bitoverlap(T, overlap))
end
