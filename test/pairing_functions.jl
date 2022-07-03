using RandomNoise: pairing2, pairing3, pairing4, pairing5, pairing6, pairing7, pairing8, pairing

@testset "Pairing Functions" begin
    @testset "pairing2" begin
        @test typeof(pairing2(1,1)) == Int
        @test pairing2(1,1) == 1
        @test pairing2(1,2) == 2
        @test pairing2(2,1) == 3
    end
    @testset "pairing3" begin
        @test typeof(pairing3(1,1,1)) == Int
        @test pairing3(1,1,1) == 1
        @test pairing3(1,1,2) == 2
        @test pairing3(2,1,1) == 6
        @test pairing3(1,2,1) == 3
    end
    @testset "pairing4" begin
        @test typeof(pairing4(1,1,1,1)) == Int
        @test pairing4(1,1,1,1) == 1
        @test pairing4(2,1,1,1) == 6
        @test pairing4(1,2,1,1) == 3
        @test pairing4(1,1,2,1) == 4
        @test pairing4(1,1,1,2) == 2
    end
    @testset "pairing5" begin
        @test typeof(pairing5(1,1,1,1,1)) == Int
        @test pairing5(1,1,1,1,1) == 1
        @test pairing5(2,1,1,1,1) == 6
        @test pairing5(1,2,1,1,1) == 3
        @test pairing5(1,1,2,1,1) == 16
        @test pairing5(1,1,1,2,1) == 4
        @test pairing5(1,1,1,1,2) == 2
    end
    @testset "pairing6" begin
        @test typeof(pairing6(1,1,1,1,1,1)) == Int
        @test pairing6(1,1,1,1,1,1) == 1
        @test pairing6(2,1,1,1,1,1) == 6
        @test pairing6(1,2,1,1,1,1) == 3
        @test pairing6(1,1,2,1,1,1) == 16
        @test pairing6(1,1,1,2,1,1) == 4
        @test pairing6(1,1,1,1,2,1) == 7
        @test pairing6(1,1,1,1,1,2) == 2
    end
    @testset "pairing7" begin
        @test typeof(pairing7(1,1,1,1,1,1,1)) == Int
        @test pairing7(1,1,1,1,1,1,1) == 1
        @test pairing7(2,1,1,1,1,1,1) == 21
        @test pairing7(1,2,1,1,1,1,1) == 6
        @test pairing7(1,1,2,1,1,1,1) == 3
        @test pairing7(1,1,1,2,1,1,1) == 16
        @test pairing7(1,1,1,1,2,1,1) == 4
        @test pairing7(1,1,1,1,1,2,1) == 7
        @test pairing7(1,1,1,1,1,1,2) == 2
    end
    @testset "pairing8" begin
        @test typeof(pairing8(1,1,1,1,1,1,1,1)) == Int
        @test pairing8(1,1,1,1,1,1,1,1) == 1
    end
    @testset "pairing" begin
        @test typeof(pairing(1,1)) == Int
        @test pairing(1) == 1
        @test pairing(1,1) == 1

        @test pairing((1,1)) == pairing(1,1)

        @test pairing(1,2) == pairing2(1,2)
        @test pairing(1,2,3) == pairing3(1,2,3)
        @test pairing(1,2,3,4) == pairing4(1,2,3,4)
    end
end