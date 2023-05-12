using RandomNoise: noise_getindex

@testset "Transforms" begin
    sqn = SquirrelNoise5()
    @test typeof(noise_getindex(sqn, identity, 1, UInt64)) == UInt64

    nu = NoiseUniform{Float32}()
    @test typeof(noise_getindex(sqn, nu, 1)) == Float32
end