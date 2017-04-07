module ErrorfreeArithmetic


export errorfree_sum2_inorder, errorfree_sum3_inorder,
       errorfree_sum2, errorfree_sum3, 
       errorfree_diff2_inorder, errorfree_diff2, 
       errorfree_square, errorfree_cube,
       errorfree_prod2, errorfree_prod3,
       errorfree_inv, errorfree_div2, 
       errorfree_fma, errorfree_fms

#= single parameter error-free transformations =#

# 'y' must be negated to get the right result
function errorfree_inv{T<:AbstractFloat}(a::T)
     x = one(T) / a
     y = -(fma(x, a, -one(T)) / a)
     return x, y
end


function errorfree_square{T<:AbstractFloat}(a::T)
    x = a * a
    y = fma(a, a, -x)
    return x, y
end

function errorfree_cube{T<:AbstractFloat}(a::T)
    p = a*a; e = fma(a, a, -p)
    x = p*a; p = fma(p, a, -x)
    y = e*a
    return x, y
end

#= two parameter error-free transformations =#

function errorfree_sum2_inorder{T<:AbstractFloat}(a::T, b::T)
  x = a + b
  y = b - (x - a)
  return x, y
end

function errorfree_sum2{T<:AbstractFloat}(a::T, b::T)
  x = a + b
  t = x - a
  y = (a - (x - t)) + (b - t)
  return x, y
end

errorfree_sum2{T<:AbstractFloat, R<:Real}(a::T, b::R) = errorfree_sum2(a, convert(T,b))
errorfree_sum2{T<:AbstractFloat, R<:Real}(a::R, b::T) = errorfree_sum2(convert(T,a), b)
errorfree_sum2(a::Real, b::Real) = errorfree_sum2(float(a), float(b))

function errorfree_diff2_inorder{T<:AbstractFloat}(a::T, b::T)
  x = a - b
  y = (a - x) - b
  return x, y
end

function errorfree_diff2{T<:AbstractFloat}(a::T, b::T)
  x = a - b
  t = x - a
  y = (a - (x - t)) - (b + t)
  return x, y
end

errorfree_diff2{T<:AbstractFloat, R<:Real}(a::T, b::R) = errorfree_diff2(a, convert(T,b))
errorfree_diff2{T<:AbstractFloat, R<:Real}(a::R, b::T) = errorfree_diff2(convert(T,a), b)
errorfree_diff2(a::Real, b::Real) = errorfree_diff2(float(a), float(b))


function errorfree_prod2{T<:AbstractFloat}(a::T, b::T)
    x = a * b
    y = fma(a, b, -x)
    return x, y
end

errorfree_prod2{T<:AbstractFloat, R<:Real}(a::T, b::R) = errorfree_prod2(a, convert(T, b))
errorfree_prod2{T<:AbstractFloat, R<:Real}(a::R, b::T) = errorfree_prod2(convert(T, a), b)
errorfree_prod2(a::Real, b::Real) = errorfree_prod2(float(a), float(b))

#=
 div is as good as possible, not quite errorfree_
 
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
function errorfree_Div2{T<:AbstractFloat}(a::T,b::T)
     x = a / b
     y = -(fma(x, b,-a) / b)
     return x, y
end


#= three parameter error-free transformations =#

function errorfree_sum3_inorder{T<:AbstractFloat}(a::T,b::T,c::T)
    s, t = errorfree_sum2_inorder(b, c)
    x, u = errorfree_sum2_inorder(a, s)
    y, z = errorfree_sum2_inorder(u, t)
    x, y = errorfree_sum2_inorder(x, y)
    return x, y, z
end

function errorfree_sum3{T<:AbstractFloat}(a::T,b::T,c::T)
    s, t = errorfree_sum2(b, c)
    x, u = errorfree_sum2(a, s)
    y, z = errorfree_sum2(u, t)
    x, y = errorfree_sum2_inorder(x, y)
    return x, y, z
end

function errorfree_prod3{T<:AbstractFloat}(a::T, b::T, c::T)
    p, e = errorfree_prod2(a, b)
    x, p = errorfree_prod2(p, c)
    y, z = errorfree_prod2(e, c)
    return x, y, z
end

function errorfree_fma{T<:AbstractFloat}(a::T, b::T, c::T)
    x = fma(a, b, c)
    u1, u2 = errorfree_prod2(a, b)
    a1, a2 = errorfree_sum2(u2, c)
    b1, b2 = errorfree_sum2(u1, a1)
    g = (b1 - x) + b2
    y, z = errorfree_sum2_inorder(g, a2)
    return x, y, z
end

function errorfree_fms{T<:AbstractFloat}(a::T, b::T, c::T)
    x = fma(a, b, c)
    u1, u2 = errorfree_prod2(a, b)
    a1, a2 = errorfree_diff2(u2, c)
    b1, b2 = errorfree_sum2(u1, a1)
    g = (b1 - x) + b2
    y,z = errorfree_sum2_inorder(g, a2)
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

function errorfree_sum2{T<:AbstractFloat}(x::Complex{T}, y::Complex{T})
    rhi, ihi = errorfree_sum2(x.re, y.re)
    rlo, ilo = errorfree_sum2(x.im, y.im)
    return Complex(rhi,rlo), Complex(ihi,ilo)
end

function errorfree_diff2{T<:AbstractFloat}(x::Complex{T}, y::Complex{T})
    rhi, ihi = errorfree_sum2(x.re, -y.re)
    rlo, ilo = errorfree_sum2(x.im, -y.im)
    return Complex(rhi,rlo), Complex(ihi,ilo)
end


function errorfree_prod2{T<:AbstractFloat}(x::Complex{T}, y::Complex{T})
    z1, h1 = errorfree_prod2(x.re, y.re)
    z2, h2 = errorfree_prod2(x.im, y.im)
    z3, h3 = errorfree_prod2(x.re, y.im)
    z4, h4 = errorfree_prod2(x.im, y.re)
    
    z5, h5 = errorfree_sum2(z1, -z2)
    z6, h6 = errorfree_sum2(z3,  z4)
    
    return Complex(z5,z6), Complex(hi,h3), Complex(-h2,h4), Complex(h5,h6)
end

end # module
