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
# -*- coding: utf-8 -*-
using CasADi

# Declare variables
x = SX("x",2)

# Form the NLP
f = x[1]^2 + x[2]^2 # objective
g = x[1]+x[2]-10      # constraint
nlp = Dict("x"=>x, "f"=>f, "g"=>g)

# Pick an NLP solver
MySolver = "ipopt"
#MySolver = "worhp"
#MySolver = "sqpmethod"

# Solver options
opts = Dict()
if MySolver=="sqpmethod"
	opts["qpsol"] = "qpoases"
  	opts["qpsol_options"] = Dict("printLevel"=>"none")
end

# Allocate a solver
solver = casadi.nlpsol("solver", MySolver, nlp, opts)

# Solve the NLP
sol = solver(lbg=0)

# Print solution
println("-----")
println("objective at solution = ", sol["f"])
println("primal solution = ", sol["x"])
println("dual solution (x) = ", sol["lam_x"])
println("dual solution (g) = ", sol["lam_g"])
