
@testset "NoiseMap" begin
    @testset "Constructors" begin
        sqn = SquirrelNoise5()

        @test typeof(NoiseMap(sqn, 2)) == NoiseMap{UInt32,2,SquirrelNoise5,typeof(identity)}
        @test NoiseMap(sqn, 2) === NoiseMap(sqn, identity, 2)
        @test NoiseMap(sqn, identity, 2) === NoiseMap{UInt32}(sqn, identity, 2)
        @test NoiseMap(sqn, identity, 2) === NoiseMap{UInt32,2}(sqn, identity)
    end
    @testset "Indexing" begin

    end
end