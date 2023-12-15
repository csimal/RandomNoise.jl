
# Convert an integer type to a tuple of integers while keeping as many bits as possible.
# The evil pointer fiddling is to make it very fast, as creating new tuples is slower
begin
    local int_types = [Int8, Int16, Int32, Int64, Int128]
    local uint_types = [UInt8, UInt16, UInt32, UInt64, UInt128]
    for i in eachindex(uint_types)
        U = uint_types[i] |> Symbol
        I = int_types[i] |> Symbol
        @eval begin
            @inline function _to_bits(n::Union{$I,$U})::$U
                n % $U
            end
        end
    end
    for i in 1:length(uint_types)-1, j in i+1:length(uint_types)
        U = uint_types[i] |> Symbol
        I = int_types[i] |> Symbol
        T = uint_types[j] |> Symbol
        N = 2^(j-i)
        @eval begin
            @inline function _to_bits(n::NTuple{$N,S})::$T where {S <: Union{$U,$I}}
                unsafe_load(Ptr{$T}(pointer_from_objref(Ref(n))))
            end
            @inline function _convert(n::Integer, ::Type{NTuple{$N,$U}})
                unsafe_load(Ptr{NTuple{$N,$U}}(pointer_from_objref(Ref(n % $T))))
            end

        end
    end
    @inline function _convert(n::Union{Int64,UInt64}, ::Type{NTuple{4,UInt64}})::NTuple{4,UInt64}
        (n % UInt64, zero(UInt64), zero(UInt64), zero(UInt64))
    end
    @inline function _convert(n::Integer, ::Type{Tuple{T}}) where T <: Integer
        (n % T,)
    end
    @inline function _convert(n::NTuple{N,<:Integer}, ::Type{S})::S where {N,S<:Integer}
        _to_bits(n) % S
    end
end

"""
    noise_convert(r::Integer, ::Type{AbstractFloat})

Convert an integer to a floating point number in [0,1).

This is intended to be used with random number generators, so the output is uniformly distributed over [0,1).
"""
function noise_convert end

@inline function noise_convert(r::N, ::Type{Float64}) where {N<:Union{UInt8,UInt16,UInt32}}
    r * exp2(-sizeof(N) << 3)
end

# NB. copied from https://github.com/JuliaLang/julia/blob/701468127a335d130e968a8a180021e4287abf3f/stdlib/Random/src/Xoshiro.jl#L204-L211

@inline function noise_convert(r::UInt16, ::Type{Float16})
    Float16(Float32(r >>> 5) * Float32(0x1.0p-11))
end

@inline function noise_convert(r::UInt32, ::Type{Float32})
    Float32(r >>> 8) * Float32(0x1.0p-24)
end

@inline function noise_convert(r::UInt64, ::Type{Float64})
    Float64(r >>> 11) * 0x1.0p-53
end

# higher density floats when we have enough bits (see below)
@inline function noise_convert(r::UInt32, ::Type{Float16})
    dense_uniform_float_01(r)
end


@inline function noise_convert(r::UInt64, ::Type{Float32})
    dense_uniform_float_01(r)
end

@inline function noise_convert(r::UInt128, ::Type{Float64})
    dense_uniform_float_01(r)
end

#=
Efficient dense Float32 [0,1) sampling https://marc-b-reynolds.github.io/distribution/2017/01/17/DenseFloat.html#the-parts-im-not-tell-you

Explanation:
The idea is to generate a floating point value by first choosing an interval [2^(-k-1),2^-k) which will contain exactly as many values as the significand allows. Since the probability of sampling such interval is 2^-(k+1), we can get k by sampling a (p=0.5) geometric distribution. This can be done efficiently by counting the number of leading zeroes of a random bitstring.

In order to do this efficiently, we take twice as many random bits as the desired type size, reserve as many bits as needed for the significand, and use the rest for the exponent.

For example, for a 32-bit float, we take a 64-bit integer, chop off 23 bits for the significand, and use the remaining 41 bits for the exponent. This means we can get k as high as 40.

With the exception of 16-bit floats, we don't get enough bits to cover all values in [0,1)
=#

"""
    dense_uniform_float_01(n::UInt32)

Generate a 16-bit floating point value in [0,1) from a 32-bit unsigned integer.

The interval [0,1) is densely populated, in the sense that all representable values are generated.
"""
@inline function dense_uniform_float_01(n::UInt32)
    lz = min(leading_zeros(n), 14)
    e::UInt16 = 14 - lz
    m::UInt16 = (n % UInt16) & 0x03ff # (1 << 10) - 1
    reinterpret(Float16, (e << 10) | m)
end

"""
    dense_uniform_float_01(n::UInt64)

Generate a 32-bit floating point value in [0,1) from a 64-bit unsigned integer.

The interval [2^-40, 1) is densely populated (all representable values are generated). The remaining [0,2^-40) interval is equidistantly populated (with distance 2^-64).

"""
@inline function dense_uniform_float_01(n::UInt64)
    lz = leading_zeros(n)
    if lz <= 40
        e::UInt32 = 126 - lz
        m::UInt32 = (n % UInt32) & 0x7fffff # (1 << 23) -1
        return reinterpret(Float32, (e << 23) | m)
    else
        return ldexp(1.0f0, -64) * Float32(n % UInt32)
    end
end

"""
    dense_uniform_float_01(n::UInt128)

Generate a 64-bit floating point value in [0,1) from a 128-bit unsigned integer.

The interval [2^-75, 1) is densely populated (all representable values are generated). The remaining [0,2^-75) interval is equidistantly populated (with distance 2^-128).
"""
@inline function dense_uniform_float_01(n::UInt128)
    lz = leading_zeros(n)
    if lz <= 75
        e::UInt64 = 1022 - lz
        m::UInt64 = (n % UInt64) & 0x000fffffffffffff # (1 << 52) -1
        return reinterpret(Float64, (e << 52) | m)
    else
        return ldexp(1.0, -128) * Float64(n % UInt64)
    end
end
