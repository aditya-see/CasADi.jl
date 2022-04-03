Base.abs(x::T) where T <: CasadiSymbolicObject = casadi.fabs(x)

Base.inv(x::T) where T <: CasadiSymbolicObject = casadi.inv(x)
Base.sqrt(x::T) where T <: CasadiSymbolicObject = casadi.sqrt(x)
Base.sin(x::T) where T <: CasadiSymbolicObject = casadi.sin(x)
Base.cos(x::T) where T <: CasadiSymbolicObject = casadi.cos(x)
Base.vec(x::T) where T <: CasadiSymbolicObject = casadi.vec(x)
Base.log(x::T) where T <: CasadiSymbolicObject = casadi.log(x)
Base.transpose(x::T) where T <: CasadiSymbolicObject = casadi.transpose(x)
Base.sincos(x::CasadiSymbolicObject) = (sin(x), cos(x))
Base.sinc(x::CasadiSymbolicObject) = sin(x)/x

## Solve linear systems
Base.:\(A::Matrix{C}, b::Vector{C}) where C <: CasadiSymbolicObject = Vector(casadi.solve(C(A), C(b)))