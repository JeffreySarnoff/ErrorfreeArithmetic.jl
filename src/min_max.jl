"""
    one_minmag(a, b)

obtains value of least magnitude
"""
one_minmag(a::T, b::T) where {T} = abs(a) < abs(b) ? a : b 

"""
    one_maxmag(a, b)

obtains value of greatest magnitude
"""
one_maxmag(a::T, b::T) where {T} = abs(a) < abs(b) ? b : a 

"""
    one_minmag(a, b, c)

obtains value with least magnitude
"""
function one_minmag(a::T, b::T, c::T) where {T}
     one_minmag(one_minmag(a, b), c)
end

"""
    one_maxmag(a, b, c)

obtains value with largest magnitude
"""
function one_maxmag(a::T, b::T, c::T) where {T}
     one_maxmag(one_maxmag(a, b), c)
end

"""
    one_minmag(a, b, c, d)

obtains value with least magnitude
"""
function one_minmag(a::T, b::T, c::T, d::T) where {T}
     one_minmag(one_minmag(a, b), one_minmag(c, d))
end

"""
    one_maxmag(a, b, c, d)

obtains value with largest magnitude
"""
function one_maxmag(a::T, b::T, c::T, d::T) where {T}
     one_maxmag(one_maxmag(a, b), one_maxmag(c, d))
end
    
"""
    two_minmag(a, b)

orders (a, b) by ascending magnitude
"""
two_minmag(a::T, b::T) where {T} = abs(a) < abs(b) ? (a, b) : (b, a)

"""
    two_maxmag(a, b)

orders (a, b) by descending magnitude
"""
two_maxmag(a::T, b::T) where {T} = abs(b) < abs(a) ? (a, b) : (b, a)

"""
    two_minmag(a, b, c)

obtains two values in order of ascending magnitude
"""
function two_minmag(x::T, y::T, z::T) where {T}
     y, z = two_minmag(y, z)
     x = one_minmag(x, z)
     x, y = two_minmag(x, y)
     return x, y
end

"""
    two_maxmag(a, b, c)

obtains two values in order of descending magnitude
"""
function two_maxmag(x::T, y::T, z::T) where {T}
     y, z = two_maxmag(y, z)
     x = one_maxmag(x, z)
     x, y = two_maxmag(x, y)
     return x, y
end

"""
    two_minmag(a, b, c, d)

obtains two values in order of ascending magnitude
"""
function two_minmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_minmag(a, b)
    c, d = two_minmag(c, d)
    a, c = two_minmag(a, c)
    b = one_minmag(b, d)
    b = one_minmag(b, c)
    a, b
end

"""
    two_maxmag(a, b, c, d)

obtains two values with largest magnitudes in order of descending magnitude
"""
function two_maxmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_maxmag(a, b)
    c, d = two_maxmag(c, d)
    a, c = two_maxmag(a, c)
    b = one_maxmag(b, d)
    b = one_maxmag(b, c)
    a, b
end

"""
    three_minmag(a, b, c)

orders (a, b, c) by ascending magnitude
"""
function three_minmag(x::T, y::T, z::T) where {T}
     y, z = two_minmag(y, z)
     x, z = two_minmag(x, z)
     x, y = two_minmag(x, y)
     return x, y, z
end

"""
    three_maxmag(a, b, c)

orders (a, b, c) by descending magnitude
"""
function three_maxmag(x::T, y::T, z::T) where {T}
     y, z = two_maxmag(y, z)
     x, z = two_maxmag(x, z)
     x, y = two_maxmag(x, y)
     return x, y, z
end

"""
    three_minmag(a, b, c, d)

orders 3 of (a, b, c, d) by ascending magnitude
"""
function three_minmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_minmag(a, b)
    c, d = two_minmag(c, d)
    a, c = two_minmag(a, c)
    b, d = two_minmag(b, d)
    b, c = two_minmag(b, c)
     
    return a, b, c
end

"""
    four_maxmag(a, b, c, d)

orders 3 of (a, b, c, d) by descending magnitude
"""
function three_maxmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_maxmag(a, b)
    c, d = two_maxmag(c, d)
    a, c = two_maxmag(a, c)
    b, d = two_maxmag(b, d)
    b, c = two_maxmag(b, c)
     
    return a, b, c
end

"""
    four_minmag(a, b, c, d)

orders (a, b, c, d) by ascending magnitude
"""
function four_minmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_minmag(a, b)
    c, d = two_minmag(c, d)
    a, c = two_minmag(a, c)
    b, d = two_minmag(b, d)
    b, c = two_minmag(b, c)
     
    return a, b, c, d
end

"""
    four_maxmag(a, b, c, d)

orders (a, b, c, d) by descending magnitude
"""
function four_maxmag(a::T, b::T, c::T, d::T) where {T}
    a, b = two_maxmag(a, b)
    c, d = two_maxmag(c, d)
    a, c = two_maxmag(a, c)
    b, d = two_maxmag(b, d)
    b, c = two_maxmag(b, c)
     
    return a, b, c, d
end

# fastest sorting by decreasing magnitude
@inline amaxmin(x::T, y::T) where {T} = ifelse( abs(x) < abs(y), (y,x), (x,y) )

@inline function amaxmin(x::T, y::T, z::T) where {T}
    y, z = amaxmin(y, z)
    x, z = amaxmin(x, z)
    x, y = amaxmin(x, y)
    return x, y, z
end
