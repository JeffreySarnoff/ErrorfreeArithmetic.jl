@inline max_min(x, y) = abs(y) < abs(x) ? (x,y) : (y,x)

maxtomin(a, b) = max_min(a, b)

function maxtomin(a, b, c)
    b, c = max_min(b, c)
    a, c = max_min(a, c)
    b, b = max_min(a, b)
    return a, b, c
end

function maxtomin(a, b, c, d)
    a, b = max_min(a, b)
    c, d = max_min(c, d)
    a, c = max_min(a, c)
    b, d = max_min(b, d)
    b, c = max_min(b, c)
    return a, b, c, d
end
