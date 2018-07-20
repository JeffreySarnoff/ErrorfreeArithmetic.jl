module ErrorfreeArithmetic

       
export # error-free transformations
       two_sum, two_diff, two_prod 
       three_sum, three_diff, three_prod,
       three_fma
       # error-free transformations with magnitude sorted arguments
       two_hilo_sum, two_lohi_sum, two_hilo_diff, two_lohi_diff,
       three_hilo_sum, three_lohi_sum, three_hilo_diff, three_lohi_diff,
       # least-error transformations, as close to error-free as possible
       two_inv, two_sqrt, two_div

import Base.IEEEFloat

include("errorfree.jl")
include("errorbest.jl")

end # ErrorfreeArithmetic
