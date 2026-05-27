"""
    two_sum(a::T, b::T) where {T<:AbstractFloat} -> Tuple{T,T}

Error-free transformation of `a + b` (Knuth's `TwoSum`).

Returns `(s, e)` where `s = fl(a + b)` is the correctly-rounded
IEEE-754 sum and `e` is the rounding error. Whenever `s` is finite,

    a + b == s + e

holds **exactly** as real numbers, with `e` an exactly representable
floating-point value.

# Guarantees

  * **No magnitude assumption.** Correct for any finite `a` and `b`,
    including a very large operand combined with a very small one.
    Unlike [`two_hilo_sum`](@ref) there is no `|a| ≥ |b|` precondition.

  * **No underflow caveat.** Floating-point addition's error term
    satisfies `|e| ≤ ulp(s)/2`, and subnormals exactly populate that
    range, so `e` is *always* representable when `s` is finite —
    including deep in the subnormal range. This is a genuine property
    of addition; `two_sum` needs no underflow handling, unlike
    error-free transformations of multiplication or division.

  * **Overflow → signed infinity.** If `a + b` overflows, `s` is the
    correctly-signed `Inf` (the correct IEEE-754 result) and `e` is
    `zero(T)`. This suppresses the spurious `NaN` that Knuth's formula
    would otherwise produce from its internal `Inf - Inf`.

  * **Genuine `NaN` preserved.** If `a` or `b` is `NaN`, `s` is `NaN`
    and `e` is `zero(T)`; a real `NaN` is never turned into a finite
    value.

# Examples
```jldoctest
julia> two_sum(1.0, 1e-20)            # large + tiny: error captured exactly
(1.0, 1.0e-20)

julia> two_sum(prevfloat(Inf), prevfloat(Inf))   # overflow → signed Inf
(Inf, 0.0)

julia> two_sum(NaN, 1.0)              # genuine NaN preserved
(NaN, 0.0)
```
"""
@inline function two_sum(a::T, b::T) where {T<:AbstractFloat}
    s = a + b
    # The ONLY failure mode for addition's error-free transform: a
    # non-finite sum (overflow → ±Inf, or a NaN operand). `s` already
    # holds the correct IEEE-754 result; Knuth's formula below would
    # turn it into a spurious NaN via Inf - Inf, so short-circuit.
    isfinite(s) || return (s, zero(T))

    # Knuth's TwoSum. Branch-free and exact for every finite `s`, with
    # no assumption on the relative magnitudes of `a` and `b`.
    # NOTE: do NOT annotate with @fastmath — reassociating these
    # additions or assuming finiteness destroys the exactness.
    bb = s - a
    e  = (a - (s - bb)) + (b - bb)
    return (s, e)
end

# Mixed-type calls promote to a common float type, then dispatch above.
@inline two_sum(a::AbstractFloat, b::AbstractFloat) = two_sum(promote(a, b)...)

"""
    two_hilo_sum(a::T, b::T) where {T<:AbstractFloat} -> Tuple{T,T}

Fast error-free transformation of `a + b`, assuming `|a| ≥ |b|`
(Dekker's `FastTwoSum`).

Returns `(s, e)` where `s = fl(a + b)` is the correctly-rounded
IEEE-754 sum and `e` is the rounding error. Whenever the precondition
holds and `s` is finite,

    a + b == s + e

holds **exactly**, with `e` an exactly representable floating-point
value. This is the 3-operation variant of [`two_sum`](@ref); use
`two_sum` (6 operations) when the operand ordering is unknown.

# Precondition

The caller must ensure `|a| ≥ |b|` (equivalently `exponent(a) ≥
exponent(b)`, or either operand is zero). The check is a
`@boundscheck`: enabled by default, and **elided under `@inbounds`**
when the caller has already established the ordering — e.g. inside a
descending-magnitude accumulator or right after sorting the operands.
If the precondition is violated and the check is elided, `e` is
silently incorrect.

# Guarantees

  * **No underflow caveat.** Like `two_sum`, the error term satisfies
    `|e| ≤ ulp(s)/2`, and subnormals exactly populate that range, so
    `e` is always representable when `s` is finite — including deep in
    the subnormal range. No underflow handling is needed.

  * **Overflow → signed infinity.** If `a + b` overflows, `s` is the
    correctly-signed `Inf` and `e` is `zero(T)`, suppressing the
    spurious `NaN` the formula would produce from `Inf - Inf`.

  * **Genuine `NaN` preserved.** If `a` or `b` is `NaN`, `s` is `NaN`
    and `e` is `zero(T)`.

# Examples
```jldoctest
julia> two_hilo_sum(1.0, 1e-20)       # |a| ≥ |b|: error captured exactly
(1.0, 1.0e-20)

julia> @inbounds two_hilo_sum(1.0, 1e-20)   # check elided in hot code
(1.0, 1.0e-20)

julia> two_hilo_sum(1.0, 2.0)         # precondition violated → throws
ERROR: ArgumentError: two_hilo_sum requires |a| ≥ |b|
```
"""
@inline function two_hilo_sum(a::T, b::T) where {T<:AbstractFloat}
    # Precondition check, idiomatically elidable via `@inbounds`.
    # NaN operands compare false; we let them through so the
    # non-finite guard below handles them as genuine NaNs.
    @boundscheck (abs(a) ≥ abs(b) || isnan(a) || isnan(b)) ||
        throw(ArgumentError("two_hilo_sum requires |a| ≥ |b|"))

    s = a + b
    # The only failure mode: a non-finite sum (overflow → ±Inf, or a
    # NaN operand). `s` already holds the correct IEEE-754 result;
    # the formula below would turn it into a spurious NaN.
    isfinite(s) || return (s, zero(T))

    # Dekker's FastTwoSum — exact when |a| ≥ |b| and `s` is finite.
    # NOTE: do NOT annotate @fastmath — reassociation breaks exactness.
    e = b - (s - a)
    return (s, e)
