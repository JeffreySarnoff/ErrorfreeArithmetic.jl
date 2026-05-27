
using Test
@testset "two_sum" begin
    # Exactness via BigFloat oracle, across magnitudes.
    for (a, b) in ((1.0, 1e-20), (1e300, 1e-300), (0.3, 0.6),
                   (floatmin(Float64), floatmin(Float64)),
                   (nextfloat(0.0), nextfloat(0.0)))   # subnormal range
        s, e = two_sum(a, b)
        @test big(s) + big(e) == big(a) + big(b)       # exact, incl. subnormal
    end
    # Overflow → correctly signed Inf, no spurious NaN.
    @test two_sum(prevfloat(Inf), prevfloat(Inf)) === (Inf, 0.0)
    @test two_sum(-prevfloat(Inf), -prevfloat(Inf)) === (-Inf, 0.0)
    # Genuine NaN preserved.
    @test (s = first(two_sum(NaN, 1.0)); isnan(s))
    # Type genericity.
    @test two_sum(1.0f0, 2.0f0) isa Tuple{Float32,Float32}
    @test two_sum(Float16(1), Float16(2)) isa Tuple{Float16,Float16}
end

using Test
@testset "two_hilo_sum" begin
    for (a, b) in ((1.0, 1e-20), (1e300, 1e-300),
                   (floatmin(Float64), nextfloat(0.0)))   # |a| ≥ |b|
        s, e = two_hilo_sum(a, b)
        @test big(s) + big(e) == big(a) + big(b)          # exact, incl. subnormal
    end
    @test two_hilo_sum(prevfloat(Inf), prevfloat(Inf)) === (Inf, 0.0)
    @test two_hilo_sum(-prevfloat(Inf), -1.0) === (-Inf, 0.0)
    @test (s = first(two_hilo_sum(NaN, 1.0)); isnan(s))
    @test_throws ArgumentError two_hilo_sum(1.0, 2.0)     # precondition enforced
    @test (@inbounds two_hilo_sum(1.0, 2.0)) isa Tuple    # check elided, no throw
    @test two_hilo_sum(1.0f0, 0.5f0) isa Tuple{Float32,Float32}
end

using Test
@testset "two_diff" begin
    # Exactness via BigFloat oracle, across magnitudes incl. subnormal.
    for (a, b) in ((1.0, 1e-20), (1e300, 1e-300), (0.3, 0.1),
                   (floatmin(Float64), -floatmin(Float64)),
                   (nextfloat(0.0), -nextfloat(0.0)))   # subnormal range
        s, e = two_diff(a, b)
        @test big(s) + big(e) == big(a) - big(b)        # exact, incl. subnormal
    end
    # Sterbenz cancellation: difference is exact, error term is zero.
    for x in (1.0, 1e100, 1e-100, floatmin(Float64))
        s, e = two_diff(nextfloat(x), x)
        @test e === 0.0 && big(s) == big(nextfloat(x)) - big(x)
    end
    # Overflow → correctly signed Inf, no spurious NaN.
    @test two_diff(prevfloat(Inf), -prevfloat(Inf)) === (Inf, 0.0)
    @test two_diff(-prevfloat(Inf), prevfloat(Inf)) === (-Inf, 0.0)
    # Genuine NaN preserved.
    @test (s = first(two_diff(NaN, 1.0)); isnan(s))
    # Type genericity.
    @test two_diff(1.0f0, 2.0f0) isa Tuple{Float32,Float32}
    @test two_diff(Float16(1), Float16(2)) isa Tuple{Float16,Float16}
end

using Test
@testset "two_hilo_diff" begin
    # Exactness via BigFloat oracle, |a| ≥ |b|, across magnitudes.
    for (a, b) in ((1.0, 1e-20), (1e300, 1e-300),
                   (floatmin(Float64), nextfloat(0.0)))   # subnormal range
        s, e = two_hilo_diff(a, b)
        @test big(s) + big(e) == big(a) - big(b)          # exact, incl. subnormal
    end
    # Sterbenz cancellation: difference exact, error term zero.
    for x in (1.0, 1e100, 1e-100, floatmin(Float64))
        s, e = two_hilo_diff(nextfloat(x), x)
        @test e === 0.0 && big(s) == big(nextfloat(x)) - big(x)
    end
    # Overflow → correctly signed Inf, no spurious NaN.
    @test two_hilo_diff(prevfloat(Inf), -prevfloat(Inf)) === (Inf, 0.0)
    @test two_hilo_diff(-prevfloat(Inf), prevfloat(Inf)) === (-Inf, 0.0)
    # Genuine NaN preserved.
    @test (s = first(two_hilo_diff(NaN, 1.0)); isnan(s))
    # Precondition: enforced by default, elidable under @inbounds.
    @test_throws ArgumentError two_hilo_diff(1.0, 2.0)
    @test (@inbounds two_hilo_diff(1.0, 2.0)) isa Tuple
    # Type genericity.
    @test two_hilo_diff(1.0f0, 0.5f0) isa Tuple{Float32,Float32}
    @test two_hilo_diff(Float16(2), Float16(1)) isa Tuple{Float16,Float16}
end

