
@testset "Noise" begin
    @testset "SquirrelNoise5" begin
        @test SquirrelNoise5() == SquirrelNoise5(0x00000000)
        @test SquirrelNoise5(1) == SquirrelNoise5(0x00000001)

        sqn = SquirrelNoise5()
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

    @testset "HashNoise" begin
        @test HashNoise() == HashNoise(0x0000000000000000)
        @test HashNoise(1) == HashNoise(0x0000000000000001)

        hn = HashNoise()
        @test noise(0, hn) == 0x1060bc221fc86ae0
        @test noise(0x0000000000000000, hn) == 0x1060bc221fc86ae0
        @test noise(1, hn) == 0xf45b969ce741991e
        @test noise(0x0000000000000001, hn) == 0xf45b969ce741991e

        hn1 = HashNoise(1)
        @test noise(0, hn1) == 0x64702cb1c95ce026
        @test noise(0x0000000000000000, hn1) == 0x64702cb1c95ce026
        @test noise(1, hn1) == 0x486b072c90d60e64
        @test noise(0x0000000000000001, hn1) == 0x486b072c90d60e64
    end
end