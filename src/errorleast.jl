
#=
 divide is as good as possible, not quite errorfree
 
"Concerning the division, the elementary rounding error is
generally not a floating point number, so it cannot be computed
exactly. Hence we cannot expect to obtain an error
free transformation for the divideision. ...
This means that the computed approximation is as good as
we can expect in the working precision."
-- http://perso.ens-lyon.fr/nicolas.louvet/LaLo05.pdf
=#

function errorleast_divide{T<:SysFloat}(a::T, b::T)
    hi = a/b
    v = hi*b
    w = fma(hi, b, -v)
    lo = (a - v - w) / b
    return hi, lo
end

# faster, slightly less accurate ? ~1.5ulb
function errorleast_divide_fast{T<:SysFloat}(a::T, b::T)
    hi = a/b
    v = hi*b
    w = fma(hi, b, -v)
    lo = (a - v - w) * inv(b)
    return hi, lo
end

function errorleast_divide_fast2{T<:SysFloat}(a::T, b::T)
    hi = a * inv(b)
    v = hi*b
    w = fma(hi, b, -v)
    lo = (a - v - w) * inv(b)
    return hi, lo
end
