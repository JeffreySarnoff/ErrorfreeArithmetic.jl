function isfaithful(a::T, b::T) where {T}
    a === b || a === nextfloat(b) || a === prevfloat(b)
end

function isequivalent(a::T, b::T, aa:T, bb::T)
    (a === aa && b === bb) || (BigFloat(a) + BigFloat(b) === BigFloat(aa) + BigFloat(bb))
end
function isequivalent(a::T, b::T, c::T, aa:T, bb::T, cc::T)
    (a === aa && b === bb && c === cc) || (BigFloat(a) + BigFloat(b) + BigFloat(c) === BigFloat(aa) + BigFloat(bb) + BigFloat(cc))
end
function isequivalent(a::T, b::T, c::T, d::T, aa:T, bb::T, cc::T, dd::T)
    (a === aa && b === bb && c === cc && d === dd) || (BigFloat(a) + BigFloat(b) + BigFloat(c) === BigFloat(aa) + BigFloat(bb) + BigFloat(cc) + BigFloat(dd))
end

maxmags(a::T, b::T) where {T} = abs(a) < abs(b) ? (b,a) : (a,b)

function test_two_hilo_sum(a::T, b::T) where {T}
    a, b = maxmags(a,b)
    hi, lo = two_hilo_sum(a, b)
    high, low = calc_two_sum(a, b)
    isequivalent(hi, lo, high, low)
end

function test_two_hilo_diff(a::T, b::T) where {T}
    a, b = maxmags(a,b)
    hi, lo = two_hilo_diff(a, b)
    high, low = calc_two_diff(a, b)
    isequivalent(hi, lo, high, low)
end

function test_one_sum(a::T, b::T) where {T}
    hi = one_sum(a, b)
    high = calc_one_sum(a, b)
    hi === high
end

function test_two_sum(a::T, b::T) where {T}
    hi, lo = two_sum(a, b)
    high, low = calc_two_sum(a, b)
    isequivalent(hi, lo, high, low)
end

function test_two_diff(a::T, b::T) where {T}
    hi, lo = two_diff(a, b)
    high, low = calc_two_diff(a, b)
    isequivalent(hi, lo, high, low)
end

function test_two_square(a::T) where {T}
    hi, lo = two_square(a)
    high, low = calc_two_square(a)     
    isequivalent(hi, lo, high, low)
end

function test_two_cube(a::T) where {T}
    hi, lo = two_cube(a)
    high, low = calc_two_cube(a)     
    isequivalent(hi, lo, high, low)
end

function test_two_prod(a::T, b::T) where {T}
    hi, lo = two_prod(a, b)
    high, low = calc_two_prod(a, b)
    isequivalent(hi, lo, high, low)
end

function test_one_sum(a::T, b::T, c::T) where {T}
    hi = one_sum(a, b, c)
    high = calc_one_sum(a, b, c)
    hi === high
end

function test_two_sum(a::T, b::T, c::T) where {T}
    hi, lo = two_sum(a, b, c)
    high, low = calc_two_sum(a, b, c)
    isequivalent(hi, lo, high, low)
end

function test_two_diff(a::T, b::T, c::T) where {T}
    hi, lo = two_diff(a, b, c)
    high, low = calc_two_diff(a, b, c)
    isequivalent(hi, lo, high, low)
end

function test_two_prod(a::T, b::T, c::T) where {T}
    hi, lo = two_prod(a, b, c)
    high, low = calc_two_prod(a, b, c)
    isequivalent(hi, lo, high, low)
end

function test_three_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_sum(a, b, c)
    high, mid, low = calc_three_sum(a, b, c)
    isequivalent(hi, md, lo, high, mid, low)
end

function test_three_diff(a::T, b::T, c::T) where {T}
    hi, md, lo = three_diff(a, b, c)
    high, mid, low = calc_three_diff(a, b, c)
    isequivalent(hi, md, lo, high, mid, low)
end

function test_three_prod(a::T, b::T, c::T) where {T}
    hi, md, lo = three_prod(a, b, c)
    high, mid, low = calc_three_prod(a, b, c)
    isequivalent(hi, md, lo, high, mid, low)
end


function test_one_sum(a::T, b::T, c::T, d::T) where {T}
    hi = one_sum(a, b, c, d)
    high = calc_one_sum(a, b, c, d)
    hi === high
end

function test_two_sum(a::T, b::T, c::T, d::T) where {T}
    x, y = two_sum(a, b, c, d)
    aa, bb = calc_two_sum(a, b, c, d)
    isequivalent(hi, lo, high, low)
end

function test_three_sum(a::T, b::T, c::T, d::T) where {T}
    hi, md, lo = three_sum(a, b, c, d)
    high, mid, low = calc_three_sum(a, b, c, d)
    isequivalent(hi, md, lo, high, mid, low)
end

function test_four_sum(a::T, b::T, c::T, d::T) where {T}
    w, x, y, z = four_sum(a, b, c, d)
    aa, bb, cc, dd = calc_four_sum(a, b, c, d)
    isequivalent(w,x,y,z, aa,bb,cc,dd)
end

function test_two_sqrt(a::T) where {T}
    hi, lo = two_sqrt(a)
    high, low = calc_two_sqrt(a)     
    hi === high && isfaithful(lo, low)
end

function test_two_inv(a::T) where {T}
    hi, lo = two_inv(a)
    high, low = calc_two_inv(a)     
    hi === high && isfaithful(lo, low)
end

function test_two_div(a::T, b::T) where {T}
    hi, lo = two_div(a, b)
    high, low = calc_two_div(a, b)     
    hi === high && isfaithful(lo, low)
end
