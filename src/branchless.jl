# https://www.youtube.com/watch?v=ZazBhE1IQd0 at times (25:59) (31:51)

@inline optional(flag::Bool, value::T) where {T<:Base.BitSigned} =
    (-(zero(T) | flag)) & value

@inline optional(flag::Bool, value::Int64) =
    (-(zero(Int64) | flag)) & value
#=    
julia> optional(true,6)
6

julia> optional(false,6)
0
=#

@inline if_else(flag::Bool, ifvalue::T, elsevalue::T) where {T<:Base.BitSigned} = let flg = zero(T) | flag
    (-flg & ifvalue) | ((flg - one(T)) & elsevalue)
end

@inline if_else(flag::Bool, ifvalue::Float64, elsevalue::Float64) =
     reinterpret(Float64, if_else(flag, reinterpret(Int64, ifvalue), reinterpret(Int64, elsevalue)) )

@inline if_else(flag::Bool, ifvalue::Float32, elsevalue::Float32) =
     reinterpret(Float32, if_else(flag, reinterpret(Int32, ifvalue), reinterpret(Int32, elsevalue)) )

@inline function hilo(a::T, b::T) where {T<:Union{Float64, Float32}}
    flag = a > b
    hi = reinterpret(Float64, if_else(flag, a, b))
    lo = reinterpret(Float64, if_else(flag, b, a))
    return hi,lo
end  

@inline function hilo_magnitude(a::T, b::T) where {T<:Union{Float64, Float32}}
    flag = abs(a) > abs(b)
    hi = reinterpret(Float64, if_else(flag, a, b))
    lo = reinterpret(Float64, if_else(flag, b, a))
    return hi,lo
end

@inline two_sum(a,b) = two_hilo_sum(hilo_magnitude(a,b))

@inline function two_hilo_sum(x::NTuple{2, T}) where {T}
    a,b = x; hi = a + b
    lo = b - (hi - a)
    return hi, lo
end

@inline function two_sum(a::T, b::T) where {T<:Union{Float64, Float32}}
    flag = abs(a) > abs(b)
    hi0 = reinterpret(Float64, if_else(flag, a, b))
    lo = reinterpret(Float64, if_else(flag, b, a))
    hi = hi0 + lo
    lo = lo - (hi0 - hi)
    return hi, lo
end

@inline function hilo_magnitude(a::Float64, b::Float64)
    absa = abs(a)
    absb = abs(b)
    flag = absa > absb
    inta = reinterpret(Int64, a)
    intb = reinterpret(Int64, b)
    inthi = if_else(flag, inta, intb)
    intlo = xor(xor(inta, intb), inthi)
    return reinterpret(Float64, inthi), reinterpret(Float64, intlo)
end

@inline function two_sum(a::Float64, b::Float64)
    inta = reinterpret(Int64, a)
    intb = reinterpret(Int64, b)
    flag = abs(a) > abs(b)
    inthi = if_else(flag, inta, intb)
    intlo = xor(xor(inta, intb), inthi)
    return two_hilo_sum(reinterpret(Float64, inthi), reinterpret(Float64, intlo))
end

#=
julia> if_else(true, 6, 10)
6

julia> if_else(false, 6, 10)
10

julia> ife(true, 1.125, 0.5)
1.125

julia> ife(false, 1.125, 0.5)
0.5
=#
