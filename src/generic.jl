## Indexing
function Base.getindex(x::CasadiSymbolicObject,j::Union{Int, UnitRange{Int}, Colon}) 
	x.__pyobject__.__getitem__(j.-1)
end

function Base.getindex(x::CasadiSymbolicObject,
					   j1::Union{Int, UnitRange{Int}, Colon}, 
					   j2::Union{Int, UnitRange{Int}, Colon}) 
	x.__pyobject__.__getitem__((j1.-1, j2.-1))
end

function Base.setindex!(x::CasadiSymbolicObject,
						v::Number,
  						j::Union{Int, UnitRange{Int}, Colon})
	x.__pyobject__.__setitem__(j .- 1, v)
end

function Base.setindex!(
  x::CasadiSymbolicObject,
  v::Number,
  j1::Union{Int, UnitRange{Int}, Colon},
  j2::Union{Int, UnitRange{Int}, Colon}
)
    # J1 = if (j1 isa Int) j1:j1 else j1 end
    # J2 = if (j2 isa Int) j2:j2 else j2 end

    x.__pyobject__.__setitem__( (j1 .- 1,j2 .- 1), v)
end

Base.lastindex(x::CasadiSymbolicObject) = length(x)
Base.lastindex(x::CasadiSymbolicObject, j::Int) = size(x,j)

## one, zero, zeros, ones
Base.one(::Type{C}) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).eye(1)
Base.one(x::C) where C <: CasadiSymbolicObject =
  if size(x,1) == size(x,2)
    getproperty(casadi, Symbol(C)).eye( size(x,1) )
  else
    throw(DimensionMismatch("multiplicative identity defined only for square matrices"))
  end

Base.zero(::Type{C}) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).zeros()
Base.zero(x::C) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).zeros( size(x) )

Base.ones(::Type{C}, j::Integer) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).ones(j)
Base.ones(::Type{C}, j1::Integer, j2::Integer) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).ones(j1, j2)

Base.zeros(::Type{C}, j::Integer) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).zeros(j)
Base.zeros(::Type{C}, j1::Integer, j2::Integer) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).zeros(j1, j2)

## Size related operations
function Base.size(x::C, j::Integer) where C <: CasadiSymbolicObject
    if j == 1
        return getproperty(casadi, Symbol(C)).size1(x)
    elseif j == 2
        return getproperty(casadi, Symbol(C)).size2(x)
    else
        throw(DimensionMismatch("arraysize: dimension out of range"))
    end
end
Base.length(x::C) where C <: CasadiSymbolicObject = getproperty(casadi, Symbol(C)).numel(x)

## Concatenations
Base.hcat(x::Vector{T}) where T <: CasadiSymbolicObject = pycall(casadi.hcat, T, x)
Base.vcat(x::Vector{T}) where T <: CasadiSymbolicObject = pycall(casadi.vcat, T, x)

## Matrix operations
Base.adjoint(x::CasadiSymbolicObject) = transpose(x)
Base.repeat(x::CasadiSymbolicObject, counts::Integer...) = casadi.repmat(x, counts...)

## To/From array
# From vector to SX/MX
Base.convert(::Type{Τ}, V::AbstractVector{Τ}) where Τ <: CasadiSymbolicObject = casadi.vcat(V)

# From matrix to SX/MX
Base.convert(::Type{Τ}, M::AbstractMatrix{Τ}) where Τ <: CasadiSymbolicObject = casadi.blockcat(M)

# Convert SX/MX to vector
Base.Vector(V::CasadiSymbolicObject) = casadi.vertsplit(V)

# Convert SX/MX to matrix
Base.Matrix(M::CasadiSymbolicObject) = casadi.blocksplit(M)


Base.size(x::CasadiSymbolicObject) = x.size()
Base.reshape(x::T, t::Tuple{Int, Int}) where T <: CasadiSymbolicObject = x.reshape(t)

