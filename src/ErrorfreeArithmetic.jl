module ErrorfreeArithmetic

export add_inorder_errorfree, subtract_inorder_errorfree,
       add_errorfree, subtract_errorfree, 
       square_errorfree,  multiply_errorfree,
       inv_errorfree, 
       fma_errorfree, fms_errorfree,
       divide_accurately, sqrt_accurately, invsqrt_accurately


const SysFloat = Union{Float64, Float32}  # fma must work

#= single parameter error-free transformations =#

# 'y' must be negated to get the right result
function inv_errorfree(a::T) where T<:SysFloat
     x = one(T) / a
     y = -(fma(x, a, -one(T)) / a)
     y = ifelse(y === -zero(T), zero(T), y)       
     return x, y
end


function square_errorfree(a::T) where T<:SysFloat
    x = a * a
    y = fma(a, a, -x)
    return x, y
end

#= !!FIX ME!!
function cube_errorfree{T<:SysFloat}(a::T)
    p = a*a; e = fma(a, a, -p)
    x = p*a; p = fma(p, a, -x)
    y = p*a
    return x, y
end
=#

#= two parameter error-free transformations =#

function add_inorder_errorfree(a::T, b::T) where T<:SysFloat
  x = a + b
  y = b - (x - a)
  return x, y
end

function add_errorfree(a::T, b::T) where T<:SysFloat
  x = a + b
  t = x - a
  y = (a - (x - t)) + (b - t)
  return x, y
end

add_errorfree(a::T, b::R) where {T<:SysFloat, R<:Real} = add_errorfree(a, convert(T,b))
add_errorfree(a::R, b::T) where {T<:SysFloat, R<:Real} = add_errorfree(convert(T,a), b)
add_errorfree(a::Real, b::Real) = add_errorfree(float(a), float(b))

function subtract_inorder_errorfree(a::T, b::T) where T<:SysFloat
  x = a - b
  y = (a - x) - b
  return x, y
end

function subtract_errorfree(a::T, b::T) where T<:SysFloat
  x = a - b
  t = x - a
  y = (a - (x - t)) - (b + t)
  return x, y
end

subtract_errorfree(a::T, b::R) where {T<:SysFloat, R<:Real} = subtract_errorfree(a, convert(T,b))
subtract_errorfree(a::R, b::T) where {T<:SysFloat, R<:Real} = subtract_errorfree(convert(T,a), b)
subtract_errorfree(a::Real, b::Real) = subtract_errorfree(float(a), float(b))


function multiply_errorfree(a::T, b::T) where T<:SysFloat
    x = a * b
    y = fma(a, b, -x)
    return x, y
end

multiply_errorfree(a::T, b::R) where {T<:SysFloat, R<:Real} = multiply_errorfree(a, convert(T, b))
multiply_errorfree(a::R, b::T) where {T<:SysFloat, R<:Real} = multiply_errorfree(convert(T, a), b)
multiply_errorfree(a::Real, b::Real) = multiply_errorfree(float(a), float(b))

#=
 divide is as good as possible, not quite errorfree
 
"Concerning the division, the elementary rounding error is
generally not a floating point number, so it cannot be computed
exactly. Hence we cannot expect to obtain an error
free transformation for the divideision. ...
This means that the computed approximation is as good as
we can expect in the working precision."
-- http://perso.ens-lyon.fr/nicolas.louvet/LaLo05.pdf
 function divide{T<:SysFloat}(a::T, b::T)
          x = a/b
          v = x*b
          w = fma(x,b,-v)
          y = (a - v - w) / b
          x,y
       end
=#
# 'y' (iff nonzero) must be negated to get the right result
function divide_accurately(a::T,b::T) where T<:SysFloat
     x = a / b
     y = -(fma(x, b,-a) / b)
     y = ifelse(y === -zero(T), zero(T), y)
     return x, y
end

# 'y' (iff nonzero) must be negated to get the right result
function inverse_accurately(b::T) where T<:SysFloat
   x = inv( b )
   y = -(fma(x, b,-one(T)) / b)
   y = ifelse(y === -zero(T), zero(T), y)
   return x, y
