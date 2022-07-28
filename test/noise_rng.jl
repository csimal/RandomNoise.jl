const bit_types = [Bool, UInt8, UInt16, UInt32, UInt64, UInt128, Int8, Int16, Int32, Int64, Int128]

@testset "NoiseRNG" begin
    @testset "RNG utils" begin
        local rng1 = NoiseRNG(SquirrelNoise5())
        local rng2 = NoiseRNG(SquirrelNoise5())
    
        @test RandomNoise.rng_native_52(rng1) == UInt64

        @test rand(rng1, Random.SamplerType{Bool}()) == rand(rng2, Bool)  
    end
    @testset "SquirrelNoise5 RNG" begin
        local rng = NoiseRNG(SquirrelNoise5())
        @test typeof(rand(rng)) == Float64

        @test copy(rng) == rng
        @test copy!(copy(rng), rng) == rng
    end
    
    @testset "Bit types RNG" begin
        local rng1 = NoiseRNG(SquirrelNoise5())
        #local rng2 = NoiseRNG(HashNoise())

        for T in bit_types
            @test typeof(rand(rng1, T)) == T
            #@test typeof(rand(rng2, t)) == t
        end
    end
end