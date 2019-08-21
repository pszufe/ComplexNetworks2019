using DataFrames
using CSV
using Gurobi
using JuMP



distance_data = CSV.read("distance_data.csv",header=[:i, :j, :dist, :route], missing=:none)

N = length(unique(distance_data.i))
const distance_mx = zeros(Float64,(N,N))
for r in 1:nrow(distance_data)
   distance_mx[distance_data.i[r],distance_data.j[r]] = distance_data.dist[r]
end



#http://opensourc.es/blog/mip-tsp
N = 50 # this time we use 50 points

m = Model(solver=GurobiSolver());
@variable(m, x[f=1:N,t=1:N], Bin)
@objective(m, Min, sum( x[i,j]*distance_mx[i,j] for i=1:N,j=1:N))
@constraint(m, notself[i=1:N], x[i,i] == 0)
@constraint(m, oneout[i=1:N], sum(x[i,1:N]) == 1)
@constraint(m, onein[j=1:N], sum(x[1:N,j]) == 1)
for f=1:N, t=1:N
    @constraint(m, x[f,t]+x[t,f] <= 1)
end

function getcycle(m, N)
    x_val = getvalue(x)
    cycle_idx = Vector{Int}()
    push!(cycle_idx, 1)
    while true
        v, idx = findmax(x_val[cycle_idx[end], 1:N])
        if idx == cycle_idx[1]
            break
        else
            push!(cycle_idx, idx)
        end
    end
    cycle_idx
end

function callbackhandle(cb)
    cycle_idx = getcycle(cb, N)
    println("Callback! N= $N cycle_idx: ", cycle_idx)
    println("Length: ", length(cycle_idx))
    if length(cycle_idx) < N
        @lazyconstraint(cb, sum(x[cycle_idx,cycle_idx]) <= length(cycle_idx)-1)
        println("added a lazy constraint")
    end
end

addlazycallback(m, callbackhandle)
solve(m)

sbws_la = CSV.read("Subway_LV.csv", missing=:none)

using PyPlot
cycle_idx = getcycle(m, N)
ids = vcat(cycle_idx, cycle_idx[1])
PyPlot.cla()
PyPlot.ioff()
p = PyPlot.plot(sbws_la.long[ids], sbws_la.latt[ids])
PyPlot.display_figs()
PyPlot.show()
