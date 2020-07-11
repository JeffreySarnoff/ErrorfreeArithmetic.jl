module SortByMagnitude

export mag_maxtomin, mag_mintomax

@inline mag_maxmin(x, y) = signbit(abs(y) - abs(x)) ? (x, y) : (y, x)
@inline mag_minmax(x, y) = signbit(abs(x) - abs(y)) ? (x, y) : (y, x)

mag_maxtomin(a, b) = mag_maxmin(a, b)
mag_mintomax(a, b) = mag_minmax(a, b)

function mag_maxtomin(a, b, c)
    b, c = mag_maxmin(b, c)
    a, c = mag_maxmin(a, c)
    a, b = mag_maxmin(a, b)
    return a, b, c
end

function mag_mintomax(a, b, c)
    b, c = mag_minmax(b, c)
    a, c = mag_minmax(a, c)
    a, b = mag_minmax(a, b)
    return a, b, c
end

function mag_maxtomin(a, b, c, d)
    c, d = mag_maxmin(c, d)
    b, d = mag_maxmin(b, d)
    a, d = mag_maxmin(a, d)    
    b, c = mag_maxmin(b, c)
    a, c = mag_maxmin(a, c)
    a, b = mag_maxmin(a, b)
    return a, b, c, d
end

function mag_mintomax(a, b, c, d)
    c, d = mag_minmax(c, d)
    b, d = mag_minmax(b, d)
    a, d = mag_minmax(a, d)    
    b, c = mag_minmax(b, c)
    a, c = mag_minmax(a, c)
    a, b = mag_minmax(a, b)
    return a, b, c, d
end

# handle tupled args

mag_maxtomin(x::NTuple{2, T}) where {T} = mag_maxtomin(x[1], x[2])
mag_maxtomin(x::NTuple{3, T}) where {T} = mag_maxtomin(x[1], x[2], x[3])
mag_maxtomin(x::NTuple{4, T}) where {T} = mag_maxtomin(x[1], x[2], x[3], x[4])

mag_mintomax(x::NTuple{2, T}) where {T} = mag_mintomax(x[1], x[2])
mag_mintomax(x::NTuple{3, T}) where {T} = mag_mintomax(x[1], x[2], x[3])
mag_mintomax(x::NTuple{4, T}) where {T} = mag_mintomax(x[1], x[2], x[3], x[4])

end  # SortByMagnitude
