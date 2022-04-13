using RandomNoise
using Random123
using Test

@testset "RandomNoise.jl" begin
    include("pairing_functions.jl")
    include("noise.jl")
end
