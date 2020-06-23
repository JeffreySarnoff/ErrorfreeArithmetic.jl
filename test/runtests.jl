using ErrorfreeArithmetic, Random, Test

Random.seed!(0xface)  # ensure tests that use rands are repeatable

# 512. (sigbits + extrabits) * (4 + 1) [4+1 from renormalize(a,b,c,d,e)]
const BigFloatOldPrec = precision(BigFloat)
const BigFloatPrec = nextpow(2, ((Base.significand_bits(Float64) + 1 + 36) * 5)) 
setprecision(BigFloat, BigFloatPrec)

# select one of these two approaches
# bigfloat(x) = BigFloat(string(x))
bigfloat(x) = BigFloat(x)

# ----------
trials = 100
# ----------

include("specialrands.jl")
include("permutations.jl")
include("errorfree.jl")

include("resolvefloats.jl")

include("test_errorfree.jl")
include("test_n_func.jl")

# ----------

setprecision(BigFloat, BigFloatOldPrec)
