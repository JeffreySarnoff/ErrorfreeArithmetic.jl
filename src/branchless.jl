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
     reinterpret(Float64, if_else(flag, reinterpret(Int64,ifvalue), reinterpret(Int64,elsevalue)) )

@inline if_else(flag::Bool, ifvalue::Float32, elsevalue::Float32) =
     reinterpret(Float32, if_else(flag, reinterpret(Int32,ifvalue), reinterpret(Int32,elsevalue)) )

@inline function if_hilo_else(a::Float64, b::Float64)
    flag = abs(a) > abs(b)
    hi = reinterpret(Float64, if_else(flag, a, b))
    lo = reinterpret(Float64, if_else(flag, b, a))
    return hi,lo
end  

#=

julia> @inline function if_el(flag::Bool, ifvalue1::Float64, ifvalue2::Float64, elsevalue1::Float64, elsevalue2::Float64)
            a1 = reinterpret(Int64, ifvalue1)
            a2 = reinterpret(Int64, ifvalue2)
            a3 = reinterpret(Int64, elsevalue1)
            a4 = reinterpret(Int64, elsevalue2)
            result = if_else(flag, a1, a2, a3, a4)
            return reinterpret(Float64, result[1]), reinterpret(Float64, result[2])
           end
if_el (generic function with 1 method)

julia> if_el(true,a,b,b,a)
(1.4142135623730952e12, 1.4142135623730951)
=#

@inline if_else(flag::Bool, ifvalue1::T, ifvalue2::T, elsevalue1::T, elsevalue2::T) where {T<:Base.BitSigned} = let flg = zero(T) | flag
    ((-flg & ifvalue1) | ((flg - one(T)) & elsevalue1)), ((-flg & ifvalue2) | ((flg - one(T)) & elsevalue2))
end

@inline if_else(flag::Bool, ifvalue1::Float64, ifvalue2::Float64, elsevalue1::Float64, elsevalue2::Float64) =
     reinterpret.(Float64, if_else(flag, reinterpret(Int64,ifvalue1), reinterpret(Int64,ifvalue2), reinterpret(Int64,elsevalue1), reinterpret(Int64,elsevalue2)) )

@inline if_else(flag::Bool, ifvalue1::Float32, ifvalue2::Float32, elsevalue1::Float32, elsevalue2::Float32) =
     reinterpret.(Float32, if_else(flag, reinterpret(Int32,ifvalue1), reinterpret(Int32,ifvalue2), reinterpret(Int32,elsevalue1), reinterpret(Int32,elsevalue2)) )

@inline function if_else(flag::Bool, ifvalue1::Float64, ifvalue2::Float64, elsevalue1::Float64, elsevalue2::Float64)
     hilo =  if_else(flag, reinterpret(Int64,ifvalue1), reinterpret(Int64,ifvalue2), reinterpret(Int64,elsevalue1), reinterpret(Int64,elsevalue2))
     return reinterpret(Float64, hilo[1]), reinterpret(Float64, hilo[2])
end

 @inline function if_hilo_else(ifvalue1::Float64, ifvalue2::Float64, elsevalue1::Float64, elsevalue2::Float64)
    hilo =  if_else(abs(ifvalue1) > abs(ifvalue2), reinterpret(Int64,ifvalue1), reinterpret(Int64,ifvalue2), reinterpret(Int64,elsevalue1), reinterpret(Int64,elsevalue2))
    return reinterpret(Float64, hilo[1]), reinterpret(Float64, hilo[2])
end
@inline function if_hilo_else(ifvalue1::Float64, ifvalue2::Float64)
    hilo =  if_else(abs(ifvalue1) > abs(ifvalue2), reinterpret(Int64,ifvalue1), reinterpret(Int64,ifvalue2), reinterpret(Int64,ifvalue2), reinterpret(Int64,ifvalue1))
    return reinterpret(Float64, hilo[1]), reinterpret(Float64, hilo[2])
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
