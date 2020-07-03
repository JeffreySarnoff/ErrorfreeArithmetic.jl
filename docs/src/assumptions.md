For the most part, this discussion assumes that `op(x, y)`, `op(x, y, z)`, `op(w, x, y, z)` neither overflow nor underflow. While we assume subnormal numbers are available, we note where subnormal arguments may not allow a valid error-free transformation.

[Sterbenz, Floating Point Computation: Theorem 4.3.1 and Corellary (pg 138)]
For a, b floating point numbers of the same type where subnormals are available,
  where a, b are finite, normal and nonnegative
  and a/2 <= b <= a
   or b/2 <= a <= b
  then c = a - b is exact
  
For a, b floating point numbers of the same type and of the same sign
   where subnormals are available
   where a, b are finite and normal
   and 2 * abs(a) >= abs(b) >= abs(a)/2
   then c = a - b, d = b - a are exact
  
