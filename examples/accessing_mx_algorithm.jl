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
# Demonstration on how the algorithm of an MX function can be accessed and its operations can be transversed.
using CasADi

# Create a function
a = MX("a")
b = MX("b",2)
c = MX("c",2,2)
f = casadi.Function("f", [a,b,c], [3*casadi.mtimes(c,b)*a + b], ["a", "b", "c"], ["r"])

# Input values of the same dimensions as the above
input_val = [[2.0], [3.0,4.0], [[5.0,1.0],[8.0,4.0]]]

# Output values to be calculated of the same dimensions as the above
output_val = [zeros(2)]

# Work vector
work = []

# Loop over the algorithm
for k in 0:f.n_instructions()-1

	# Get the atomic operation
	op = f.instruction_id(k)

	o = f.instruction_output(k)
	i = f.instruction_input(k)

	if(op==casadi.OP_CONST)
		v = f.instruction_MX(k).to_DM()
    	# assert v.is_dense()
    	push!(work,v) 
    	# print('work[{o[0]}] = {v}'.format(o=o,v=v))
  	else 
    	if op==casadi.OP_INPUT
      		push!(work, input_val[i[1]])
      		# print('work[{o[0]}] = input[{i[0]}]            ---> {v}'.format(o=o,i=i,v=work[o[0]]))
		elseif op==casadi.OP_OUTPUT
      		output_val[o[1]] = work[i[1]]
      		# print('output[{o[0]}] = work[{i[0]}]             ---> {v}'.format(o=o,i=i,v=output_val[o[0]]))
    		elseif op==casadi.OP_ADD
     		work[o[1]] = work[i[1]] + work[i[2]]
      		# print('work[{o[0]}] = work[{i[0]}] + work[{i[1]}]      ---> {v}'.format(o=o,i=i,v=work[o[0]]))
			elseif op==casadi.OP_MUL
      		work[o[1]] = work[i[1]] * work[i[2]]
      		# print('work[{o[0]}] = work[{i[0]}] * work[{i[1]}]        ---> {v}'.format(o=o,i=i,v=work[o[0]]))
    	elseif op==casadi.OP_MTIMES
      		work[o[1]] = work[i[2]] * work[i[3]]+work[i[1]]
      		# print('work[{o[0]}] = work[{i[1]}] @ work[{i[2]}] + work[{i[0]}]        ---> {v}'.format(o=o,i=i,v=work[o[0]]))
    	else
      		# disp_in = ["work[" + str(a) + "]" for a in i]
      		# debug_str = print_operator(f.instruction_MX(k),disp_in)
      		# raise Exception('Unknown operation: ' + str(op) + ' -- ' + debug_str)
		end
	end
end

# print('------')
# print('Evaluated ' + str(f))
# print('Expected: ', f.call(input_val))
# print('Got:      ', output_val)
