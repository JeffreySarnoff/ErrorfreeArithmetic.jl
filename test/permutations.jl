using Random
using Combinatorics

setprecision(BigFloat, 1024);

function bigto1(x::BigFloat; T=Float64)
    return T(x)
end
function bigto2(x::BigFloat; T=Float64)
    hi = T(x)
    lo = T(x - hi)
    return hi, lo
end
function bigto3(x::BigFloat; T=Float64)
    hi = T(x)
    md = T(x - hi)
    lo = T(x - hi - md)
    return hi, md, lo
end
function bigto4(x::BigFloat; T=Float64)
    hi = T(x)
    himd = T(x - hi)
    lomd = T(x - hi - himd)
    lo = T(x - hi - himd - lomd)
    return hi, himd, lomd, lo
end

function bigfrom1(x::T) where {T}
    return BigFloat(x)
end
function bigfrom2(x::T, y::T) where {T}
    return BigFloat(y) + BigFloat(x)
end
function bigfrom3(x::T, y::T, z::T) where {T}
    return BigFloat(z) + BigFloat(y) + BigFloat(x)
end
function bigfrom4(w::T, x::T, y::T, z::T) where {T}
    return BigFloat(z) + BigFloat(y) + BigFloat(x) + BigFloat(w)
end

# how many distinct permutations of k items
npermutations(k) = length(permutations(1:k))

#=
julia> upton(n,k) = length(collect(multiset_permutations(collect(1:n),k)))

julia> upto32x2 = merge(Tuple(NamedTuple{(Symbol(:n,i),)}(upton(i,2)) for i=1:32)...)
(n1 = 0, n2 = 2, n3 = 6, n4 = 12, n5 = 20, n6 = 30, n7 = 42, n8 = 56, n9 = 72, n10 = 90, n11 = 110, n12 = 132, n13 = 156, n14 = 182, n15 = 210, n16 = 240, n17 = 272, n18 = 306, n19 = 342, n20 = 380, n21 = 420, n22 = 462, n23 = 506, n24 = 552, n25 = 600, n26 = 650, n27 = 702, n28 = 756, n29 = 812, n30 = 870, n31 = 930, n32 = 992)

julia> upto32x3 = merge(Tuple(NamedTuple{(Symbol(:n,i),)}(upton(i,3)) for i=1:32)...)
(n1 = 0, n2 = 0, n3 = 6, n4 = 24, n5 = 60, n6 = 120, n7 = 210, n8 = 336, n9 = 504, n10 = 720, n11 = 990, n12 = 1320, n13 = 1716, n14 = 2184, n15 = 2730, n16 = 3360, n17 = 4080, n18 = 4896, n19 = 5814, n20 = 6840, n21 = 7980, n22 = 9240, n23 = 10626, n24 = 12144, n25 = 13800, n26 = 15600, n27 = 17550, n28 = 19656, n29 = 21924, n30 = 24360, n31 = 26970, n32 = 29760)

julia> upto32x4 = merge(Tuple(NamedTuple{(Symbol(:n,i),)}(upton(i,4)) for i=1:32)...)
(n1 = 0, n2 = 0, n3 = 0, n4 = 24, n5 = 120, n6 = 360, n7 = 840, n8 = 1680, n9 = 3024, n10 = 5040, n11 = 7920, n12 = 11880, n13 = 17160, n14 = 24024, n15 = 32760, n16 = 43680, n17 = 57120, n18 = 73440, n19 = 93024, n20 = 116280, n21 = 143640, n22 = 175560, n23 = 212520, n24 = 255024, n25 = 303600, n26 = 358800, n27 = 421200, n28 = 491400, n29 = 570024, n30 = 657720, n31 = 755160, n32 = 863040)

upto24x5 = merge(Tuple(NamedTuple{(Symbol(:n,i),)}(upton(i,5)) for i=1:24)...)
(n1 = 0, n2 = 0, n3 = 0, n4 = 0, n5 = 120, n6 = 720, n7 = 2520, n8 = 6720, n9 = 15120, n10 = 30240, n11 = 55440, n12 = 95040, n13 = 154440, n14 = 240240, n15 = 360360, n16 = 524160, n17 = 742560, n18 = 1028160, n19 = 1395360, n20 = 1860480, n21 = 2441880, n22 = 3160080, n23 = 4037880, n24 = 5100480)
=#
#=
atatime(m) = collect(multiset_permutations(collect(1:m),m));
multitimes(m,k) =  collect(n .+ t for n in atatime(m) for t=0:m:m*k);
allpermsby(nargs,nsets) = Tuple.(sort(multitimes(nargs,nsets-1), lt=(a,b)->sort(a) < sort(b)));
eachpermset(nargs, nsets) = reshape(allpermsby(nargs,nsets), (npermutations(nargs), nsets));

