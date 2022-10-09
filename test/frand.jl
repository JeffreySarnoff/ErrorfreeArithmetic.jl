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
randexp(::Type{T}) where {T<:AbstractFloat} = rand(rng, (1+exponent(floatmin(T))):(1+exponent(floatmax(T))))
randexp(sr::StepRange{I,I}) where {I<:Integer} = rand(rng, sr)

randexp(n::Int) = randexp(rng, Float64, n)
randexp(::Type{T}, n::Int) where {T<:AbstractFloat} = rand(rng, (1+exponent(floatmin(T))):(1+exponent(floatmax(T))), n)
randexp(sr::StepRange{I,I}, n::Int) where {I<:Integer} = rand(rng, sr, n)

frand() = rand(rng, Float64)
frand(::Type{T}) where {T<:AbstractFloat} = ldexp(rand(T), randexp())
frand(sr::StepRange{I,I}) where {T<:AbstractFloat, I<:Integer} = ldexp(rand(), randexp(sr))
frand(::Type{T}, sr::StepRange{I,I}) where {T<:AbstractFloat, I<:Integer} = ldexp(rand(T), randexp(sr))

frand(n::Int) = rand(rng, n)
frand(::Type{T}, n::Int) where {T<:AbstractFloat} = map(ldexp, rand(rng, T, n), randexp(T,n))
frand(sr::StepRange{I,I}, n::Int) where {T<:AbstractFloat, I<:Integer} = map(ldexp, rand(rng, n), randexp(sr, n))
frand(::Type{T}, sr::StepRange{I,I}, n::Int) where {T<:AbstractFloat, I<:Integer} = ldexp(rand(rng, T), randexp(sr))

