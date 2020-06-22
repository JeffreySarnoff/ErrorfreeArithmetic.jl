a = sqrt(2.0)
b = sqrt(987654.0)
c = cbrt(456.125)

@test test_two_sum(a, b)
@test test_two_diff(a, b)
@test test_two_square(b)
@test test_two_prod(a, b)
@test test_two_inv(b)
@test test_two_div(a, b)
@test test_two_sqrt(b)

@test test_three_sum(a, b, c)
@test test_three_diff(a, b, c)
@test test_three_prod(a, b, c)