julia> eachpermset(2,3)
2×3 Array{Tuple{Int64,Int64},2}:
 (1, 2)  (3, 4)  (5, 6)
 (2, 1)  (4, 3)  (6, 5)

julia> eachpermset(3,2)
6×2 Array{Tuple{Int64,Int64,Int64},2}:
 (1, 2, 3)  (4, 5, 6)
 (1, 3, 2)  (4, 6, 5)
 (2, 1, 3)  (5, 4, 6)
 (2, 3, 1)  (5, 6, 4)
 (3, 1, 2)  (6, 4, 5)
 (3, 2, 1)  (6, 5, 4)
=#

setprecision(BigFloat, 6*64)

if isdefined(:seed!)
  bigflrng = seed!(124);
  floatrng = seed!(1618);
  scalerng = seed!(141421);
  boolrng  = seed!(6180);
else
  bigflrng = MersenneTwister(124);
  floatrng = MersenneTwister(1618);
  scalerng = MersenneTwister(141421);
  boolrng  = MersenneTwister(6180);
end

const permute1 = collect(permutations((1,)));        # n=   1
const permute2 = collect(permutations((1,2)));       # n=   2
const permute3 = collect(permutations((1,2,3)));     # n=   6
const permute4 = collect(permutations((1,2,3,4)));   # n=  24
const permute5 = collect(permutations((1,2,3,4,5))); # n= 120
const permuted = (permute1, permute2, permute3, permute4, permute5)

parts1(x::BigFloat, T=Float64) = T(x)

function parts2(x::BigFloat, T=Float64)
    hi = T(x)
    lo = T(x - hi)
    return hi, lo
end

function parts3(x::BigFloat, T=Float64)
    hi = T(x)
    md = T(x - hi)
    lo = T(x - hi - md)
    return hi, md, lo
end

function parts4(x::BigFloat, T=Float64)
    hi = T(x)
    hm = T(x - hi)
    lm = T(x - hi - hm)
    lo = T(x - hi - hm - lm)
    return hi, hm, lm, lo
end

function parts5(x::BigFloat, T=Float64)
    hi = T(x)
    hm = T(x - hi)
    md = T(x - hi - hm)
    lm = T(x - hi - hm - md)
    lo = T(x - hi - hm - md - lm)
    return hi, hm, md, lm, lo
end

function whole(xs::NTuple{N,Float64}) where {N}
    sum(BigFloat.(reverse(xs)))
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

function randbig(scalemax=60, scalemin=0)
    fl = randsign(rand(bigflrng, BigFloat))
    xp  = shift_exp_updown_by(scalemax, scalemin)
    fl  = shift_exp(fl, xp)
    return fl
end

function randfloats(n; scalemax=60, scalemin=0)
   Tuple(sort([randfloat(scalemax, scalemin) for i=1:n], lt=(a,b)->abs(b)<abs(a)))
end

function randbigs(n; scalemax=60, scalemin=0)
   Tuple(sort([randbig(scalemax, scalemin) for i=1:n], lt=(a,b)->abs(b)<abs(a)))
end

amaxmin(x::T, y::T) where {T} = ifelse( abs(x) < abs(y), (y,x), (x,y) )
function amaxmin(x::T, y::T, z::T) where {T}
     y, z = amaxmin(y, z)
     x, z = amaxmin(x, z)
     x, y = amaxmin(x, y)
     return x, y, z
end

#=
function test3(fn, n)
    for i in 1:n
        t = randfloats(3)
        z = [[fn(y...)...] for y in [t[x] for x in permuted3]]
        ok = all([[0.0, 0.0, 0.0] == x for x in [zz .- z[1] for zz in z]])
        if !ok
           println(f, t)
           break
        end
    end
end

julia> t = randfloats(3)
(-2.335712860372784e16, 1.9615015456354034e-9, 3.959791116468795e-13)
t
(2.66855208182581e14, -504425.86334703304, 0.005953136439487481)

z = [[three_sum(y...)...] for y in [t[x] for x in permuted3]]
all([[0.0, 0.0, 0.0] == x for x in [zz .- z[1] for zz in z]])

=#
