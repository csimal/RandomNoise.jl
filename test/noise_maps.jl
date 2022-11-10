using RandomNoise: pairing, pairing2, pairing3, pairing4, pairing5, pairing5, pairing6, pairing7, pairing8

@testset "NoiseMap" begin
    @testset "Constructors" begin
        sqn = SquirrelNoise5()

        @test typeof(NoiseMap(sqn, 2)) == NoiseMap{UInt32,2,SquirrelNoise5,typeof(identity)}
        @test NoiseMap(sqn, 2) === NoiseMap(sqn, identity, 2)
        @test NoiseMap(sqn, identity, 2) === NoiseMap{UInt32}(sqn, identity, 2)
        @test NoiseMap(sqn, identity, 2) === NoiseMap{UInt32,2}(sqn, identity)
    end
    @testset "Indexing" begin
        @testset "1D Indexing" begin
            nm = NoiseMap(SquirrelNoise5(), 1)

            @test typeof(nm(1)) == UInt32
            @test nm(1) == noise(1, nm.noise)
            @test nm[1] == nm(1)
        end
        @testset "2D Indexing" begin
            nm = NoiseMap(SquirrelNoise5(), 2)
            
            @test nm(1,1) == nm(1)
            @test nm(1,2) == nm(pairing2(1,2))
            @test nm[1,1] == nm(1,1)
        end
    end
end