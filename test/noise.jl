
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
        
    end

    @testset "Murmur3Noise" begin
        
    end
end