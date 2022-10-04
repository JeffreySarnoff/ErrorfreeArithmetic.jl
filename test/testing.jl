const NTRIALS = 1024
const EXPMAXS = (2, 4, 16, 32, 64, 96)

trials1 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
trials2 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
trials3 = reshape(zeros(Float64, NTRIALS * length(EXPMAXS)), NTRIALS, length(EXPMAXS))
  
for i in 1:length(EXPMAXS)
    for j in 1:NTRIALS
        rands = floatrand(3; expmax=EXPMAXS[i])
        trials1[i][j] = rands[1]
        trials2[i][j] = rands[2]
        trials3[i][j] = rands[3]
    end
end
  
  
for F in (:test_two_inv, :test_two_sqrt, :test_two_square)
  @eval begin
    for i in 1:length(EXPMAXS)
      for j in 1:NTRIALS
         tf = $F(trials1[i][j], trials2[i][j])
         if !tf
            println("i = $i, j = $j, t1 = $(trials1[i][j]), t2 = $(trials1[i][j]), fn = $($F)")
            break
         end 
      end
    end
  end
end

    
for F in (:test_two_sum, :test_two_diff, :test_two_prod,:test_two_div)
