# Car race along a track
# ----------------------
# An optimal control problem (OCP),
# solved with direct multiple-shooting.
#
# For more information see: http://labs.casadi.org/OCP

using CasADi
N = 100 # number of control intervals

opti = casadi.Opti() # Optimization problem

# ---- decision variables ---------
X = opti._variable(2,N+1) # state trajectory
pos   = X[1,1:end]
speed = X[2,1:end]
U = opti._variable(1,N)   # control trajectory (throttle)
T = opti._variable()      # final time

# ---- objective          ---------
opti.minimize(T) # race in minimal time

# ---- dynamic constraints --------
f(x,u) = casadi.vertcat(x[2],u-x[2]) # dx/dt = f(x,u)

dt = T/N # length of a control interval
for k in 1:N # loop over control intervals
   # Runge-Kutta 4 integration
   k1 = f(X[1:end,k],         U[1:end,k])
   k2 = f(X[1:end,k]+dt/2*k1, U[1:end,k])
   k3 = f(X[1:end,k]+dt/2*k2, U[1:end,k])
   k4 = f(X[1:end,k]+dt*k3,   U[1:end,k])
   x_next = X[1:end,k] + dt/6*(k1+2*k2+2*k3+k4) 
   opti._subject_to(X[1:end,k+1]==x_next) # close the gaps
end

# ---- path constraints -----------
limit(pos) = 1 .- sin.(2*pi*pos)/2
opti._subject_to(speed<=limit(pos))   # track speed limit
opti._subject_to(opti.bounded(0,U,1)) # control is limited

# ---- boundary conditions --------
opti._subject_to(pos[1]==0)   # start at position 0 ...
opti._subject_to(speed[1]==0) # ... from stand-still 
opti._subject_to(pos[end]==1)  # finish line at position 1

# ---- misc. constraints  ----------
opti._subject_to(T>=0) # Time must be positive

# ---- initial values for solver ---
opti.set_initial(speed, 1)
opti.set_initial(T, 1)

# # ---- solve NLP              ------
opti.solver("ipopt") # set numerical backend
sol = opti.solve()   # actual solve

# ---- post-processing        ------
using Plots

fig1 = plot(sol.value(speed), label="speed")
plot!(fig1, sol.value(pos),label="pos")
plot!(fig1, limit(sol.value(pos)),label="speed limit")
plot!(fig1,collect(1:N),sol.value(U),label="throttle", linetype = :steppost)

# figure()
# spy(sol.value(jacobian(opti.g,opti.x)))
# figure()
# spy(sol.value(hessian(opti.f+dot(opti.lam_g,opti.g),opti.x)[0]))

# show()
