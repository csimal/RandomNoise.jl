
@testset "Noise" begin
    @testset "SquirrelNoise5" begin
        @test SquirrelNoise5() == SquirrelNoise5(0x00000000)
        @test SquirrelNoise5(1) == SquirrelNoise5(0x00000001)

        sqn = SquirrelNoise5()
        @test typeof(noise(0,sqn)) == UInt32
        @test noise(0x00000000, sqn) == 0x16791e00
        @test noise(0, sqn) == 0x16791e00
        @test noise(0x00000001,sqn) == 0xc895cb1d
        @test noise(1, sqn) == 0xc895cb1d

        sqn1 = SquirrelNoise5(1)
        @test noise(0x00000000, sqn1) == 0x23f6c851
        @test noise(0, sqn1) == 0x23f6c851
        @test noise(0x00000001, sqn1) == 0x98b75d40
        @test noise(1, sqn1) == 0x98b75d40
    end

    @testset "SquirrelNoise5x2" begin
        @test SquirrelNoise5x2() == SquirrelNoise5x2(0,1)
        @test_throws DomainError SquirrelNoise5x2(0,0)

        sqn = SquirrelNoise5x2()
        @test typeof(noise(0, sqn)) == UInt64
        @test noise(0, sqn) == 0xd40e6352d9ba8dce
        @test noise(1, sqn) == 0x0f9b5434d68ee534
    end

    @testset "Murmur3Noise" begin
        @test Murmur3Noise() == Murmur3Noise(0x00000000)
        @test Murmur3Noise(1) == Murmur3Noise(0x00000001)

        m3n = Murmur3Noise()
        @test typeof(noise(0, m3n)) == UInt32
        @test noise(0x00000000, m3n) == 0x2362f9de
        @test noise(0, m3n) == noise(0x00000000, m3n)
        @test noise(0x00000001, m3n) == 0xfbf1402a
        @test noise(1, m3n) == noise(0x00000001, m3n)
    end
    @testset "Broadcast" begin
        sqn = SquirrelNoise5()
        @test noise.(1:10, sqn) == [noise(i,sqn) for i in 1:10]
    end
end