using RandomNoise:  noise_getindex
using Distributions

@testset "Distributions compat" begin
    sqn = SquirrelNoise5()

    @test typeof(NoiseMap(sqn, Normal(0,1))) == NoiseMap{Float64,1,SquirrelNoise5,Normal{Float64}}

    @test typeof(noise_getindex(sqn, Normal(0,1), 1)) == Float64
    @test typeof(noise_getindex(sqn, Bernoulli(0.5), 1)) == Bool
    @test typeof(noise_getindex(sqn, Poisson(1), 1)) == Int
end