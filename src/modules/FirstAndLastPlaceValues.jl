module FirstAndLastPlaceValues

export ufp, ulp, uls, rre, ε⁻, ε⁺, eta, overlaps, overlapsby

#=
References
Accurate Floating-Point Summation Part I: Faithful Rounding
Siegfried M. Rump, Takeshi Ogita and Shin'ichi Oishi
http://oishi.info.waseda.ac.jp/~oishi/papers/RuOgOi07I.pdf

Fast quadruple-double floating point format
Naoya Yamanaka and Shin’ichi Oishi
2014-Jan-01

Error Estimation of Floating-Point Summation and Dot Product
Siegfried M. Rump

On the definition of ulp(x)
Jean-Michel Muller

Computing predecessor and successor in rounding to nearest
Siegfried Rump, Paul Zimmermann, Sylvie Boldo, Guillaume Melquiond

On various ways to split a floating-point number
Claude-Pierre Jeannerod, Jean-Michel Muller, Paul Zimmermann
=#

two(::Type{T}) where {T<:Real} = one(T) + one(T)
two(::Type{Float64}) = 2.0
two(::Type{Float32}) = 2.0f0
two(::Type{Float16}) = Float16(2.0)

#=
  Nicolas Fabiano, Jean-Michel Muller, Joris Picot.
  Algorithms for triple-word arithmetic.
  IEEE Transactions on Computers, Institute of Electrical and Electronics Engineers, 2019, 68 (11), pp.1573-1583.
  10.1109/TC.2019.2918451. hal-01869009v2
  
  Sylvie Boldo, Mioara Joldes, Jean-Michel Muller, Valentina Popescu.
  Formal Verification of a FloatingPoint Expansion Renormalization Algorithm.
  8th International Conference on Interactive Theorem Proving (ITP’2017), Sep 2017, Brasilia, Brazil. 
  hal-01512417f
  
  Accurate Floating-Point Summation Part I: Faithful Rounding
  Siegfried M. Rump, Takeshi Ogita, AND Shin'ichi Oishi
  in SIAM J. Sci. Comput. Volume 31, Issue 1, pp. 189-224 (2008)
=#

#=
  ufp(x)  unit in the first place
              the weight of the most significant bit
  ulp(x)  unit in the last place
              the weight of the least significant bit
  uls(x)  unit in the last significant place
              the weight of the rightmost nonzero bit
              the largest power of 2 that divides x
              the largest k s.t. x / 2^k is an integer
  
  reu(T)  roundoff error unit
             2^(-precision)
             ulp(1) / 2
             
  blp(x)  bit in the last place:              ulp(x) == 2.0^blp(x)
  bfp(x)  bit in the first place:             ufp(x) == 2.0^bfp(x)
  bls(x)  bit in the last significant place:  uls(x) == 2.0^bls(x)
=#
#=
julia> x = cbrt(17*pi)        #  3.765878158314341
julia> ufp(x),ulp(x),uls(x)   #  (2.0, 4.440892098500626e-16, 8.881784197001252e-16)
julia> bfp(x),blp(x),bls(x)   #  (1, -51, -50)
julia> x = 1/cbrt(17*pi)      #  0.26554231389355776
julia> ufp(x),ulp(x),uls(x)   #  (0.25, 5.551115123125783e-17, 4.440892098500626e-16)
julia> bfp(x),blp(x),bls(x)   #  (-2, -54, -51)
=#

#=
    The relative rounding error unit (reu) , 
    the distance from 1.0 to the next smaller floating-point number, is denoted by eps, and 
    the underflow unit by eta, that is the smallest positive (subnormal) floating-point number.
    
For IEEE 754 double precision we have eps = 2^(−53) and eta = 2^(−1074).
      The smallest positive normalized floating-point number is ets = (1/2)(eps^(-1))(eta) = (1/2)(2^(53-1074))
=#
#=
const BitPrecision = 1 + trailing_ones(Base.significand_mask(Float64))  # 53 = 1 implicit bit + 52 significand bits
const reu = 1.0 - prevfloat(1.0)  # 2.0^(-53)          # 1.0 - prevfloat(1.0)
const eta = nextfloat(0.0)        # 2.0^(-1074)        # smallest positive subnormal == nextfloat(0.0)
const ets = floatmin(Float64)     # 2.0^(53-1074) / 2  # smallest positive normal    == floatmin(Float64)
=#

explicit_precision(::Type{T}) where {T} = trailing_ones(Base.significand_mask(T))
implicit_precision(::Type{T}) where {T} = 1 + explicit_precision(T)

reu(::Type{T}) where {T} = one(T) - prevfloat(one(T))
eta(::Type{T}) where {T} = nextfloat(zero(T))
ets(::Type{T}) where {T} = floatmin(T)

ufp(x) = 2.0^floor(Int,log2(abs(x)))
ulp(x::T) where {T} = ufp(x) * 2.0^(-explicit_precision(T)+1)
uls(x) = ulp(x) * 2.0^(trailing_zeros(reinterpret(UInt64,x)))

bfp(x) = round(Int, log2(ufp(x)))
blp(x) = round(Int, log2(ulp(x)))
bls(x) = round(Int, log2(uls(x)))

# for x <= sqrt(floatmax(T)) !! bounds need testing
fast_ufp(x::Float64) = reinterpret(Float64, reinterpret(UInt64, x) & 0x7ff0000000000000)
fast_ufp(x::Float32) = reinterpret(Float32, reinterpret(UInt32, x) & 0x7ff0_0000)
fast_ufp(x::Float16) = reinterpret(Float16, reinterpret(UInt16, x) & 0x7ff0)

