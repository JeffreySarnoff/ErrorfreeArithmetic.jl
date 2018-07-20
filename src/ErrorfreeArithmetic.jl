module ErrorfreeArithmetic

# these exports implement error-free transformations
export two_sum, two_diff, two_prod 
       three_sum, three_diff, three_prod,
       two_hilo_sum, two_hilo_diff,
       three_hilo_sum, three_hilo_diff,
       three_fma

# these exports implement least-error transformations
# they are as close to error-free as possible
export two_inv, two_sqrt, two_div

import Base.IEEEFloat

include("errorfree.jl")
include("errorbest.jl")

end # ErrorfreeArithmetic
