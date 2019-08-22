println("Starting @async")
for i in 1:10
    @async begin
        sleep(rand())
        println(i)
    end
end
println("Done @async")

sleep(2)

println("\n\nStarting @sync-@async")
@sync for i in 1:10
    @async begin
        sleep(rand())
        println(i)
    end
end
println("Done @sync-@async")
