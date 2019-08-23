using Pkg
Pkg.activate(".")

using Roots
using Dierckx
using PyPlot

function find_c(β)
    -log(1-β) / β
end
β = 0.01:0.005:0.99
plot(find_c.(β), β, linewidth=6)

function find_β(c)
    function f(β)
        β + exp(-c*β) - 1.0
    end
    find_zero(f, (0.00001, 1))
end

c = 1.005:0.005:4.65
plot(c, find_β.(c))

spl_c = Spline1D(c, find_β.(c))
spl_β = Spline1D(find_c.(β), β)
plot(c, spl_c.(c) - spl_β.(c))
