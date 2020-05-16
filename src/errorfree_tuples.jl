"""
    two_sum(a, b)

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_sum(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = a .+ b
    v  = hi .- a
    lo = (a .- (hi .- v)) .+ (b .- v)
    return hi, lo
end

"""
    two_sum(a, b, c)
    
Computes `hi = fl(a+b+c)` and `lo = err(a+b+c)`.
"""
function two_sum(a::T,b::T,c::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    s, t   = two_sum(b, c)
    hi, u  = two_sum(a, s)
    lo     = u .+ t
    hi, lo = two_hilo_sum(hi, lo)
    return hi, lo
end

"""
    three_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `md = err(a+b+c+d), lo = err(md)`.
"""
function three_sum(a::T,b::T,c::T,d::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    t0, t1 = two_sum(a ,  b)
    t0, t2 = two_sum(t0,  c)
    hi, t3 = two_sum(t0,  d)
    t0, t1 = two_sum(t1, t2)
    hm, t2 = two_sum(t0, t3) # here, t0 >= t3
    ml     = t1 .+ t2
    return hi, hm, ml
end

"""
    two_sum(a, b, c, d)
    
Computes `hi = fl(a+b+c+d)` and `lo = err(a+b+c+d)`.
"""
function two_sum(a::T,b::T,c::T,d::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    t0, t1 = two_sum(a ,  b)
    t0, t2 = two_sum(t0,  c)
    hi, t3 = two_sum(t0,  d)
    t0, t1 = two_sum(t1, t2)
    lo     = t0 .+ t3
    return hi, lo
end

"""
    two_diff(a, b)

Computes `s = fl(a-b)` and `e = err(a-b)`.
"""
@inline function two_diff(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = a .- b
    a1 = hi .+ b
    b1 = hi .- a1
    lo = (a .- a1) .- (b .+ b1)
    return hi, lo
end
"""
    three_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
"""
function three_diff(a::T,b::T,c::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    negb = (-).(b)
    s, t = two_diff(negb, c)
    x, u = two_sum(a, s)
    y, z = two_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    two_square(a)

Computes `s = fl(a*a)` and `e = err(a*a)`.
"""
@inline function two_square(a::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = a .* a
    neghi = (-).(hi)
    lo = (fma).(a, a, neghi)
    hi, lo
end

"""
    two_prod(a, b)

Computes `s = fl(a*b)` and `e = err(a*b)`.
"""
@inline function two_prod(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = a .* b
    neghi = (-).(hi)
    lo = (fma).(a, b, neghi)
    hi, lo
end

#=
   three_fma algorithm from
   Sylvie Boldo and Jean-Michel Muller
   Some Functions Computable with a Fused-mac
=#

"""
   three_fma(a, b, c)

Computes `s = fl(fma(a,b,c))` and `e1 = err(fma(a,b,c)), e2 = err(e1)`.
"""
function three_fma(a::T, b::T, c::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
     x = (fma).(a, b, c)
     y, z = two_prod(a, b)
     t, z = two_sum(c, z)
     t, u = two_sum(y, t)
     y = ((t .- x) .+ u)
     y, z = two_hilo_sum(y, z)
     infs = isinf.(x)   
     if any(infs)
        ys = [y...]
        zs = [z...]     
        ys[infs] .= zero(F)
        zs[infs] .= zero(F)
        y = (ys...,)
        z = (zs...,)
     end       
     return x, y, z
end

# with arguments sorted by magnitude

"""
    two_hilo_sum(a, b)

*unchecked* requirement `|a| ≥ |b|`

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_hilo_sum(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = a .+ b
    lo = b .- (hi .- a)
    return hi, lo
end

"""
    two_lohi_sum(a, b)

*unchecked* requirement `|b| ≥ |a|`

Computes `hi = fl(a+b)` and `lo = err(a+b)`.
"""
@inline function two_lohi_sum(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = b .+ a
    lo = a .- (hi .- b)
    return hi, lo
end

"""
    two_hilo_diff(a, b)
    
*unchecked* requirement `|a| ≥ |b|`

Computes `hi = fl(a-b)` and `lo = err(a-b)`.
"""
@inline function two_hilo_diff(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = a .- b
    lo = (a .- hi) .- b
    hi, lo
end

"""
    two_lohi_diff(a, b)
    
*unchecked* requirement `|b| ≥ |a|`

Computes `hi = fl(a-b)` and `lo = err(a-b)`.
"""
@inline function two_lohi_diff(a::T, b::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    hi = b .- a
    lo = (b .- hi) .- a
    hi, lo
enD    

"""
    three_hilo_diff(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `x = fl(a-b-c)` and `y = err(a-b-c), z = err(y)`.
"""
function three_hilo_diff(a::T,b::T,c::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    negc = (-).(c)
    s, t = two_hilo_diff(b, negc)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_lohi_diff(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `x = fl(a-b-c)` and `y = err(a-b-c), z = err(y)`.
"""
function three_lohi_diff(c::T,b::T,a::T) where {N, F<:Base.IEEEFloat, T<:NTuple{N,F}}
    negc = (-).(c)
    s, t = two_hilo_diff(b, negc)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end
