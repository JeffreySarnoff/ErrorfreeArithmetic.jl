"""
    two_sum(a, b)

Computes `s = fl(a+b)` and `e = err(a+b)`.
"""
@inline function two_sum(a::T, b::T) where {T<:AbstractFloat}
    s = a + b
    v = s - a
    e = (a - (s - v)) + (b - v)
    return s, e
end

"""
    two_diff(a, b)

Computes `s = fl(a-b)` and `e = err(a-b)`.
"""
@inline function two_diff(a::T, b::T) where {T<:AbstractFloat}
    s = a - b
    v = s - a
    e = (a - (s - v)) - (b + v)

    s, e
end

"""
    two_square(a)

Computes `s = fl(a*a)` and `e = err(a*a)`.
"""
@inline function two_square(a::T) where {T<:AbstractFloat}
    p = a * a
    e = fma(a, a, -p)
    p, e
end

"""
    two_cube(a)
    
Computes `s = fl(a*a*a)` and `e1 = err(a*a*a), e2 = err(e1)`.
"""
function two_cube(a::T) where {T<:AbstractFloat}
    y = a*a; z = fma(a, a, -y)
    x = y*a; y = fma(y, a, -x)
    z = fma(z,a,y)
    return x, z
end 

"""
    two_prod(a, b)

Computes `s = fl(a*b)` and `e = err(a*b)`.
"""
@inline function two_prod(a::T, b::T) where {T<:AbstractFloat}
    p = a * b
    e = fma(a, b, -p)
    p, e
end

"""
    three_sum(a, b, c)
    
Computes `s = fl(a+b+c)` and `e1 = err(a+b+c), e2 = err(e1)`.
"""
function three_sum(a::T,b::T,c::T) where {T<:AbstractFloat}
    s, t = two_sum(b, c)
    x, u = two_sum(a, s)
    y, z = two_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end


"""
    three_diff(a, b, c)
    
Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
"""
function three_diff(a::T,b::T,c::T) where {T<:AbstractFloat}
    s, t = two_diff(-b, c)
    x, u = two_sum(a, s)
    y, z = two_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end


"""
    three_prod(a, b, c)
    
Computes `s = fl(a*b*c)` and `e1 = err(a*b*c), e2 = err(e1)`.
"""
function three_prod(a::T, b::T, c::T) where {T<:AbstractFloat}
    y, z = two_prod(a, b)
    x, y = two_prod(y, c)
    z, t = two_prod(z, c)
    y, z = two_hilo_sum(y, z)
    z += t
    return x, y, z
end


"""
    three_cube(a)
    
Computes `s = fl(a*a*a)` and `e1 = err(a*a*a), e2 = err(e1)`.
"""
function three_cube(a::T) where {T<:AbstractFloat}
    y, z = two_prod(a, a)
    x, y = two_prod(y, a)
    z, t = two_prod(z, a)
    y, z = two_hilo_sum(y, z)
    z += t
    return x, y, z
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
function three_fma(a::T, b::T, c::T) where {T<:IEEEFloat}
     x = fma(a, b, c)
     y, z = two_prod(a, b)
     t, z = two_sum(c, z)
     t, u = two_sum(y, t)
     y = ((t - x) + u)
     y, z = two_hilo_sum(y, z)
     return x, y, z
end

# with arguments sorted by magnitude

"""
    two_hilo_sum(a, b)

*unchecked* requirement `|a| ≥ |b|`

Computes `s = fl(a+b)` and `e = err(a+b)`.
"""
@inline function two_hilo_sum(a::T, b::T) where {T<:AbstractFloat}
    s = a + b
    e = b - (s - a)
    return s, e
end

"""
    two_lohi_sum(a, b)

*unchecked* requirement `|b| ≥ |a|`

Computes `s = fl(a+b)` and `e = err(a+b)`.
"""
@inline function two_lohi_sum(a::T, b::T) where {T<:AbstractFloat}
    s = b + a
    e = a - (s - b)
    return s, e
end

"""
    two_hilo_diff(a, b)
    
*unchecked* requirement `|a| ≥ |b|`

Computes `s = fl(a-b)` and `e = err(a-b)`.
"""
@inline function two_hilo_diff(a::T, b::T) where {T<:AbstractFloat}
    s = a - b
    e = (a - s) - b
    s, e
end

"""
    two_lohi_diff(a, b)
    
*unchecked* requirement `|b| ≥ |a|`

Computes `s = fl(a-b)` and `e = err(a-b)`.
"""
@inline function two_lohi_diff(a::T, b::T) where {T<:AbstractFloat}
    s = b - a
    e = (b - s) - a
    s, e
end



"""
    three_hilo_sum(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `s = fl(a+b+c)` and `e1 = err(a+b+c), e2 = err(e1)`.
"""
function three_hilo_sum(a::T,b::T,c::T) where {T<:AbstractFloat}
    s, t = two_hilo_sum(b, c)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_lohi_sum(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `s = fl(a+b+c)` and `e1 = err(a+b+c), e2 = err(e1)`.
"""
function three_lohi_sum(a::T,b::T,c::T) where {T<:AbstractFloat}
    s, t = two_hilo_sum(b, a)
    x, u = two_hilo_sum(c, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_hilo_diff(a, b, c)
    
*unchecked* requirement `|a| ≥ |b| ≥ |c|`

Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
"""
function three_hilo_diff(a::T,b::T,c::T) where {T<:AbstractFloat}
    s, t = two_hilo_diff(-b, c)
    x, u = two_hilo_sum(a, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

"""
    three_lohi_diff(a, b, c)
    
*unchecked* requirement `|c| ≥ |b| ≥ |a|`

Computes `s = fl(a-b-c)` and `e1 = err(a-b-c), e2 = err(e1)`.
"""
function three_lohi_diff(a::T,b::T,c::T) where {T<:AbstractFloat}
    s, t = two_hilo_diff(-b, a)
    x, u = two_hilo_sum(c, s)
    y, z = two_hilo_sum(u, t)
    x, y = two_hilo_sum(x, y)
    return x, y, z
end

