
@testset "Random123" begin
    @testset "ThreefryNoise" begin
        @testset "Threefry2x" begin
            local tf = Threefry2x()
            local tfn = ThreefryNoise(tf)
            @test typeof(noise(0,tfn)) == Tuple{UInt64,UInt64}
            @test noise(0, tfn) == rand(tf, Tuple{UInt64,UInt64})
        end
        @testset "Threefry4x" begin
            local tf = Threefry4x()
            local tfn = ThreefryNoise(tf)
            @test typeof(noise(0,tfn)) == NTuple{4,UInt64}
        end
    end
    @testset "PhiloxNoise" begin
        @testset "Philox2x" begin
            local ph = Philox2x()
            local phn = PhiloxNoise(ph)
            @test typeof(noise(0, phn)) == NTuple{2,UInt64}
            @test noise(0, phn) == rand(ph, NTuple{2,UInt64})
        end
        @testset "Philox4x" begin
            local ph = Philox4x()
            local phn = PhiloxNoise(ph)
            @test typeof(noise(0, phn)) == NTuple{4,UInt64}
            @test noise(0, phn) == rand(ph, NTuple{4,UInt64})
        end
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
                @test typeof(noise(0, arsn)) == Tuple{UInt128}
                @test noise(1, arsn) == rand(ars, Tuple{UInt128})
            end
            @testset "ARS4x" begin
                local ars = ARS4x()
                local arsn = ARSNoise(ars)
                x = UInt32.((0,1,2,3))
                @test typeof(noise(x, arsn)) == NTuple{4,UInt32}
                # ???
                @test noise(0, arsn) == rand(ars, NTuple{4,UInt32})
            end
        end
    end
end