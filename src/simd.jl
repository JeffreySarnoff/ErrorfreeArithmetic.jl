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

function Base.:-(x::Float32x8)
    Base.llvmcall("""
        %res = fneg <8 x float> %0
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8}, x)
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

function Base.:+(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fadd <2 x float> %0 $1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:+(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fadd <4 x float> %0 $1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:+(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fadd <8 x float> %0 $1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:+(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fadd <2 x double> %0 $1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:+(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fadd<4 x double> %0 $1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

function Base.:-(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fsub <2 x float> %0 $1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:-(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fsub <4 x float> %0 $1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:-(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fsub <8 x float> %0 $1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:-(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fsub <2 x double> %0 $1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:-(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fsub<4 x double> %0 $1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

function Base.:*(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fmul <2 x float> %0 $1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:*(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fmul <4 x float> %0 $1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:*(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fmul <8 x float> %0 $1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:*(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fmul <2 x double> %0 $1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:*(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fmul<4 x double> %0 $1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

function Base.:/(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fdiv <2 x float> %0 $1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:/(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fdiv <4 x float> %0 $1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:/(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fdiv <8 x float> %0 $1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:/(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fdiv <2 x double> %0 $1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:/(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fdiv<4 x double> %0 $1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

