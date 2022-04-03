V = Vector{<:Real}
## Unary operations
-(x::C) where C <: CasadiSymbolicObject = pycall(casadi.minus, C, 0, x)

## Binary operations
+(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.plus, C, x, y)
+(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.plus, C, x, y)
+(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.plus, C, x, y)

-(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.minus, C, x, y)
-(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.minus, C, x, y)
-(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.minus, C, x, y)

/(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.rdivide, C, x, y)
/(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.rdivide, C, x, y)
/(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.rdivide, C, x, y)

*(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.times, C, x, y)
*(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.times, C, x, y)
*(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.times, C, x, y)

^(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.power, C, x, y)
^(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.power, C, x, y)
^(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.power, C, x, y)


## Comparisons
>=(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.ge, C, x, y)
>=(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.ge, C, x, y)
>=(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.ge, C, x, y)
>=(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.ge, C, x, y)

>(x::C, y::Real)  where C <: CasadiSymbolicObject = pycall(casadi.gt, C, x, y)
>(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.gt, C, x, y)
>(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.gt, C, x, y)
>(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.gt, C, x, y)

<=(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.le, C, x, y)
<=(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.le, C, x, y)
<=(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.le, C, x, y)
<=(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.le, C, x, y)

<(x::C, y::Real)  where C <: CasadiSymbolicObject = pycall(casadi.lt, C, x, y)
<(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.lt, C, x, y)
<(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.lt, C, x, y)
<(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.lt, C, x, y)

==(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.eq, C, x, y)
==(x::C, y::C) where C <: CasadiSymbolicObject = pycall(casadi.eq, C, x, y)
==(x::C, y::V) where C <: CasadiSymbolicObject = pycall(casadi.eq, C, x, y)
==(x::V, y::C) where C <: CasadiSymbolicObject = pycall(casadi.eq, C, x, y)

## Linear algebra
×(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.cross, C, x, y)