end


#=
   While not strictly an error-free transformation it is quite reliable and recommended for use.
   Augmented precision square roots, 2-D norms and discussion on correctly reounding sqrt(x^2 + y^2)
   by Nicolas Brisebarre, Mioara Joldes, Erik Martin-Dorel, Hean-Michel Muller, Peter Kornerup
=#
function sqrt_accurately(a::T) where T<:SysFloat
     x = sqrt(a)
     t = fma(x, -x, a)
     y = t / (x+x)
     return x, y
end 

function invsqrt_accurately(a::T) where T<:SysFloat
     r = inv(a)
     x = sqrt(r) 
     t = fma(x, -x, r)
     y = t / (x+x)
     return x, y
end


#= three parameter error-free transformations =#

function add_inorder_errorfree(a::T,b::T,c::T) where T<:SysFloat
    s, t = add_inorder_errorfree(b, c)
    x, u = add_inorder_errorfree(a, s)
    y, z = add_inorder_errorfree(u, t)
    x, y = add_inorder_errorfree(x, y)
    return x, y, z
end

function add_errorfree(a::T,b::T,c::T) where T<:SysFloat
    s, t = add_errorfree(b, c)
    x, u = add_errorfree(a, s)
    y, z = add_errorfree(u, t)
    x, y = add_inorder_errorfree(x, y)
    return x, y, z
end

function multiply_errorfree(a::T, b::T, c::T) where T<:SysFloat
    p, e = multiply_errorfree(a, b)
    x, p = multiply_errorfree(p, c)
    y, z = multiply_errorfree(e, c)
    return x, y, z
end

function fma_errorfree(a::T, b::T, c::T) where T<:SysFloat
    x = fma(a, b, c)
    u1, u2 = multiply_errorfree(a, b)
    a1, a2 = add_errorfree(u2, c)
    b1, b2 = add_errorfree(u1, a1)
    g = (b1 - x) + b2
    y, z = add_inorder_errorfree(g, a2)
    return x, y, z
end

function fms_errorfree(a::T, b::T, c::T) where T<:SysFloat
    x = fma(a, b, c)
    u1, u2 = multiply_errorfree(a, b)
    a1, a2 = subtract_errorfree(u2, c)
    b1, b2 = add_errorfree(u1, a1)
    g = (b1 - x) + b2
    y,z = add_inorder_errorfree(g, a2)
    return x, y, z
end


# Complex Numbers
#=
  Accurate addition, dot multiply and polynomial evaluation 
  in complex floating point arithmetic
  Stef Graillat ∗, Valérie Ménissier-Morain
  Information and Computation 216 (2012) 57–71
  http://web.stanford.edu/group/SOL/software/qdotdd/IC2012.pdf
=#

function add_errorfree(x::Complex{T}, y::Complex{T}) where T<:SysFloat
    rhi, ihi = add_errorfree(x.re, y.re)
    rlo, ilo = add_errorfree(x.im, y.im)
    return Complex(rhi,rlo), Complex(ihi,ilo)
end

function subtract_errorfree(x::Complex{T}, y::Complex{T}) where T<:SysFloat
    rhi, ihi = add_errorfree(x.re, -y.re)
    rlo, ilo = add_errorfree(x.im, -y.im)
    return Complex(rhi,rlo), Complex(ihi,ilo)
end


function multiply_errorfree(x::Complex{T}, y::Complex{T}) where T<:SysFloat
    z1, h1 = multiply_errorfree(x.re, y.re)
    z2, h2 = multiply_errorfree(x.im, y.im)
    z3, h3 = multiply_errorfree(x.re, y.im)
    z4, h4 = multiply_errorfree(x.im, y.re)
    
    z5, h5 = add_errorfree(z1, -z2)
    z6, h6 = add_errorfree(z3,  z4)
    
    return Complex(z5,z6), Complex(h1,h3), Complex(-h2,h4), Complex(h5,h6)
end


end # module
