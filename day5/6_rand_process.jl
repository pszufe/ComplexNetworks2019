using Pkg
Pkg.activate(".")

using Distributed

function s_rand()
    n = 10^4
    x = 0.0
    for i in 1:n
        x += sum(rand(10^4))
    end
    x / n
end

function p_rand()
    n = 10^4
    x = @distributed (+) for i in 1:n
        sum(rand(10^4))
    end
    x / n
end

@time s_rand()
@time s_rand()
@time p_rand()
@time p_rand()

