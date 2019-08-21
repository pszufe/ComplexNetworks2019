using DataFrames
using CSV
using TravelingSalesmanHeuristics

distance_data = CSV.read("distance_data.csv",header=[:i, :j, :dist, :route], missing=:none)
N = length(unique(distance_data.i))
const distance_mx = zeros(Float64,(N,N))
for r in 1:nrow(distance_data)
   distance_mx[distance_data.i[r],distance_data.j[r]] = distance_data.dist[r]
end

sol = TravelingSalesmanHeuristics.solve_tsp(distance_mx,quality_factor =100)
sol
sbws_la = CSV.read("Subway_LV.csv", missing=:none)


using PyPlot
ids = sol[1]
PyPlot.cla()
PyPlot.ioff()
p = PyPlot.plot(sbws_la.long[ids], sbws_la.latt[ids])
PyPlot.display_figs()
PyPlot.show()
