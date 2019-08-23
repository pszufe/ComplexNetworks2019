# Running this requires hardware that has GPU and dedicated native libraries.

using BenchmarkTools, PyPlot

function juliaset(z0)
    c = ComplexF32(-0.5, 0.75)
    z = z0
    for i in 0x1:0x40
        abs2(z) > 4f0 && return (i - 0x1)
        z = z * z + c
    end
    return 0x40
end

N = 10000;
q = ComplexF32.(range(-1.5, 1.5, length=N), range(-1, 1, length=N)');
r = zeros(UInt8, size(q));

@time r .= juliaset.(q);
@time r .= juliaset.(q);
@time r .= juliaset.(q);

imshow(log.(r))

using CuArrays

cuq = cu(q);
cur = CuArrays.zeros(UInt8, N, N);

@time cur .= juliaset.(cuq);
@time cur .= juliaset.(cuq);
@time cur .= juliaset.(cuq);

imshow(log.(Matrix(cur)))
