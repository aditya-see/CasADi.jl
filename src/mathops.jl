C = Union{CasadiSymbolicObject, Vector{<:Real}}
## Unary operations
-(x::C)  = casadi.minus(0, x)

## Binary operation
+(x::C, y::C) = casadi.plus(x, y)
-(x::C, y::C) = casadi.minus(x, y)
/(x::C, y::C) = casadi.rdivide(x, y)
^(x::C, y::C) = casadi.power(x, y)
\(x::C, y::C) = casadi.solve(x, y)

function *(x::C, y::C)     
	if size(x,2) == size(y,1)
        casadi.mtimes(x, y)
    else 
        casadi.times(x, y)
    end
end

## Comparisons
>=(x::C, y::C) = casadi.ge(x, y)
>(x::C, y::C)  = casadi.gt(x, y)
<=(x::C, y::C) = casadi.le(x, y)
<(x::C, y::C)  = casadi.lt(x, y)
==(x::C, y::C) = casadi.eq(x, y)

## Linear algebra
×(x::C, y::C)  = casadi.cross(x, y)
