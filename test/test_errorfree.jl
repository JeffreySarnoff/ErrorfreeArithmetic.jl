@testset "two_sum" begin
  for i in 1:trials
    overlap = rand(-2:25)
    shift = rand(-18:18)
    aa, bb = tworands_hi2lo(overlap, shift=shift)
    p = permute2(aa, bb)
    ab = two_sum.(p)
    xy = correct_two_sum.(p)
    @test ab == xy
  end
end

@testset "three_sum" begin
end

@testset "four_sum" begin
end
