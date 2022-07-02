
@testset "Noise Arrays" begin
    @testset "Generic Constructors" begin
        sqn = SquirrelNoise5()

        @test NoiseArray(sqn, identity, 5) isa AbstractVector{UInt32}
        @test NoiseArray(sqn, identity, 5,5) isa AbstractMatrix{UInt32}
        @test NoiseArray(sqn, identity, 5) === NoiseArray(sqn, identity, (5,))
        @test NoiseArray(sqn, identity, 5,5) === NoiseArray(sqn, identity, (5,5))
        @test eltype(NoiseArray(sqn, identity, 5)) == UInt32

    end
    @testset "Indexing" begin
        A = NoiseArray(SquirrelNoise5(), identity, 5,5)

        @test size(A,1) == 5
        @test size(A) == (5,5)

        @test A[1,1] == A[1]

        @test_throws BoundsError A[1:26]
        @test_throws BoundsError A[6,1]

        @test_throws ArgumentError setindex!(A, zero(UInt32), 1)
    end
end