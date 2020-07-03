## Exact Representations

Let _T_ be an IEEE754 conformant floating point type.
Let _integer_ be an integer with |_intnum_| <= maxintfloat(T)
Let _rational_ be a rational with 
 - abs(numerator) in 0:2^significand_bits(T) 
 - denominator in 2^1:2^signficand_bits(T)

T(_integer_) encodes _integer_ exactly (without error)
T(_rational_) encodes _rational_ exactly (without error)

For all other integer and all other rational values, the representation is inexact.


A floating point value 𝑓𝑙 ℱ ��

represents a real number exactly when is _represented exactly_ when 

## Representation Error



## Exact Rounding (to nearest even)



## Faithful Rounding (
