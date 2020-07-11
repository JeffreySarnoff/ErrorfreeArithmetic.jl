module ErrorfreeArithmetic

export IEEEFloat, SysFloat,
       # error-free transformations (single argument)
       two_square,
       # error-free transformations (unsorted arguments)
       two_sum, three_sum, four_sum,
       two_diff, three_diff, four_diff,
       two_prod, three_prod, four_prod,
       two_fma, three_fma,
       # error-free transformations (magnitude sorted arguments)
       two_hilo_sum, three_hilo_sum, four_hilo_sum,
       two_hilo_diff, three_hilo_diff, four_hilo_diff,
       two_lohi_sum, three_lohi_sum, four_lohi_sum,
       two_lohi_diff, three_lohi_diff, four_lohi_diff,
       # error-free remainders
       div_rem, sqrt_rem,
       # least-error transformations, as close to error-free as possible
       # least-error transformations (single argument)
       two_inv, two_sqrt,
       # least-error transformations (two arguments)
       two_div,
       # least-error transformations (three arguments)
       a_minus_bc, ab_minus_c,
       # least-error transformations (four arguments)
       ad_minus_bc


using Base: IEEEFloat

"""
    SysFloat

SysFloats are floating point types with processor fma support.
"""
const SysFloat = Union{Float64, Float32}

"""
    FloatWithFMA

Floats with FMA support fused multiply-add, fma(x,y,z)
""" FloatWithFMA

if isdefined(Main, :Quadmath)
    const FloatWithFMA = Union{Float128, Float64, Float32, Float16}
else
    const FloatWithFMA = Union{Float64, Float32, Float16}
end

include("sortbymag.jl")

include("errorfree.jl")
include("errorfree_tuple.jl")
include("errorfree_tuples.jl")
include("leasterror.jl")
include("remainder.jl")

include("modules/FirstAndLastPlaceValues.jl")
using .FirstAndLastPlaceValues
include("modules/SortByMagnitude.jl")
using .SortByMagnitude

end # ErrorfreeArithmetic
