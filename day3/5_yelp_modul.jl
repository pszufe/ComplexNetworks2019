using GraphPlot, SimpleHypergraphs
import LightGraphs

using DataFrames
using CSV

#cd(raw"copy_the_path_here_if_your_Julia_cannot_find_files")

b = CSV.read("business.csv",delim="\t")

b.business_id = Symbol.(b.business_id);
for name in names(b)[2:15]
    b[!,name] = Symbol.(b[!, name])
end

revs = CSV.read("review2.csv",delim="\t")

revs.business_id = Symbol.(revs.business_id)

@assert sort(b.business_id) == sort(unique(revs.business_id))

using StatsBase
using Random

using SimpleHypergraphs


function report(revs::DataFrame, b::DataFrame, stars)
    revsg = revs[revs.stars .== stars, :]
    sort!(revsg,:business_id)

    business_ids_set = Set{Symbol}(revsg.business_id)
    #list of businesses filtered to the data
    bf = filter(row -> row[:business_id] in business_ids_set, b)
    sort!(bf,:business_id)
    bf.b_id = 1:nrow(bf)


    revsg.user_id = categorical(revsg.user_id,true)

    # Verices x hyperedges
    h = Hypergraph{Float64}(nrow(bf),length(levels(revsg.user_id)));
    for r in 1:nrow(revsg)
        bix = searchsorted(bf.business_id,revsg.business_id[r]).start
        h[bix,revsg.user_id[r].level] = 1
    end

    println("Constructed a hypergraph having size: " ,size(h))

    for gt in [:city, :state, :Alcohol,:NoiseLevel,:RestaurantsTakeOut,:category]
        partition = Vector{Set{Int}}()
        for bfg in groupby(bf,gt)
            push!(partition,Set{Int}(sort(bfg.b_id)))
        end
        println(gt," ",modularity(h,partition))
    end
end

for stars in 1:5
    println(stars)
    report(revs, b, stars)
end
