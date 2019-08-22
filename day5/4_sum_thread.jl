using Pkg
Pkg.activate(".")

using BenchmarkTools

x = rand(20000, 20000)

function ssum(x)
    r, c = size(x)
    y = zeros(c)
    for i in 1:c
        for j in 1:r
            y[i] += x[j, i]
        end
    end
    y
end

function tsum(x)
    r, c = size(x)
    y = zeros(c)
    Threads.@threads for i in 1:c
        for j in 1:r
            y[i] += x[j, i]
        end
    end
    y
end

println("threads: ", Threads.nthreads())
@time ssum(x)
@time ssum(x)
@time tsum(x)
@time tsum(x)

