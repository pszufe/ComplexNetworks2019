using Distributed

@everywhere using Pkg
@everywhere Pkg.activate(".")
@everywhere using LightGraphs

sample_graphs(n, p, k) = [erdos_renyi(n, p, seed=i) for i in 1:k]

function sample_graphs_t(n, p, k)
    gs = @sync @distributed for i in 1:k
        erdos_renyi(n, p, seed=i)
    end
    gs
end

println("processes: ", nworkers())
@time sample_graphs(10^5, 10^-4, 32)
@time sample_graphs(10^5, 10^-4, 32)
@time sample_graphs_t(10^5, 10^-4, 32)
@time sample_graphs_t(10^5, 10^-4, 32)
