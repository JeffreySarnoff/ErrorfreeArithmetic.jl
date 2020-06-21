# generate random 2,3,4-tuples designed to exercise error-free transformations
    
fullseparation(::Type{T}) where {T} =  Base.significand_bits(T) + 2

function tworands(::Type{T}, separation::Int=fullseparation(T)) where {T}
    hishift = fld(separation, rand(1:5))
    loshift = hishift - separation
    hi = rand(T) * 2.0^hishift
    lo = rand(T) * 2.0^loshift
    return hi, lo
end

