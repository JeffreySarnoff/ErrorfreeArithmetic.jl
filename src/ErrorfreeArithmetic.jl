module ErrorfreeArithmetic

export # error-free transformations
       one_sum, 
       two_sum, two_diff, two_prod, two_square, two_cube, two_fma, two_muladd,
       three_sum, three_diff, three_prod, three_fma,
       four_sum,
       # error-free transformations with magnitude sorted arguments
       two_hilo_sum, three_hilo_sum, four_hilo_sum,
       two_lohi_sum, three_lohi_sum, four_lohi_sum,
       two_hilo_diff, three_hilo_diff,
       two_lohi_diff, three_lohi_diff,
       # least-error transformations, as close to error-free as possible
       two_inv, two_sqrt,
       two_div

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
include("complex.jl")

end # ErrorfreeArithmetic
