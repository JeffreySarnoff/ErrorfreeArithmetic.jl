function isfaithful(a::T, b::T) where {T}
    a === b || a === nextfloat(b) || a === prevfloat(b)
end

maxmags(a::T, b::T) where {T} = abs(a) < abs(b) ? (b,a) : (a,b)

function test_two_hilo_sum(a::T, b::T) where {T}
    a, b = maxmags(a,b)
    hi, lo = two_hilo_sum(a, b)
    high, low = calc_two_sum(a, b)
    hi === high && lo === low
end

function test_two_hilo_diff(a::T, b::T) where {T}
    a, b = maxmags(a,b)
    hi, lo = two_hilo_diff(a, b)
    high, low = calc_two_diff(a, b)
    hi === high && lo === low
end

function test_one_sum(a::T, b::T) where {T}
    hi = one_sum(a, b)
    high = calc_one_sum(a, b)
    hi === high
end

function test_two_sum(a::T, b::T) where {T}
    hi, lo = two_sum(a, b)
    high, low = calc_two_sum(a, b)
    hi === high && lo === low
end

function test_two_diff(a::T, b::T) where {T}
    hi, lo = two_diff(a, b)
    high, low = calc_two_diff(a, b)
    hi === high && lo === low
end

function test_two_square(a::T) where {T}
    hi, lo = two_square(a)
    high, low = calc_two_square(a)     
    hi === high && lo === low
end

function test_two_cube(a::T) where {T}
    hi, lo = two_cube(a)
    high, low = calc_two_cube(a)     
    hi === high && lo === low
end

function test_two_prod(a::T, b::T) where {T}
    hi, lo = two_prod(a, b)
    high, low = calc_two_prod(a, b)
    hi === high && lo === low
end

function test_one_sum(a::T, b::T, c::T) where {T}
    hi = one_sum(a, b, c)
    high = calc_one_sum(a, b, c)
    hi === high
end

function test_two_sum(a::T, b::T, c::T) where {T}
    hi, lo = two_sum(a, b, c)
    high, low = calc_two_sum(a, b, c)
    hi === high && lo === low
end

function test_two_diff(a::T, b::T, c::T) where {T}
    hi, lo = two_diff(a, b, c)
    high, low = calc_two_diff(a, b, c)
    hi === high && lo === low
end

function test_two_prod(a::T, b::T, c::T) where {T}
    hi, lo = two_prod(a, b, c)
    high, low = calc_two_prod(a, b, c)
    hi === high && lo === low
end

function test_three_sum(a::T, b::T, c::T) where {T}
    hi, md, lo = three_sum(a, b, c)
    high, mid, low = calc_three_sum(a, b, c)
    hi === high && md === mid && lo === low
end

function test_three_diff(a::T, b::T, c::T) where {T}
    hi, md, lo = three_diff(a, b, c)
    high, mid, low = calc_three_diff(a, b, c)
    hi === high && md === mid && lo === low
end

function test_three_prod(a::T, b::T, c::T) where {T}
    hi, md, lo = three_prod(a, b, c)
    high, mid, low = calc_three_prod(a, b, c)
    hi === high && md === mid && lo === low
end


function test_one_sum(a::T, b::T, c::T, d::T) where {T}
    hi = one_sum(a, b, c, d)
    high = calc_one_sum(a, b, c, d)
    hi === high
end

function test_two_sum(a::T, b::T, c::T, d::T) where {T}
    x, y = two_sum(a, b, c, d)
    aa, bb = calc_two_sum(a, b, c, d)
    x === aa && y == bb
end

function test_three_sum(a::T, b::T, c::T, d::T) where {T}
    x, y, z = three_sum(a, b, c, d)
    aa, bb, cc = calc_three_sum(a, b, c, d)
    x === aa && y === bb && z === cc
end

function test_four_sum(a::T, b::T, c::T, d::T) where {T}
    w, x, y, z = four_sum(a, b, c, d)
    aa, bb, cc, dd = calc_four_sum(a, b, c, d)
    w === aa && x === bb && y === cc && z === dd
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
