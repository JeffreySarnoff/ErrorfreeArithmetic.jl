@inline magnitude_maxmin(x, y) = abs(y) < abs(x) ? (x, y) : (y, x)

magnitude_maxtomin(a, b) = magnitude_maxmin(a, b)

function magnitude_maxtomin(a, b, c)
    b, c = magnitude_maxmin(b, c)
    a, c = magnitude_maxmin(a, c)
    a, b = magnitude_maxmin(a, b)
    return a, b, c
end

function magnitude_maxtomin(a, b, c, d)
    c, d = magnitude_maxmin(c, d)
    b, d = magnitude_maxmin(b, d)
    a, d = magnitude_maxmin(a, d)    
    b, c = magnitude_maxmin(b, c)
    a, c = magnitude_maxmin(a, c)
    a, b = magnitude_maxmin(a, b)
    return a, b, c, d
end

magnitude_maxtomin(x::NTuple{2, T}) where {T} = magnitude_maxtomin(x[1], x[2])
magnitude_maxtomin(x::NTuple{3, T}) where {T} = magnitude_maxtomin(x[1], x[2], x[3])
magnitude_maxtomin(x::NTuple{4, T}) where {T} = magnitude_maxtomin(x[1], x[2], x[3], x[4])
