function calc_one_sum(a::T, b::T) where {T}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa + bb
    parts1(ab; T)
end

function calc_two_sum(a::T, b::T) where {T}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa + bb
    parts2(ab; T)
end

function calc_two_diff(a::T, b::T) where {T}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa - bb
    parts2(ab; T)
end

function calc_two_prod(a::T, b::T) where {T}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa * bb
    parts2(ab; T)
end

function calc_one_sum(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa + bb + cc
    parts1(abc; T)
end

function calc_two_sum(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa + bb + cc
    parts2(abc; T)
end

function calc_two_diff(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa - bb - cc
    parts2(abc; T)
end

function calc_two_prod(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa * bb * cc
    parts2(abc; T)
end

function calc_one_sum(a::T, b::T, c::T, d::T) where {T}
    aa, bb, cc, dd = BigFloat(a), BigFloat(b), BigFloat(c), BigFloat(d)
    abcd = aa + bb + cc + dd
    parts1(abcd; T)
end

function calc_two_sum(a::T, b::T, c::T, d::T) where {T}
    aa, bb, cc, dd = BigFloat(a), BigFloat(b), BigFloat(c), BigFloat(d)
    abcd = aa + bb + cc + dd
    parts2(abcd; T)
end

function calc_three_sum(a::T, b::T, c::T, d::T) where {T}
    aa, bb, cc, dd = BigFloat(a), BigFloat(b), BigFloat(c), BigFloat(d)
    abcd = aa + bb + cc + dd
    parts3(abcd; T)
end

function calc_four_sum(a::T, b::T, c::T, d::T) where {T}
    aa, bb, cc, dd = BigFloat(a), BigFloat(b), BigFloat(c), BigFloat(d)
    abcd = aa + bb + cc + dd
    parts4(abcd; T)
end

function calc_two_square(a::T) where {T}
    aa = BigFloat(a)
    ab = aa * aa
    parts2(ab; T)
end

function calc_two_cube(a::T) where {T}
    aa = BigFloat(a)
    ab = aa * aa * aa
    parts2(ab; T)
end

function calc_two_inv(a::T) where {T}
    aa = BigFloat(a)
    ab = inv(aa)
    parts2(ab; T)
end

function calc_two_div(a::T, b::T) where {T}
    aa, bb = BigFloat(a), BigFloat(b)
    ab = aa / bb
    parts2(ab; T)
end

function calc_two_square(a::T) where {T}
    aa = BigFloat(a)
    ab = aa * aa
    parts2(ab; T)
end

function calc_two_cube(a::T) where {T}
    aa = BigFloat(a)
    ab = aa * aa * aa
    parts2(ab; T)
end

function calc_two_sqrt(a::T) where {T}
    aa = BigFloat(a)
    ab = sqrt(aa)
    parts2(ab; T)
end

function calc_two_cbrt(a::T) where {T}
    aa = BigFloat(a)
    ab = cbrt(aa)
    parts2(ab; T)
end

function calc_three_sum(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa + bb + cc
    parts3(abc; T)
end

function calc_three_diff(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa - bb - cc
    parts3(abc; T)
end

function calc_three_prod(a::T, b::T, c::T) where {T}
    aa, bb, cc = BigFloat(a), BigFloat(b), BigFloat(c)
    abc = aa * bb * cc
    parts3(abc; T)
end

