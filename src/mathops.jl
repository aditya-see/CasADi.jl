## Unary operations
-(x::C) where C <: CasadiSymbolicObject = casadi.minus(0, x)

## Binary operations
+(x::C, y::C) where C <: CasadiSymbolicObject = casadi.plus(x, y)
-(x::C, y::C) where C <: CasadiSymbolicObject = casadi.minus(x, y)
/(x::C, y::C) where C <: CasadiSymbolicObject = casadi.mrdivide(x, y)
^(x::C, y::C) where C <: CasadiSymbolicObject = casadi.power(x, y)
^(x::C, y::C) where C <: CasadiSymbolicObject = casadi.power(x, y)
\(x::C, y::C) where C <: CasadiSymbolicObject = casadi.solve(x, y)

function *(x::C, y::C) where C <: CasadiSymbolicObject
    if size(x,2) == size(y,1)
        casadi.mtimes(x, y)
    else 
        casadi.times(x, y)
    end
end

## Comparisons
>=(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.ge, C, x, y)
>(x::C, y::Real)  where C <: CasadiSymbolicObject = pycall(casadi.gt, C, x, y)
<=(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.le, C, x, y)
<(x::C, y::Real)  where C <: CasadiSymbolicObject = pycall(casadi.lt, C, x, y)
==(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.eq, C, x, y)

## Linear algebra
×(x::C, y::Real) where C <: CasadiSymbolicObject = pycall(casadi.cross, C, x, y)
