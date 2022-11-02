import RandomNoise: noise_convert

@testset "Conversion" begin
   @testset "noise_convert" begin
      @test typeof(noise_convert(0x01, Float64)) == Float64 
      @test noise_convert(0x00, Float64) == 0.0
      @test noise_convert(typemax(UInt8), Float64) < 1.0

      @test typeof(noise_convert(0x0001, Float64)) == Float64 
      @test noise_convert(0x0000, Float64) == 0.0
      @test noise_convert(typemax(UInt16), Float64) < 1.0

      @test typeof(noise_convert(0x0000001, Float64)) == Float64 
      @test noise_convert(0x00000000, Float64) == 0.0
      @test noise_convert(typemax(UInt32), Float64) < 1.0

      @test typeof(noise_convert(0x0001, Float16)) == Float16
      @test noise_convert(0x0000, Float16) == Float16(0.0)
      @test noise_convert(typemax(UInt16), Float16) < 1.0

      @test typeof(noise_convert(0x00000001, Float32)) == Float32
      @test noise_convert(0x00000000, Float32) == Float32(0.0)
      @test noise_convert(typemax(UInt32), Float32) < 1.0

      @test typeof(noise_convert(0x0000000000000001, Float64)) == Float64
      @test noise_convert(0x0000000000000000, Float64) == 0.0
      @test noise_convert(typemax(UInt64), Float64) < 1.0
   end
   @testset "_convert" begin
      #@test typeof(_convert())
   end
end