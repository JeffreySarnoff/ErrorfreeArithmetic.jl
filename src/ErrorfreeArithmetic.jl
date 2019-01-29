module ErrorfreeArithmetic

       
export SysFloat,
       # error-free transformations
       two_sum, two_diff, two_prod, two_square,
       three_sum, three_diff, three_prod,
       four_sum, four_diff,
       ad_minus_bc, three_fma,
       # error-free transformations with magnitude sorted arguments
       two_hilo_sum, two_lohi_sum, two_hilo_diff, two_lohi_diff,
       three_hilo_sum, three_lohi_sum, three_hilo_diff, three_lohi_diff,
       four_hilo_sum, four_lohi_sum, four_hilo_diff, four_lohi_diff,
       # least-error transformations, as close to error-free as possible
       two_div,
       two_inv, two_sqrt


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

if isdefined(Main, :DoubleFloats)
    const FloatWithFMA = Union{Float64, Float32, Float16, Double64, Double32, Double16}
else
    const FloatWithFMA = Union{Float64, Float32, Float16}
end

include("errorfree.jl")
include("leasterror.jl")

# deprecated
two_inv(x::T) where {T<:AbstractFloat} = one_inv(x)
two_sqrt(x::T) where {T<:AbstractFloat} = one_sqrt(x)

end # ErrorfreeArithmetic
