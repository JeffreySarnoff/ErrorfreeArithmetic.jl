function badrands(rands)
    any( map(x->abs(exponent(diff(sort(rands)))), rands) .> 104 )
end

const NTRIALS = 1024
const EXPMAXS = (0, 2, 4, 16, 64, 96)

trials1 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
trials2 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
trials3 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
trials4 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
trials5 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))

for i in 1:NTRIALS
    for j in 1:length(EXPMAXS)
        expmax = EXPMAXS[j]
        rands = randfloatsx(5; expmax)
        while badrands(rands)
            rands = randfloatsx(5; expmax)
        end
        trials1[i,j] = rands[1]
        trials2[i,j] = rands[2]
        trials3[i,j] = rands[3]
        trials4[i,j] = rands[4]
        trials5[i,j] = rands[5]
    end
end

tf = true

for F in (:test_two_inv, :test_two_sqrt, :test_two_square)
  @eval begin
    for i in 1:NTRIALS
      for j in 1:length(EXPMAXS)
         global tf = $F(trials1[i,j])
         if !tf
            println("$($F)($(trials1[i,j]))")
            break
         end 
      end
      !tf && break
    end
  end
end

for F in (:test_one_sum, :test_two_hilo_sum, :test_two_hilo_diff, :test_two_sum, :test_two_diff, :test_two_prod, :test_two_div)
  @eval begin
    for i in 1:NTRIALS
      for j in 1:length(EXPMAXS)
         global tf = $F(trials1[i,j], trials2[i,j])
         if !tf
            println("$($F)($(trials1[i,j]), $(trials2[i,j]))")
            break
         end 
      end
      !tf && break
    end
  end
end

for F in (:test_one_sum, :test_two_sum, :test_two_diff, :test_two_prod, :test_three_sum, :test_three_diff, :test_three_prod)
  @eval begin
    for i in 1:NTRIALS
      for j in 1:length(EXPMAXS)
         global tf = $F(trials1[i,j], trials2[i,j], trials3[i,j])
         if !tf
            println("$($F)($(trials1[i,j]), $(trials2[i,j]), $(trials3[i,j]))")
            break
         end 
      end
      !tf && break
    end
  end
end

for F in (:test_one_sum, :test_two_sum, :test_three_sum, :test_four_sum)
  @eval begin
    for i in 1:NTRIALS
      for j in 1:length(EXPMAXS)
         global tf = $F(trials1[i,j], trials2[i,j], trials3[i,j], trials4[i,j])
         if !tf
            println("$($F)($(trials1[i,j]), $(trials2[i,j]), $(trials3[i,j]), $(trials4[i,j]))")
            break
         end 
      end
      !tf && break
    end
  end
end

