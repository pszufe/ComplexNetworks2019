using Pkg
Pkg.activate(".")

using DataFrames
using CSV
using GLPKMathProgInterface
using GLPK
using JuMP

distance_data = CSV.read("distance_data.csv",header=[:i, :j, :dist])

N = length(unique(distance_data.i))
const distance_mx = zeros(Float64,(N,N))
for r in 1:nrow(distance_data)
   distance_mx[distance_data.i[r],distance_data.j[r]] = distance_data.dist[r]
end

#http://opensourc.es/blog/mip-tsp
N = 30 #this is an NP hard problem - we do only 30 cites
m = Model(with_optimizer(GLPK.Optimizer))
@variable(m, x[f=1:N, t=1:N], Bin)
@objective(m, Min, sum( x[i, j]*distance_mx[i,j] for i=1:N,j=1:N))
@constraint(m, notself[i=1:N], x[i, i] == 0)
@constraint(m, oneout[i=1:N], sum(x[i, 1:N]) == 1)
@constraint(m, onein[j=1:N], sum(x[1:N, j]) == 1)
for f=1:N, t=1:N
    @constraint(m, x[f, t]+x[t, f] <= 1)
end

function getcycle(m, N)
    x_val = value.(x)
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


optimize!(m)
getcycle(m,N)

function solved(m, cycle_idx, N)
    println("cycle_idx: ", cycle_idx)
    println("Length: ", length(cycle_idx))
    if length(cycle_idx) < N
        cc = @constraint(m, sum(x[cycle_idx,cycle_idx]) <= length(cycle_idx)-1)
        println("added a constraint")
        return false
    end
    return true
end


while true
    optimize!(m)
    println(termination_status(m))
    cycle_idx = getcycle(m, N)
    if solved(m, cycle_idx,N)
        break;
    end
end


sbws_la = CSV.read("Subway_LV.csv")

using PyPlot
cycle_idx = getcycle(m, N)
ids = vcat(cycle_idx, cycle_idx[1])
PyPlot.cla()
PyPlot.ioff()
p = PyPlot.plot(sbws_la.long[ids], sbws_la.latt[ids])
PyPlot.display_figs()
PyPlot.show()
