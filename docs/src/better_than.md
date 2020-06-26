```
julia> a,b,c
(1.4142135623730952e12, 1.4142135623730951, 1.414213562373095e-16)

julia> abc=BigFloat(a)*BigFloat(b)*BigFloat(c);hi=F(abc);md=F(abcd-hi);lo=F(abcd-hi-md);hi,md, lo
(0.00028284271247461907, -0.00028284271247461907, 4.000000000000001e-33)

julia>

julia> function threeprod(x1::T, x2::T, x3::T) where {T}
          s1, s2, s3, s4 = four_sum_three_product(x1, x2, x3)
          s2, s3 = two_hilo_sum(s2, s3)
          s3 += s4
          return s1, s2, s3
       end
threeprod (generic function with 1 method)

julia>

julia> function four_sum_three_product(x1::T, x2::T, x3::T) where {T}
           thi, tlo = two_prod(x2, x3)
           s1, s2 = two_prod(x1, thi)
               s3, s4 = two_prod(x1, tlo)
           return s1, s2, s3, s4
       end
four_sum_three_product (generic function with 1 method)

julia>

julia> function three_prod(a::T, b::T, c::T) where {T}
           abhi, ablo = two_prod(a, b)
           hi, abhiclo = two_prod(abhi, c)
           ablochi, abloclo = two_prod(ablo, c)
           md, lo, tmp  = three_sum(ablochi, abhiclo, abloclo)
           hi, md = two_sum(hi, md)
           return hi, md, lo
       end
three_prod (generic function with 2 methods)

julia>

julia> hi,md,lo
(0.00028284271247461907, -0.00028284271247461907, 4.000000000000001e-33)

julia> threeprod(a,b,c)
(0.00028284271247461907, 5.521969670017276e-21, 3.194755608030214e-37)

julia> three_prod(a,b,c)
(0.00028284271247461907, 5.521969670017276e-21, 3.194755608030214e-37)

julia> three_prod(c,b,a)
(0.00028284271247461907, 5.521969670017276e-21, 3.194755608030214e-37)

julia> threeprod(c,b,a)
(0.00028284271247461907, 5.521969670017275e-21, 1.0717919453292854e-36)

```
