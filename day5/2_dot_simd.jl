using Pkg
Pkg.activate(".")

using BenchmarkTools

function dot1(x, y)
    s = 0.0
    for i in 1:length(x)
        @inbounds s += x[i]*y[i]
    end
    s
end

function dot2(x, y)
    s = 0.0
    @simd for i in 1:length(x)
        @inbounds s += x[i]*y[i]
    end
    s
end


x = 100*rand(10000)
y = 100*rand(10000)

res1 = @btime dot1($x, $y)
res2 = @btime dot2($x, $y)

println(res1)
println(res2)


