module ErrorfreeArithmetic


export eeftSum2inOrder, eftSum3inOrder, eftSum2, eftSum3, 
       eftDiff2inOrder, eftDiff2, 
       eftSquare, eftCube,
       eftProd2, eftProd3,
       eftInv, eftFMA, eftFMS,
       eftSum2Cplx, eftDiff2Cplx, eftProd2Cplx

using Polynomials

include("errorfree_transforms.jl")

end # module