fast_ufp_signed(x::Float64) = reinterpret(Float64, reinterpret(UInt64, x) & 0xfff0000000000000)
fast_ufp_signed(x::Float32) = reinterpret(Float32, reinterpret(UInt32, x) & 0xfff0_0000)
fast_ufp_signed(x::Float16) = reinterpret(Float16, reinterpret(UInt16, x) & 0xfff0)

@inline is_pow2(x::Float64) = reinterpret(UInt64,x) & Base.significand_mask(Float64) === 0x0000000000000000
@inline is_pow2(x::Float32) = reinterpret(UInt32,x) & Base.significand_mask(Float32) === 0x00000000

const rre64 = ldexp(1.0,-52)        #  2.220446049250313e-16
const tworre64 = ldexp(1.0,-51)     #  4.440892098500626e-16
const halfrre64 = ldexp(1.0,-53)    #  
const neg_rre64 = -rre64
const neg_tworre64 = -tworre64
const neg_halfrre64 = -halfrre64

const rre32 = ldexp(1.0,-23)        #  1.1920929f-7
const tworre32 = ldexp(1.0,-22)     #  2.3841858f-7
const halfrre32 = ldexp(1.0,-24)    #  
const neg_rre32 = -rre32
const neg_tworre32 = -tworre32
const neg_halfrre32 = -halfrre32

const previnf   = prevfloat(Inf)
const previnfui = reinterpret(UInt64,previnf)

@inline cleaninf(c) = reinterpret(Float64, (reinterpret(UInt64,c) & previnfui))

# without special handling for subnormals
# fast_[next,prev]float(x::subnormal) is [next,prev]float(x,2)

function fast_nextfloat(c::Float64)
    u = fast_ufp_signed(c)
    v = fma(rre64, u, c)
    return v
end

function fast_prevfloat(c::Float64)
    u = fast_ufp_signed(c)
    v = fma(neg_rre64, cleaninf(u), c)
    return v
end

function fast_prevfloat(c::Float64)
    t = ifelse(is_pow2(c) , neg_halfrre64 , neg_rre64)
    u = fast_ufp_signed(c)
    v = fma(t, cleaninf(u), c)
    return v
end

function fast_nextfloat(c::Float32)
    u = fast_ufp_signed(c)
    v = fma(rre32, u, c)
    return v
end

function fast_prevfloat(c::Float32)
    t = ifelse(is_pow2(c) , neg_halfrre32 , neg_rre32)
    u = fast_ufp_signed(c)
    v = fma(t, u, c)
    return v
end

# without special handling for prevfloat(x::powerof2)
# faster_prevfloat(x::powerof2) = prevfloat(x,2)

function faster_nextfloat(c::Float64)
    u = fast_ufp_signed(c)
    v = fma(rre64, u, c)
    return v
end

function faster_prevfloat(c::Float64)
    u = fast_ufp_signed(c)
    v = fma(neg_rre64, u, c)
    return v
end

function faster_nextfloat(c::Float32)
    u = fast_ufp_signed(c)
    v = fma(rre32, u, c)
    return v
end

function faster_prevfloat(c::Float32)
    u = fast_ufp_signed(c)
    v = fma(neg_rre32, u, c)
    return v
end


# overlapping bits
#=
  Let a, b in F with 0 < |a| < |b|. Then a and b are nonoverlapping if and only if msb(a) < lsb(b).

  lemma 9 from Verantwortlich für diese Ausgabe:
Otto-von-Guericke-Universität Magdeburg
Fakultät für Informatik
Postfach 4120
39016 Magdeburg
E-Mail:
http://www.cs.uni-magdeburg.de/Technical_reports.html
Technical report (Internet)
ISSN 1869-5078
=#
msb(x) = ufp(x)
# msb(0) = 0; msb(x) = 2^floor(Int, log2(abs(x))
lsb(x::T) where {T} = msb(x) / 2.0^explicit_precision(T)
# lsb(x) = max(sigma | x in sigma Z, sigma = 2^k, k in Z )
# lsb(0) = 0; lsb(x) = 
#=
julia> overlapsby(1.0,0.275)
51

julia> overlapsby(0.275,1.0)
-51

julia> overlaps(1.0,eps(1.0))
true

julia> overlaps(1.0,eps(1.0)/2)
false
=#
overlaps(x::T, y::T) where {T} = overlaps_(maxminmag(x, y)...)
overlaps_(x::T, y::T) where {T} = to_be_gte(x, y) < implicit_precision(T)

overlapsby(x::T, y::T) where {T} = copysign(overlapsby_(maxminmag(x, y)...), absx_minus_absy(x,y))
overlapsby_(x::T, y::T) where {T} = implicit_precision(T) - to_be_gte(x, y)

# without considering trailing zero bits, overlapsby
nzoverlapsby(x::T, y::T) where {T} = copysign(nzoverlapsby_(maxminmag(x, y)...), absx_minus_absy(x,y))
nzoverlapsby_(x::T, y::T) where {T} = implicit_precision(T) - nz_to_be_gte(x, y)

to_be_gte(x::T, y::T) where {T} = to_be_gte_(maxminmag(x, y)...)
to_be_gte_(x::T, y::T) where {T} = bfp(x) - bfp(y) + (significand(abs(x)) > significand(abs(y)))

nz_to_be_gte(x::T, y::T) where {T} = nz_to_be_gte_(maxminmag(x, y)...)
nz_to_be_gte_(x::T, y::T) where {T} = bls(x) - bls(y) + (significand(abs(x)) > significand(abs(y)))

maxminmag(x::T, y::T) where {T} = signbit(abs(x) - abs(y)) ? (y, x) : (x, y)
absx_minus_absy(x::T, y::T) where {T} = abs(x) - abs(y)

end # FirstAndLastPlaceValues
