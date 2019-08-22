using Pkg
Pkg.activate(".")

function f_bad()
    x = 0
    Threads.@threads for i in 1:10^7
        x += 1
    end
    return x
end

function f_atomic()
    x = Threads.Atomic{Int}(0)
    Threads.@threads for i in 1:10^7
        Threads.atomic_add!(x, 1)
    end
    return x[]
end

function f_spin()
    l = Threads.SpinLock()
    x = 0
    Threads.@threads for i in 1:10^7
        Threads.lock(l)
        x += 1
        Threads.unlock(l)
    end
    return x
end

function f_mutex()
    l = Threads.Mutex()
    x = 0
    Threads.@threads for i in 1:10^7
        Threads.lock(l)
        x += 1
        Threads.unlock(l)
    end
    return x
end

for f in [f_bad, f_atomic, f_spin, f_mutex]
    println(f)
    @time println(f())
    @time println(f())
end

