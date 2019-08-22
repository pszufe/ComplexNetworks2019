using Pkg
Pkg.activate(".")

using Sockets

server = Sockets.listen(8080)
println("Starting the web server...")
println("For a test try pasting the address below to your web browser")
println("http://127.0.0.1:8080/3+4")
while true
    sock = Sockets.accept(server)
    @async begin
        data = readline(sock)
        print("Got request:\n", data, "\n") 
        cmd = split(data, " ")[2][2:end] 
        println(sock, "\nHTTP/1.1 200 OK\nContent-Type: text/html\n")
        println(sock, string("<html><body>", cmd, "=", eval(Meta.parse(cmd)), "</body></html>"))
        close(sock)
    end
end     