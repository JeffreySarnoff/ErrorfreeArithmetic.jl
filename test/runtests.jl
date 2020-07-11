using ErrorfreeArithmetic, Random, Test

BigFloatOldPrec = precision(BigFloat)

Random.seed!(0xface)  # ensure tests that use rands are repeatable

# ----------
trials = 100
# ----------


include("modules/Permute.jl")
using .Permute

include("specialrands.jl")
include("correct_errorfree.jl")

include("resolvefloats.jl")

include("test_errorfree.jl")
include("test_n_func.jl")

# ----------

setprecision(BigFloat, BigFloatOldPrec)
