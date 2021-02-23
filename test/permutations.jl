using Random
using Combinatorics

floatrng = MersenneTwister(1618);
scalerng = MersenneTwister(141421);
boolrng  = MersenneTwister(6180);

const permute1 = Tuple(Tuple.(permutations((1,))))        # n=   1
const permute2 = Tuple(Tuple.(permutations((1,2))))       # n=   2
const permute3 = Tuple(Tuple.(permutations((1,2,3))))     # n=   6
const permute4 = Tuple(Tuple.(permutations((1,2,3,4))))   # n=  24
const permute5 = Tuple(Tuple.(permutations((1,2,3,4,5)))) # n= 120
const permuted = (permute1, permute2, permute3, permute4, permute5)

function parts2(::Type{T}, x::BigFloat) where {T}
    hi = T(x)
    lo = T(x - hi)
    return hi, lo
end

function parts3(::Type{T}, x::BigFloat) where {T}
    hi = T(x)
    md = T(x - hi)
    lo = T(x - hi - md)
    return hi, md, lo
end

function parts4(::Type{T}, x::BigFloat) where {T}
    hi = T(x)
    hm = T(x - hi)
    lm = T(x - hi - hm)
    lo = T(x - hi - hm - lm)
    return hi, hm, lm, lo
end

function parts5(::Type{T}, x::BigFloat) where {T}
    hi = T(x)
    hm = T(x - hi)
    md = T(x - hi - hm)
    lm = T(x - hi - hm - md)
    lo = T(x - hi - hm - md - lm)
    return hi, hm, md, lm, lo
end

# x -> x * 2^shift
function shift_exp(x::T, shift::Int) where {T<:AbstractFloat}
  fr, xp = frexp(x)
  xp += shift 
  ldexp(fr, xp)
end

#=
    generate random value for shift in `shift_exp`
    
    s = scaledown,  ± is relative to -128:128
           s  |   ±
    ----------|----------
         0    |   ±128   
         1    |   ±64   
         2    |   ±32   
         3    |   ±16   
         4    |   ±8   
         5    |   ±4   
         6    |   ±2   
         7    |   ±1   
         8    |   -1, +0   
    
=#

function shift_exp_updown_by(scalemax=0, scalemin=0)
   rand(boolrng, false:true) ? 
       rand(scalemin:scalemax) : rand(-scalemax:-scalemin)   
end
function shift_exp_up_by(scalemax=0, scalemin=0)
   rand(scalemin:scalemax)
end
function shift_exp_down_by(scalemax=0, scalemin=0)
   rand(-scalemax:-scalemin)
end

@inline randsign() = rand(-1,2,1)
@inline randsign(x) = rand(false:true) ? x : -x

function randfloat(scalemax=60, scalemin=0)
    fl = randsign(rand(floatrng))
    xp  = shift_exp_updown_by(scalemax, scalemin)
    fl  = shift_exp(fl, xp)
    return fl
end

