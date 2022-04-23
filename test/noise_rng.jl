
@testset "NoiseRNG" begin
    @testset "SquirrelNoise5 RNG" begin
        local rng = NoiseRNG(SquirrelNoise5())
        @test typeof(rand(rng)) == Float64

        @test copy(rng) == rng
        @test copy!(copy(rng), rng) == rng
    end
    @testset "HashNoise RNG" begin
        local rng = NoiseRNG(HashNoise())
        @test typeof(rand(rng)) == Float64
        
        @test copy(rng) == rng
        @test copy!(copy(rng), rng) == rng
    end
end