using Pkg
Pkg.activate(".")

using RandomNoise
using Random
using RNGTest

include("utils.jl")

sqn = SquirrelNoise5x2()

open("results/speed_test_SquirrelNoise5x3.txt", "w") do io
    b = speed_test(sqn)
    show(io, MIME("text/plain"), b)
end

io2 = open("results/bigcrush_SquirrelNoise5x2.txt", "w")
redirect_stdout(io2) do 
    bigcrush(sqn)
end
close(io2)
