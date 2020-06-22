@testset "two_sum" begin
  for i in 1:trials
    overlap = rand(-2:20)
    shift = rand(-18:18)
    aa, bb = tworands_hi2lo(overlap, shift=shift)
    p = permute2(aa, bb)
    ab = two_sum.(p)
    xy = correct_two_sum.(p)
    @test ab == xy
  end
end

@testset "two_sum of 3" begin
  for i in 1:trials
    overlap = rand(-2:9)
    shift = rand(-18:18)
    aa, bb, cc = threerands_hi2lo(overlap, shift=shift)
    p = permute3(aa, bb, cc)
    ab = two_sum.(p)
    xy = correct_two_sum.(p)
    @test ab == xy
  end
end

#=
@testset "two_sum of 4" begin
  for i in 1:trials
    overlap = rand(-2:25)
    shift = rand(-18:18)
    aa, bb, cc, dd = fourrands_hi2lo(overlap, shift=shift)
    p = permute4(aa, bb, cc, dd)
    ab = two_sum.(p)
    xy = correct_two_sum.(p)
    @test ab == xy
  end
end
=#

@testset "three_sum" begin
  for i in 1:trials
    overlap = rand(-2:9)
    shift = rand(-18:18)
    aa, bb, cc = threerands_hi2lo(overlap, shift=shift)
    p = permute3(aa, bb, cc)
    ab = three_sum.(p)
    xy = correct_three_sum.(p)
    @test ab == xy
  end
end

@testset "three_sum of 4" begin
  for i in 1:trials
    overlap = rand(-2:7)
    shift = rand(-18:18)
    aa, bb, cc, dd = fourrands_hi2lo(overlap, shift=shift)
    p = permute4(aa, bb, cc, dd)
    ab = three_sum.(p)
    xy = correct_three_sum.(p)
    @test ab == xy
  end
end


@testset "four_sum" begin
  for i in 1:trials
    overlap = rand(-2:6)
    shift = rand(-18:18)
    aa, bb, cc, dd = fourrands_hi2lo(overlap, shift=shift)
    p = permute4(aa, bb, cc, dd)
    ab = four_sum.(p)
    xy = correct_four_sum.(p)
    @test ab == xy
  end
end
