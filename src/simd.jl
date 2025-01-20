const Float32x2 = NTuple{2, Base.VecElement{Float32}}
const Float32x4 = NTuple{4, Base.VecElement{Float32}}
const Float32x8 = NTuple{8, Base.VecElement{Float32}}
const Float64x2 = NTuple{2, Base.VecElement{Float64}}
const Float64x4 = NTuple{4, Base.VecElement{Float64}}

FloatBitsxN = NTuple{N, Base.VecElement{F}} where {N, F}

const one32x2 = (Float32x2)((1.0f0, 1.0f0))
const one32x4 = (Float32x4)((1.0f0, 1.0f0, 1.0f0, 1.0f0))
const one32x8 = (Float32x8)((1.0f0, 1.0f0, 1.0f0, 1.0f0, 1.0f0, 1.0f0, 1.0f0, 1.0f0))
const one64x2 = (Float32x2)((1.0, 1.0))
const one64x4 = (Float32x4)((1.0, 1.0, 1.0, 1.0))

Base.:+(x::VecElement{T}, y::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(x.value + y.value)
Base.:-(x::VecElement{T}, y::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(x.value - y.value)
Base.:*(x::VecElement{T}, y::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(x.value * y.value)
Base.:/(x::VecElement{T}, y::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(x.value / y.value)

Base.:+(a::VecElement{T}, b::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value + b.value)
Base.:*(a::VecElement{T}, b::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value * b.value)
Base.:-(a::VecElement{T}, b::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value - b.value)
Base.:/(a::VecElement{T}, b::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value / b.value)

Base.:+(a::VecElement{T}, b::VecElement{T}, c::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value + b.value + c.value)
Base.:*(a::VecElement{T}, b::VecElement{T}, c::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value * b.value * c.value)
Base.:+(a::VecElement{T}, b::VecElement{T}, c::VecElement{T}, d::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value + b.value + c.value + d.value)
Base.:*(a::VecElement{T}, b::VecElement{T}, c::VecElement{T}, d::VecElement{T}) where {T<:AbstractFloat} = VecElement{T}(a.value * b.value * c.value * d.value)

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
        %res = fadd <2 x float> %0, %1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:+(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fadd <4 x float> %0, %1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:+(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fadd <8 x float> %0, %1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:+(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fadd <2 x double> %0, %1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:+(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fadd <4 x double> %0, %1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

function Base.:-(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fsub <2 x float> %0, %1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:-(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fsub <4 x float> %0, %1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:-(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fsub <8 x float> %0, %1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:-(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fsub <2 x double> %0, %1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:-(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fsub <4 x double> %0, %1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

function Base.:*(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fmul <2 x float> %0, %1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:*(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fmul <4 x float> %0, %1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:*(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fmul <8 x float> %0, %1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:*(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fmul <2 x double> %0, %1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:*(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fmul <4 x double> %0, %1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end

function Base.:/(x::Float32x2, y::Float32x2)
    Base.llvmcall("""
        %res = fdiv <2 x float> %0, %1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, x, y)
end

function Base.:/(x::Float32x4, y::Float32x4)
    Base.llvmcall("""
        %res = fdiv <4 x float> %0, %1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, x, y)
end

function Base.:/(x::Float32x8, y::Float32x8)
    Base.llvmcall("""
        %res = fdiv <8 x float> %0, %1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, x, y)
end

function Base.:/(x::Float64x2, y::Float64x2)
    Base.llvmcall("""
        %res = fdiv <2 x double> %0, %1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, x, y)
end

function Base.:/(x::Float64x4, y::Float64x4)
    Base.llvmcall("""
        %res = fdiv <4 x double> %0, %1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, x, y)
end


function Base.:inv(y::Float32x2)
    Base.llvmcall("""
        %res = fdiv <2 x float> %0, %1
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2, Float32x2}, one32x2, y)
end

function Base.:inv(y::Float32x4)
    Base.llvmcall("""
        %res = fdiv <4 x float> %0, %1
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4, Float32x4}, one32x4, y)
end

function Base.:inv(y::Float32x8)
    Base.llvmcall("""
        %res = fdiv <8 x float> %0, %1
        ret <8 x float> %res
        """, Float32x8, Tuple{Float32x8, Float32x8}, one32x8 y)
end

function Base.:inv(y::Float64x2)
    Base.llvmcall("""
        %res = fdiv <2 x double> %0, %1
        ret <2 x double> %res
        """, Float64x2, Tuple{Float64x2, Float64x2}, one64x2, y)
end

function Base.:inv(y::Float64x4)
    Base.llvmcall("""
        %res = fdiv <4 x double> %0, %1
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4, Float64x4}, one64x4, y)
end

@inline function two_hilo_sum(a::T, b::T) where {N, F, T<:NTuple{N,F}}                                                           
    hi = a + b
    lo = b - (hi - a)
    (hi, lo)
end

@inline function two_sum(a::T, b::T) where {N, F, T<:NTuple{N,F}}
    hi = a + b
    v  = hi - a
    lo = (a - (hi - v)) + (b - v)
    (hi, lo)
end

@inline function Base.fma(a::T, b::T, c::T) where {N, F, T<:NTuple{N,F}}
    va = Vec(a)
    vb = Vec(b)
    vc = Vec(c)
    fma(va, vb, vc).data
end

@inline function two_prod(a::T, b::T) where {N, F, T<:NTuple{N,F}}
    hi = a * b
    lo = fma(a, b, -hi)
    (hi, lo)
end

