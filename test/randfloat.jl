using Random
using Random: Xoshiro

sign_rng = Xoshiro(6180)
exponent_rng = Xoshiro(141421)
significand_rng = Xoshiro(1618)
bigfloat_rng = Xoshiro(124)

const EXPMIN =  0
const EXPMAX = 96

randsign() = rand(sign_rng,(-1,1))
randsign(n) = rand(sign_rng,(-1,1), n)

randexp(; expmin=EXPMIN, expmax=EXPMAX) = rand(exponent_rng, expmin:expmax)
randexp(n; expmin=EXPMIN, expmax=EXPMAX) = rand(exponent_rng, expmin:expmax, n)

randsexp(; expmin=EXPMIN, expmax=EXPMAX) = randsign() * randexp(; expmin, expmax)
randsexp(n; expmin=EXPMIN, expmax=EXPMAX) = randsign(n) .* randexp(n; expmin, expmax)

randsig(; T=Float64) = rand(significand_rng, T)
randsig(n; T=Float64) = rand(significand_rng, T, n)

randssig(; T=Float64) = randsign() * randsig(; T)
randssig(n; T=Float64) = randsign(n) .* randsig(n; T)

randfloat(; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = ldexp(randsig(; T), randexp(; expmin, expmax))
randfloatsx(; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = ldexp(randsig(; T), randsexp(; expmin, expmax))
randsfloatss(; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = ldexp(randssig(; T), randexp(; expmin, expmax))
randfloatssx(; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = ldexp(randssig(; T), randsexp(; expmin, expmax))

randfloat(n; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = [randfloat(;T, expmin, expmax) for i=1:n]
randfloatsx(n; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = [randfloatsx(;T, expmin, expmax) for i=1:n]
randfloatss(n; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = [randfloatss(;T, expmin, expmax) for i=1:n]
randfloatssx(n; T=Float64, expmin=EXPMIN, expmax=EXPMAX) = [randfloatssx(;T, expmin, expmax) for i=1:n]