end

# Mixed-type calls promote to a common float type, then dispatch above.
# `@propagate_inbounds` so a caller's `@inbounds` reaches the check above.
Base.@propagate_inbounds two_hilo_sum(a::AbstractFloat, b::AbstractFloat) =
    two_hilo_sum(promote(a, b)...)

"""
    two_diff(a::T, b::T) where {T<:AbstractFloat} -> Tuple{T,T}

Error-free transformation of `a - b` (Knuth's `TwoSum`, difference form).

Returns `(s, e)` where `s = fl(a - b)` is the correctly-rounded
IEEE-754 difference and `e` is the rounding error. Whenever `s` is
finite,

    a - b == s + e

holds **exactly** as real numbers, with `e` an exactly representable
floating-point value.

# Guarantees

  * **No magnitude assumption.** Correct for any finite `a` and `b`,
    including a very large operand minus a very small one. Unlike
    [`two_hilo_diff`](@ref) there is no `|a| ≥ |b|` precondition.

  * **No underflow caveat.** Subtraction is `a + (-b)` and negation is
    exact (a sign-bit flip), so the `two_sum` result applies verbatim:
    `|e| ≤ ulp(s)/2` and subnormals exactly populate that range, hence
    `e` is *always* representable when `s` is finite — including deep
    in the subnormal range. `two_diff` needs no underflow handling.

  * **Cancellation is exact, not an error.** When `a ≈ b` the result
    `s` is tiny, but by Sterbenz's lemma `a - b` is then computed
    *exactly*: `s` is exact and `e` is `zero(T)`. This needs no special
    path — the transformation below already yields it.

  * **Overflow → signed infinity.** If `a - b` overflows, `s` is the
    correctly-signed `Inf` (the correct IEEE-754 result) and `e` is
    `zero(T)`, suppressing the spurious `NaN` Knuth's formula would
    otherwise produce from its internal `Inf - Inf`.

  * **Genuine `NaN` preserved.** If `a` or `b` is `NaN`, `s` is `NaN`
    and `e` is `zero(T)`; a real `NaN` is never turned into a finite
    value.

# Examples
```jldoctest
julia> two_diff(1.0, 1e-20)           # large − tiny: error captured exactly
(1.0, -1.0e-20)

julia> two_diff(prevfloat(Inf), -prevfloat(Inf))   # overflow → signed Inf
(Inf, 0.0)

julia> two_diff(1.0, nextfloat(1.0))  # cancellation: exact, e == 0
(-2.220446049250313e-16, 0.0)

julia> two_diff(NaN, 1.0)             # genuine NaN preserved
(NaN, 0.0)
```
"""
@inline function two_diff(a::T, b::T) where {T<:AbstractFloat}
    s = a - b
    # The ONLY failure mode for subtraction's error-free transform: a
    # non-finite difference (overflow → ±Inf, or a NaN operand). `s`
    # already holds the correct IEEE-754 result; the formula below
    # would turn it into a spurious NaN via Inf - Inf, so short-circuit.
    isfinite(s) || return (s, zero(T))

    # Knuth's TwoSum, difference form. Branch-free and exact for every
    # finite `s`, with no assumption on the magnitudes of `a` and `b`.
    # NOTE: do NOT annotate with @fastmath — reassociating these
    # operations or assuming finiteness destroys the exactness.
    bb = s - a
    e  = (a - (s - bb)) - (b + bb)
    return (s, e)
end

# Mixed-type calls promote to a common float type, then dispatch above.
@inline two_diff(a::AbstractFloat, b::AbstractFloat) = two_diff(promote(a, b)...)

