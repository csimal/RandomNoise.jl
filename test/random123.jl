
@testset "Random123" begin
    @testset "ThreefryNoise" begin
        @testset "Threefry2x" begin
            local tf = Threefry2x()
            local tfn = ThreefryNoise(tf)
            @test typeof(noise(0,tfn)) == UInt128
            @test noise(1, tfn) == rand(tf, UInt128)
        end
        @testset "Threefry4x" begin
            local tf = Threefry4x()
            local tfn = ThreefryNoise(tf)
            @test typeof(noise(0,tfn)) == UInt128
        end
    end
    @testset "PhiloxNoise" begin
        
    end
    if Random123.R123_USE_AESNI
        @testset "AESNINoise" begin
            @testset "AESNI1x" begin
                local aesni = AESNI1x()
                local an = AESNINoise(aesni)
                @test typeof(noise(0,an)) == UInt128
                @test noise(1,an) == rand(aesni, UInt128)
            end
        end
        @testset "ARSNoise" begin
            @testset "ARS1x" begin
                local ars = ARS1x()
                local arsn = ARSNoise(ars)
                @test typeof(noise(0, arsn)) == UInt128
                @test noise(1, arsn) == rand(ars, UInt128)
            end
        end
    end
end