using Pkg
Pkg.activate(".")

using BenchmarkTools, LinearAlgebra

function dot1(x, y)
    s = 0.0
    for i in 1:length(x)
        s += x[i]*y[i]
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


x = 1000*rand(10000);
y = 1000*rand(10000);

res1 = @btime dot1($x, $y)
res2 = @btime dot2($x, $y)
res3 = @btime dot($x, $y)

println([res2, res3] .- res1)
