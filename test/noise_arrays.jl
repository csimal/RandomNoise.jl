
@testset "Noise Arrays" begin
    @testset "Generic Constructors" begin
        sqn = SquirrelNoise5()

        @test NoiseArray(sqn, identity, 5) isa AbstractVector{UInt32}
        @test NoiseArray(sqn, identity, 5,5) isa AbstractMatrix{UInt32}
        @test NoiseArray(sqn, identity, 5) === NoiseArray(sqn, identity, (5,))
        @test NoiseArray(sqn, identity, 5,5) === NoiseArray(sqn, identity, (5,5))
        @test NoiseArray(sqn, identity, 5) === NoiseArray{UInt32}(sqn, identity, 5)
        @test NoiseArray(sqn, identity, (5,)) === NoiseArray{UInt32}(sqn, identity, (5,))
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
    @testset "NoiseUniform" begin
        A = NoiseArray(SquirrelNoise5(), NoiseUniform{Float64}(), 5,5)

        @test A === NoiseArray{Float64}(SquirrelNoise5(), NoiseUniform{Float64}(), 5,5)

        @test typeof(A[1,1]) == Float64
    end
    @testset "Distributions Compat" begin
        @testset "Bernoulli" begin
            A = NoiseArray(SquirrelNoise5(), Bernoulli(), 5,5)

            @test eltype(A) == Bool
            @test A === NoiseArray{Bool}(SquirrelNoise5(), Bernoulli(), 5,5)
            @test A === NoiseArray(SquirrelNoise5(), Bernoulli(), (5,5))
            @test typeof(A[1,1]) == Bool
        end
        @testset "Poisson" begin
            A = NoiseArray(SquirrelNoise5(), Poisson(), 5,5)

            @test eltype(A) == Int
            @test A === NoiseArray(SquirrelNoise5(), Poisson(), (5,5))
            @test typeof(A[1,1]) == Int
        end
    end
end