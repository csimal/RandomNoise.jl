using RandomNoise
using Random123
using Random
using Distributions
using Test
using PropCheck
using Aqua

@testset "RandomNoise.jl" begin
    include("pairing_functions.jl")
    include("noise.jl")
    include("random123.jl")
    include("convert.jl")
    include("noise_rng.jl")
    include("noise_maps.jl")
    include("noise_arrays.jl")
    include("transforms.jl")
    include("distributions.jl")
    Aqua.test_all(RandomNoise)
end
