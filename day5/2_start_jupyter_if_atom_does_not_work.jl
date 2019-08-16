using Pkg
Pkg.activate(".")

ENV["LINES"] = 20

using IJulia
notebook(dir=".")
