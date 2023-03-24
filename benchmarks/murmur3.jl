using Pkg
Pkg.activate(".")

using RandomNoise
using Random
using RNGTest

include("utils.jl")

mmn = Murmur3Noise()

open("results/speed_test_Murmur3Noise.txt", "w") do io
    b = speed_test(mmn)
    show(io, MIME("text/plain"), b)
end

io2 = open("results/bigcrush_MurmurNoise.txt", "w")
redirect_stdout(io2) do 
    bigcrush(mmn)
end
close(io2)
