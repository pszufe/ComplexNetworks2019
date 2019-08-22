using LightGraphs

function sample_graphs(n, p, k)
    gs = Vector{SimpleGraph{Int}}(undef, k)
    for i in 1:k
        gs[i] = erdos_renyi(n, p, seed=i)
    end
    gs
end

function sample_graphs_t(n, p, k)
    gs = Vector{SimpleGraph{Int}}(undef, k)
    Threads.@threads for i in 1:k
        gs[i] = erdos_renyi(n, p, seed=i)
    end
    gs
end

println("threads: ", Threads.nthreads())
@time sample_graphs(10^5, 10^-4, 32)
@time sample_graphs(10^5, 10^-4, 32)
@time sample_graphs_t(10^5, 10^-4, 32)
@time sample_graphs_t(10^5, 10^-4, 32)
