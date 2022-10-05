using Combinatorics

# how many distinct permutations of k items
npermutations(k) = length(permutations(1:k))
permutes(n) = collect(permutations(1:n))

const perms = [permutes(n) for n in 1:6]
