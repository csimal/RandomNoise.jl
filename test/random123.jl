
@testset "Random123" begin
    @testset "Threefry2x" begin
        local rng = Threefry2x()
        @test typeof(noise(0,rng)) == UInt64
    end
    @testset "Threefry4x" begin
        local rng = Threefry4x()
        @test typeof(noise(0, rng)) == UInt64
    end
    @testset "Philox2x" begin
        local rng = Philox2x()
        @test typeof(noise(0,rng)) == UInt64
    end
    @testset "Philox4x" begin
        local rng = Philox4x()
        @test typeof(noise(0,rng)) == UInt64
    end
end