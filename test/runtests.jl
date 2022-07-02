using RandomNoise
using Random123
using Random
using Test

@testset "RandomNoise.jl" begin
    include("pairing_functions.jl")
    include("noise.jl")
    include("random123.jl")
    include("convert.jl")
    include("noise_rng.jl")
    include("noise_arrays.jl")
end
