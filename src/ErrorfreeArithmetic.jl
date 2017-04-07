module ErrorfreeArithmetic


export eftSum2inOrder, eftSum3inOrder, eftSum2, eftSum3, 
       eftDiff2inOrder, eftDiff2, 
       eftSquare, eftCube,
       eftProd2, eftProd3,
       eftInv, eftDiv2, 
       eftFMA, eftFMS,
       eftSum2Cplx, eftDiff2Cplx, eftProd2Cplx


#= single parameter error-free transformations =#

# 'y' must be negated to get the right result
function eftInv{T<:AbstractFloat}(a::T)
     x = one(T) / a
     y = -(fma(x, a, -one(T)) / a)
     return x, y
end


function eftSquare{T<:AbstractFloat}(a::T)
    x = a * a
    y = fma(a, a, -x)
    return x, y
end

function eftCube{T<:AbstractFloat}(a::T)
    p = a*a; e = fma(a, a, -p)
    x = p*a; p = fma(p, a, -x)
    y = e*a
    return x, y
end

#= two parameter error-free transformations =#

function eftSum2inOrder{T<:AbstractFloat}(a::T, b::T)
  x = a + b
  y = b - (x - a)
  return x, y
end

function eftSum2{T<:AbstractFloat}(a::T, b::T)
  x = a + b
  t = x - a
  y = (a - (x - t)) + (b - t)
  return x, y
end

eftSum2{T<:AbstractFloat, R<:Real}(a::T, b::R) = eftSum2(a, convert(T,b))
eftSum2{T<:AbstractFloat, R<:Real}(a::R, b::T) = eftSum2(convert(T,a), b)
eftSum2(a::Real, b::Real) = eftSum2(float(a), float(b))

function eftDiff2inOrder{T<:AbstractFloat}(a::T, b::T)
  x = a - b
  y = (a - x) - b
  return x, y
end

function eftDiff2{T<:AbstractFloat}(a::T, b::T)
  x = a - b
  t = x - a
  y = (a - (x - t)) - (b + t)
  return x, y
end

eftDiff2{T<:AbstractFloat, R<:Real}(a::T, b::R) = eftDiff2(a, convert(T,b))
eftDiff2{T<:AbstractFloat, R<:Real}(a::R, b::T) = eftDiff2(convert(T,a), b)
eftDiff2(a::Real, b::Real) = eftDiff2(float(a), float(b))


function eftProd2{T<:AbstractFloat}(a::T, b::T)
    x = a * b
    y = fma(a, b, -x)
    return x, y
end

eftProd2{T<:AbstractFloat, R<:Real}(a::T, b::R) = eftProd2(a, convert(T, b))
eftProd2{T<:AbstractFloat, R<:Real}(a::R, b::T) = eftProd2(convert(T, a), b)
eftProd2(a::Real, b::Real) = efProd2(float(a), float(b))

#=
 div is as good as possible, not quite eft
 
"Concerning the division, the elementary rounding error is
generally not a floating point number, so it cannot be computed
exactly. Hence we cannot expect to obtain an error
free transformation for the division. ...
This means that the computed approximation is as good as
we can expect in the working precision."
-- http://perso.ens-lyon.fr/nicolas.louvet/LaLo05.pdf
 function div2{T<:AbstractFloat}(a::T, b::T)
          x = a/b
          v = x*b
          w = fma(x,b,-v)
          y = (a - v - w) / b
          x,y
       end
=#
# 'y' must be negated to get the right result
function eftDiv2{T<:AbstractFloat}(a::T,b::T)
     x = a / b
     y = -(fma(x, b,-a) / b)
     return x, y
end


#= three parameter error-free transformations =#

function eftSum3inOrder{T<:AbstractFloat}(a::T,b::T,c::T)
    s, t = eftSum2inOrder(b, c)
    x, u = eftSum2inOrder(a, s)
    y, z = eftSum2inOrder(u, t)
    x, y = eftSum2inOrder(x, y)
    return x, y, z
end

function eftSum3{T<:AbstractFloat}(a::T,b::T,c::T)
    s, t = eftSum2(b, c)
    x, u = eftSum2(a, s)
    y, z = eftSum2(u, t)
    x, y = eftSum2inOrder(x, y)
    return x, y, z
end

function eftProd3{T<:AbstractFloat}(a::T, b::T, c::T)
    p, e = eftProd2(a, b)
    x, p = eftProd2(p, c)
    y, z = eftProd2(e, c)
    return x, y, z
end

function eftFMA{T<:AbstractFloat}(a::T, b::T, c::T)
    x = fma(a, b, c)
    u1, u2 = eftProd2(a, b)
    a1, a2 = eftSum2(u2, c)
    b1, b2 = eftSum2(u1, a1)
    g = (b1 - x) + b2
    y, z = eftSum2inOrder(g, a2)
    return x, y, z
end

function eftFMS{T<:AbstractFloat}(a::T, b::T, c::T)
    x = fma(a, b, c)
    u1, u2 = eftProd2(a, b)
    a1, a2 = eftDiff2(u2, c)
    b1, b2 = eftSum2(u1, a1)
    g = (b1 - x) + b2
    y,z = eftSum2inOrder(g, a2)
    return x, y, z
end

=#
# Complex Numbers
#=
  Accurate summation, dot product and polynomial evaluation 
  in complex floating point arithmetic
  Stef Graillat ∗, Valérie Ménissier-Morain
  Information and Computation 216 (2012) 57–71
  http://web.stanford.edu/group/SOL/software/qdotdd/IC2012.pdf
=#

function eftSum2Cplx{T<:AbstractFloat}(x::Complex{T}, y::Complex{T})
    rhi, ihi = eftSum2(x.re, y.re)
    rlo, ilo = eftSum2(x.im, y.im)
    return Complex(rhi,rlo), Complex(ihi,ilo)
end

function eftDiff2Cplx{T<:AbstractFloat}(x::Complex{T}, y::Complex{T})
    rhi, ihi = eftSum2(x.re, -y.re)
    rlo, ilo = eftSum2(x.im, -y.im)
    return Complex(rhi,rlo), Complex(ihi,ilo)
end


function eftProd2Cplx{T<:AbstractFloat}(x::Complex{T}, y::Complex{T})
    z1, h1 = eftProd2(x.re, y.re)
    z2, h2 = eftProd2(x.im, y.im)
    z3, h3 = eftProd2(x.re, y.im)
    z4, h4 = eftProd2(x.im, y.re)
    
    z5, h5 = eftSum2(z1, -z2)
    z6, h6 = eftSum2(z3,  z4)
    
    return Complex(z5,z6), Complex(hi,h3), Complex(-h2,h4), Complex(h5,h6)
end

end # module
