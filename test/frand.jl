#=
    random floating point values for testing
=#

using Random
using Random: Xoshiro

rng = Xoshiro(618034)

randsign() = rand(rng, (-1,1))
randsign(n=1) = rand(rng, (-1,1), n)

randexp(; range=0:63) = rand(rng, range)
randexp(n=1; range=0:63) = rand(rng, range, n)

randexp() = randexp(Float64)
randexp(::Type{T}; shift=Base.exponent_bits(T)>>4) where {T<:AbstractFloat} = rand(rng, (1+exponent(floatmin(T))):(1+exponent(floatmax(T)))) >> shift

frand() = frand(Float64)
frand(::Type{T}) where {T<:AbstractFloat} = ldexp(rand(T), randexp())
