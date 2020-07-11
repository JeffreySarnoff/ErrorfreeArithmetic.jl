@inline magnitude_maxmin(x, y) = signbit(abs(y) - abs(x)) ? (x, y) : (y, x)
@inline magnitude_minmax(x, y) = signbit(abs(x) - abs(y)) ? (x, y) : (y, x)

function magnitude_maxtomin(a, b, c)
    b, c = magnitude_maxmin(b, c)
    a, c = magnitude_maxmin(a, c)
    a, b = magnitude_maxmin(a, b)
    return a, b, c
end

function magnitude_mintomax(a, b, c)
    b, c = magnitude_minmax(b, c)
    a, c = magnitude_minmax(a, c)
    a, b = magnitude_minmax(a, b)
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

function magnitude_mintomax(a, b, c, d)
    c, d = magnitude_minmax(c, d)
    b, d = magnitude_minmax(b, d)
    a, d = magnitude_minmax(a, d)    
    b, c = magnitude_minmax(b, c)
    a, c = magnitude_minmax(a, c)
    a, b = magnitude_minmax(a, b)
    return a, b, c, d
end


magnitude_maxtomin(x::NTuple{2, T}) where {T} = magnitude_maxtomin(x[1], x[2])
magnitude_maxtomin(x::NTuple{3, T}) where {T} = magnitude_maxtomin(x[1], x[2], x[3])
magnitude_maxtomin(x::NTuple{4, T}) where {T} = magnitude_maxtomin(x[1], x[2], x[3], x[4])

magnitude_mintomax(x::NTuple{2, T}) where {T} = magnitude_mintomax(x[1], x[2])
magnitude_mintomax(x::NTuple{3, T}) where {T} = magnitude_mintomax(x[1], x[2], x[3])
magnitude_mintomax(x::NTuple{4, T}) where {T} = magnitude_mintomax(x[1], x[2], x[3], x[4])
