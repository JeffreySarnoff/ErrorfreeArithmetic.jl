const Float32x2 = NTuple{2, Base.VecElement{Float32}}
const Float64x2 = NTuple{2, Base.VecElement{Float64}}
const Float32x4 = NTuple{4, Base.VecElement{Float32}}
const Float64x4 = NTuple{4, Base.VecElement{Float64}}
const Float32x8 = NTuple{8, Base.VecElement{Float32}}

function Base.:-(x::Float32x2)
    Base.llvmcall("""
        %res = fneg <2 x float> %0
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2}, x)
end

function Base.:-(x::Float32x4)
    Base.llvmcall("""
        %res = fneg <4 x float> %0
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4}, x)
end

function Base.:-(x::Float64x2)
    Base.llvmcall("""
        %res = fneg <2 x double> %0
        ret <2 x double> %res
        """, Float64x4, Tuple{Float64x2}, x)
end

function Base.:-(x::Float64x4)
    Base.llvmcall("""
        %res = fneg <4 x double> %0
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4}, x)
end
