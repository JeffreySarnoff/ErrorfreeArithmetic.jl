module ErrorfreeArithmetic

export # error-free transformations
       vvec_sum,
       one_sum, two_sum, two_diff, two_prod, two_square,
       three_sum, three_diff, three_prod,
       four_sum, four_diff,
       ad_minus_bc, two_fma, three_fma, two_muladd,
       # error-free transformations with magnitude sorted arguments
       two_hilo_sum, two_lohi_sum, two_hilo_diff, two_lohi_diff,
       three_hilo_sum, three_lohi_sum, three_hilo_diff, three_lohi_diff,
       four_hilo_sum, four_lohi_sum, four_hilo_diff, four_lohi_diff,
       # least-error transformations, as close to error-free as possible
       two_inv, two_sqrt, two_div,
       # error-free remainders
       div_rem, sqrt_rem

using Base: IEEEFloat
using VectorizationBase

include("min_max.jl")
include("sum_ordered.jl")
include("sum.jl")
include("diff.jl")
include("prod_fma.jl")
include("vecsum.jl")
include("errorfree_tuples.jl")
include("leasterror.jl")
include("remainder.jl")
include("complex.jl")

end # ErrorfreeArithmetic