"""
    two_hilo_diff(a::T, b::T) where {T<:AbstractFloat} -> Tuple{T,T}

Fast error-free transformation of `a - b`, assuming `|a| ≥ |b|`
(Dekker's `FastTwoSum`, difference form).

Returns `(s, e)` where `s = fl(a - b)` is the correctly-rounded
IEEE-754 difference and `e` is the rounding error. Whenever the
precondition holds and `s` is finite,

    a - b == s + e

holds **exactly**, with `e` an exactly representable floating-point
value. This is the 3-operation variant of [`two_diff`](@ref); use
`two_diff` (6 operations) when the operand ordering is unknown.

# Precondition

The caller must ensure `|a| ≥ |b|` — the magnitudes of the *operands*,
not of their difference (equivalently `exponent(a) ≥ exponent(b)`, or
either operand is zero). The check is a `@boundscheck`: enabled by
default, and **elided under `@inbounds`** when the caller has already
established the ordering. If the precondition is violated and the
check is elided, `e` is silently incorrect.

# Guarantees

  * **No underflow caveat.** Like `two_diff`, `|e| ≤ ulp(s)/2` and
    subnormals exactly populate that range, so `e` is always
    representable when `s` is finite — including deep in the subnormal
    range. No underflow handling is needed.

  * **Cancellation is exact, not an error.** When `a ≈ b` the result
    `s` i

"""

"""
    two_hilo_diff(a::T, b::T) where {T<:AbstractFloat} -> Tuple{T,T}

Fast error-free transformation of `a - b`, assuming `|a| ≥ |b|`
(Dekker's `FastTwoSum`, difference form).

Returns `(s, e)` where `s = fl(a - b)` is the correctly-rounded
IEEE-754 difference and `e` is the rounding error. Whenever the
precondition holds and `s` is finite,

    a - b == s + e

holds **exactly**, with `e` an exactly representable floating-point
value. This is the 3-operation variant of [`two_diff`](@ref); use
`two_diff` (6 operations) when the operand ordering is unknown.

# Precondition

The caller must ensure `|a| ≥ |b|` — the magnitudes of the *operands*,
not of their difference (equivalently `exponent(a) ≥ exponent(b)`, or
either operand is zero). The check is a `@boundscheck`: enabled by
default, and **elided under `@inbounds`** when the caller has already
established the ordering. If the precondition is violated and the
check is elided, `e` is silently incorrect.

# Guarantees

  * **No underflow caveat.** Like `two_diff`, `|e| ≤ ulp(s)/2` and
    subnormals exactly populate that range, so `e` is always
    representable when `s` is finite — including deep in the subnormal
    range. No underflow handling is needed.

  * **Cancellation is exact, not an error.** When `a ≈ b` the result
    `s` is tiny, but by Sterbenz's lemma `a - b` is then computed
    *exactly*: `s` is exact and `e` is `zero(T)`. No special path.

  * **Overflow → signed infinity.** If `a - b` overflows, `s` is the
    correctly-signed `Inf` and `e` is `zero(T)`, suppressing the
    spurious `NaN` the formula would produce from `Inf - Inf`.

  * **Genuine `NaN` preserved.** If `a` or `b` is `NaN`, `s` is `NaN`
    and `e` is `zero(T)`.

# Examples
```jldoctest
julia> two_hilo_diff(1.0, 1e-20)      # |a| ≥ |b|: error captured exactly
(1.0, -1.0e-20)

julia> @inbounds two_hilo_diff(1.0, 1e-20)   # check elided in hot code
(1.0, -1.0e-20)

julia> two_hilo_diff(nextfloat(1.0), 1.0)    # cancellation: exact, e == 0
(2.220446049250313e-16, 0.0)

julia> two_hilo_diff(1.0, 2.0)        # precondition violated → throws
ERROR: ArgumentError: two_hilo_diff requires |a| ≥ |b|
```
"""
@inline function two_hilo_diff(a::T, b::T) where {T<:AbstractFloat}
    # Precondition check, idiomatically elidable via `@inbounds`.
    # NaN operands compare false;
    
    # we let them through so the
    # non-finite guard below handles them as genuine NaNs.
    @boundscheck (abs(a) ≥ abs(b) || isnan(a) || isnan(b)) ||
        throw(ArgumentError("two_hilo_diff requires |a| ≥ |b|"))

    s = a - b
    # The only failure mode: a non-finite difference (overflow → ±Inf,
    # or a NaN operand). `s` already holds the correct IEEE-754 result;
    # the formula below would turn it into a spurious NaN.
    isfinite(s) || return (s, zero(T))

    # Dekker's FastTwoSum, difference form — exact when |a| ≥ |b| and
    # `s` is finite. NOTE: do NOT annotate @fastmath — reassociation
    # breaks exactness.
    e = (a - s) - b
    return (s, e)
end

# Mixed-type calls promote to a common float type, then dispatch above.
# `@propagate_inbounds` so a caller's `@inbounds` reaches the check above.
Base.@propagate_inbounds two_hilo_diff(a::AbstractFloat, b::AbstractFloat) =
    two_hilo_diff(promote(a, b)...)

