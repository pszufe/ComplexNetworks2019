
using Pkg
Pkg.activate(".")
using LightGraphs

g = LightGraphs.erdos_renyi(10000,1_000_000)

typeof(g)

using Distributed
addprocs(4)

@everywhere using LightGraphs
@everywhere function findtriangles(g::SimpleGraph; adset = Set.(g.fadjlist), node_range=1:nv(g))
    res = Vector{Tuple{Int,Int,Int}}()
    for n1 in node_range
        for n2 in neighbors(g,n1)
            n2 < n1 && continue
            for n3 in neighbors(g,n2)
                n3 < n2 && continue
                @inbounds n3 in adset[n1] && push!(res,(n1,n2,n3))
            end
        end
    end
    res
end


findtriangles(g)

sum(LightGraphs.triangles(g)) == length(findtriangles(g))*3

using Random

n_vals = shuffle!(collect(1:nv(g)))

k = nworkers()

function distt(g)
    adset = Set.(g.fadjlist)
    ts = @distributed (append!) for n in n_vals
        findtriangles(g,adset=adset,node_range=n:n)
    end
end

@time findtriangles(g)
@time distt(g)
