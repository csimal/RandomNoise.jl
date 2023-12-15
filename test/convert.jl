import RandomNoise: noise_convert, _to_bits, _convert, dense_uniform_float_01

@testset "Conversion" begin
    @testset "to_bits" begin
        uints = [UInt8,UInt16,UInt32,UInt64,UInt128]
        ints = [Int8,Int16,Int32,Int64,Int128]
        for (U,I) in zip(uints, ints)
            @test _to_bits(I(1)) == U(1)
            @test check(itype(I)) do i
                _to_bits(i) == (i % U)
            end
        end
        for i in 1:length(uints)-1, j in i+1:length(uints)
            U = uints[i]
            I = ints[i]
            T = uints[j]
            N = 2^(j-i)
            @test typeof(_to_bits(tuple(ones(I,N)...))) == T
            @test typeof(_to_bits(tuple(ones(U,N)...))) == T
            @test check(PropCheck.tuple(iconst(N), itype(U))) do x
                typeof(_to_bits(x)) == T
            end
        end
    end
    @testset "noise_convert" begin
        uints = [UInt8,UInt16,UInt32,UInt64]
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
        uints = [UInt8,UInt16,UInt32,UInt64,UInt128]
        ints = [Int8,Int16,Int32,Int64,Int128]
        for i in 1:length(uints)-1, j in i+1:length(uints)
            U = uints[i]
            I = ints[i]
            T = uints[j]
            N = 2^(j-i)
            @test typeof(_convert(T(1), NTuple{N,U})) == NTuple{N,U}
            @test typeof(_convert(tuple(ones(U,N)...), T)) == T
            @test check(itype(T)) do n
                _convert(_convert(n, NTuple{N,U}), T) == n
            end
        end
    end
    @testset "dense_uniform_float_01" begin
        types = [(Float16,UInt32), (Float32,UInt64), (Float64,UInt128)]
        #prop_type(T) =  x -> typeof(dense_uniform_float_01(x)) == T
        #prop_is01(x) = 0 <= dense_uniform_float_01(x) < 1
        for (F,U) in types
            @test check(itype(U)) do n
                typeof(dense_uniform_float_01(n)) == F
            end
            @test check(itype(U)) do n
                0 <= dense_uniform_float_01(n) < 1
            end
        end
    end
end
