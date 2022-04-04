#
#     This file is part of CasADi.
#
#     CasADi -- A symbolic framework for dynamic optimization.
#     Copyright (C) 2010-2014 Joel Andersson, Joris Gillis, Moritz Diehl,
#                             K.U. Leuven. All rights reserved.
#     Copyright (C) 2011-2014 Greg Horn
#
#     CasADi is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License as published by the Free Software Foundation; either
#     version 3 of the License, or (at your option) any later version.
#
#     CasADi is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with CasADi; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
#

using CasADi
using Plots

# Control
u = MX("u")

# State
x = MX("x",3)
s = x[1] # position
v = x[2] # speed
m = x[3] # mass

# ODE right hand side
sdot = v
vdot = (u - 0.05 * v*v)/m
mdot = -0.1*u*u
xdot = casadi.vertcat(sdot,vdot,mdot)

# ODE right hand side function
f = casadi.Function("f", [x,u],[xdot])

# Integrate with Explicit Euler over 0.2 seconds
dt = 0.01  # Time step
xj = x
for j in 1:20
	global xj
  	fj = f(xj,u)
  	xj += dt*fj
end

# Discrete time dynamics function
F = casadi.Function("F", [x,u],[xj])

# Number of control segments
nu = 50 

# Control for all segments
U = MX("U",nu) 
 
# Initial conditions
X0 = MX([0,0,1])

# Integrate over all intervals
X=X0
for k in 1:nu
	global X
  	X = F(X,U[k])
end

# Objective function and constraints
J = casadi.mtimes(U.T,U) # u'*u in Matlab
G = X[1:2]     # x(1:2) in Matlab

# NLP
nlp = Dict("x"=>U, "f"=>J, "g"=>G)
 
# Allocate an NLP solver
opts = Dict("ipopt.tol"=>1e-10, "expand"=>true)
solver = casadi.nlpsol("solver", "ipopt", nlp, opts)
arg = Dict()

# Bounds on u and initial condition
lbx = -0.5
ubx =  0.5
x0 =   0.4

# Bounds on g
lbg = [10,0]
ubg = [10,0]

# Solve the problem
res = solver(x0 = x0, lbx = lbx, ubx =ubx, lbg =lbg, ubg =ubg)

# Get the solution
fig1 = plot(res["x"].toarray())
plot!(fig1,res["lam_x"].toarray())
