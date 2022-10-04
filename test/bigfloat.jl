Base.BigFloat(x::T) where {T} = Base.convert(BigFloat, x)

setprecision(BigFloat, 6*64);

function parts1(x::BigFloat; T=Float64)
    return T(x)
end

function parts2(x::BigFloat; T=Float64)
    hi = T(x)
    lo = T(x - hi)
    return hi, lo
end

function parts3(x::BigFloat; T=Float64)
    hi = T(x)
    md = T(x - hi)
    lo = T(x - hi - md)
    return hi, md, lo
end

function parts4(x::BigFloat; T=Float64)
    hi = T(x)
    himd = T(x - hi)
    lomd = T(x - hi - himd)
    lo = T(x - hi - himd - lomd)
    return hi, himd, lomd, lo
end

function parts5(x::BigFloat; T=Float64)
    hi = T(x)
    himd = T(x - hi)
    mdmd = T(x - hi - himd)
    lomd = T(x - hi - himd - mdmd)
    lo = T(x - hi - himd - mdmd - lomd)
    return hi, himd, mdmd, lomd, lo
end

function whole(x::T) where {T}
    return BigFloat(x)
end

function whole(x::T, y::T) where {T}
    return BigFloat(y) + BigFloat(x)
end

function whole(x::T, y::T, z::T) where {T}
    x,y,z = sort([v,w,x,y,z], lt=(x,y)->abs(x)<abs(y))
    return BigFloat(z) + (BigFloat(y) + BigFloat(x))
end

function whole(w::T, x::T, y::T, z::T) where {T}
    w,x,y,z = sort([v,w,x,y,z], lt=(x,y)->abs(x)<abs(y))
    return BigFloat(z) + (BigFloat(y) + (BigFloat(x) + BigFloat(w))))
end

function whole(v::T, w::T, x::T, y::T, z::T) where {T}
    v,w,x,y,z = sort([v,w,x,y,z], lt=(x,y)->abs(x)<abs(y))
    return BigFloat(z) + (BigFloat(y) + (BigFloat(x) + (BigFloat(w) + BigFloat(v))))
end
