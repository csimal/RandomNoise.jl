
@testset "NoiseArray" begin
    @testset "Constructors" begin
        sqn = SquirrelNoise5()

        A = NoiseArray(sqn, identity, (3,4))
        @test typeof(A) == NoiseArray{UInt32,2,SquirrelNoise5,typeof(identity),Tuple{Base.OneTo{Int64},Base.OneTo{Int64}}}


        B = NoiseArray(sqn, NoiseUniform(), (3,4))
        @test typeof(B) == NoiseArray{Float64,2,SquirrelNoise5,NoiseUniform{Float64},Tuple{Base.OneTo{Int64},Base.OneTo{Int64}}}

    end
    @testset "Array Interface" begin
        sqn = SquirrelNoise5()
        A = NoiseArray(sqn, identity, (3,4))

        @test size(A) == (3,4)
        @test length(A) == 12
        @test eltype(A) == UInt32
        @test typeof(getindex(A, 1)) == UInt32
        @test_throws ArgumentError setindex!(A, 1, 1)
    end
end
