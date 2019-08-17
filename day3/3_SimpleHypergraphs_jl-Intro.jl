using Pkg
Pkg.activate(".")


using GraphPlot, SimpleHypergraphs
import LightGraphs

# In Atom in order to run a line press Ctrl+Enter

# It is also possible to run a block of code
# Simply select the block and press Ctrl+Enter

h = Hypergraph{Float64}(5,4)
h[1:3,1] .= 1.5
h[3,4] = 2.5
h[2,3] = 3.5
h[4,3:4] .= 4.5
h[5,4] = 5.5
h[5,2] = 6.5


display(h)    #you could also type h in the console and press enter

# manipulating the graph structure
add_vertex!(h)
add_hyperedge!(h)
h[5,5] = 1.2
h[6,5] = 1.3

display(h)


#Bipartite representation of a hypergraph h


b = BipartiteView(h)
# note that it is a view and hence
#the data is not actually copied.

# this plot will get shown in Atom as well as in Jupyter
gplot(b,
    nodefillc=vcat(fill("green", nhv(h)), fill("orange",nhe(h)) ),
    nodelabel=1:LightGraphs.nv(b),
    layout=circular_layout)

#several functions of the LightGraphs API
#will work directly on the bipartite
#view b of a hypergraph h

LightGraphs.has_self_loops(b)
LightGraphs.nv(b)
LightGraphs.ne(b)

#However it is also possible to make
#a deep copy of this view.
#In this case the deep copy is just
#a "normal" graph.

b2 = LightGraphs.SimpleGraph(b)

remove_vertex!(h,6)

LightGraphs.nv(b)
LightGraphs.nv(b2)


#Another representation of a hypergraph h
# is a two-section view

t = TwoSectionView(h)

gplot(t, nodelabel=1:LightGraphs.nv(t))

sp = shortest_path(t,1,5)

edge_cols = [ e.src in sp && e.dst in sp ? "green" : "white"  for e in LightGraphs.edges(t)]

gplot(t, nodelabel=1:LightGraphs.nv(t), edgestrokec = edge_cols)
