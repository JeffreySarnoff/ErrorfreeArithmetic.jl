a = sqrt(2.0)
b = sqrt(987654.0)
c = cbrt(2.0)
d = cbrt(987654.0)

x, y = two_sum(a, b)
@test x == a + b && x + y == x
x, y = two_sum(a, b, c)
@test x == a + b + c && x + y == x
x, y = two_sum(a, b, c, d)
@test x == a + b + c + d && x + y == x

x, y = two_diff(a, b)
@test x == a - b && x + y == x
x, y = two_diff(a, b, c)
@test x == a - b - c&& x + y == x
x, y = two_diff(a, b, c, d)
@test x == a - b - c - d && x + y == x

x, y = two_square(a)
@test x == a * a && x + y == x

x, y = two_prod(a, b)
@test x == a * b && x + y == x

x, y = two_inv(a)
@test prevfloat(inv(a)) <= x <= nextfloat(inv(a)) && x + y == x

x, y = two_div(a, b)
@test prevfloat(a/b) <= x <= nextfloat(a/b) && x + y == x

#=
@test test_two_sqrt(b)

@test test_three_sum(a, b, c)
@test test_three_diff(a, b, c)
@test test_three_prod(a, b, c)
=#
