module ErrorfreeArithmetic

# these exports implement error-free transformations
export two_sum, two_diff, two_prod 
       three_sum, three_diff, three_prod,
       two_sum_sorted, two_diff_sorted,
       three_sum_sorted, three_diff_sorted,
       three_fma

# these exports implement least-error transformations
# they are as close to error-free as possible
export two_inv, two_sqrt, two_div

import Base.IEEEFloat

include("errorfree.jl")
include("errorbest.jl")

end # ErrorfreeArithmetic
