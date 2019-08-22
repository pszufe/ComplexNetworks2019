###
# This script is designed for multi-core parallelizaition 
# run 
# julia -p N 9_subway_preps.jl
# where N is the number of cores you want to use. 
# 
# For a reasonable running time use a machine with at least 32 cores
#
# 

using Pkg
Pkg.activate(".")

using Distributed
println("using $(Distributed.nworkers()) worker(s)")
using HTTP, CSV, DataFrames, OpenStreetMapX
@everywhere using HTTP
@everywhere using CSV
@everywhere using DataFrames
@everywhere using OpenStreetMapX

preread = OpenStreetMapX.get_map_data(".", "las_vegas.osm");

@everywhere const map_data = OpenStreetMapX.get_map_data(".", "las_vegas.osm");

println("The map contains $(length(map_data.nodes)) nodes")

function point_to_node(point::LLA, map_data::OpenStreetMapX.MapData)
    nearest_node(map_data.nodes,ENU(point, map_data.bounds), map_data)
end

sbws_la = CSV.read("Subway_LV.csv")

N = nrow(sbws_la)

@everywhere function calc_distances(i,N, sbws_la)
    open(string(lpad(i,4,"0"),"_distance.csv"),"w") do f
        for j in 1:N
            dista = 0.0
            route = [sbws_la.node[i]]
            if sbws_la.node[i] != sbws_la.node[j]
                route, dista, time = shortest_route(map_data, sbws_la.node[i], sbws_la.node[j])
            end
            println(f,"$i,$j,$dista,$(join(route,"#"))")
        end
    end
end

all_no = @distributed (+) for i in 1:N
    calc_distances(i, N, sbws_la)
    1
end

println("Finished for $all_no nodes")
