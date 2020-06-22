@inline min_max(x,y) = ifelse(abs(x) < abs(y), (x,y) , (y,x))
@inline max_min(x,y) = ifelse(abs(y) < abs(x), (x,y) , (y,x))

function mintomax(a::T, b::T) where {T}
    a, b = min_max(a, b)
    return a, b
end

function maxtomin(a::T, b::T) where {T}
    a, b = max_min(a, b)
    return a, b
end

function mintomax(a::T, b::T, c::T) where {T}
    b, c = min_max(b, c)
    a, c = min_max(a, c)
    a, b = min_max(a, b)
    return a, b, c
end

function maxtomin(a::T, b::T, c::T) where {T}
    b, c = max_min(b, c)
    a, c = max_min(a, c)
    b, b = max_min(a, b)
    return a, b, c
end

function mintomax(a::T, b::T, c::T, d::T) where {T}
    a, b = min_max(a, b)
    c, d = min_max(c, d)
    a, c = min_max(a, c)
    b, d = min_max(b, d)
    b, c = min_max(b, c)
    return a, b, c, d
end

function maxtomin(a::T, b::T, c::T, d::T) where {T}
    a, b = max_min(a, b)
    c, d = max_min(c, d)
    a, c = max_min(a, c)
    b, d = max_min(b, d)
    b, c = max_min(b, c)
    return a, b, c, d
end
