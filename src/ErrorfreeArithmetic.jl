module ErrorfreeArithmetic

export two_sum, two_diff, two_prod, two_inv, two_div,
       two_sum_sorted, two_diff_sorted,
       three_sum, three_diff, three_prod,
       three_sum_sorted, three_diff_sorted,
       two_sqrt, two_cbrt, three_cbrt,
       three_fma

if VERSION > v"0.6.9"
    import Base: IEEEFloat
else
    const IEEEFloat = Union{Float64, Float32, Float16}
end

include("errorfree.jl")
include("errorbest.jl")

end # ErrorfreeArithmetic
