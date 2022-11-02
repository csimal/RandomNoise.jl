using Base.Libc: calloc

# Convert an integer type to a tuple of integers while keeping as many bits as possible.
# The evil pointer fiddling is to make it very fast, as creating new tuples is slower
begin
    local int_types = [Int8, Int16, Int32, Int64, Int128]
    local uint_types = [UInt8, UInt16, UInt32, UInt64, UInt128]
    for i in 1:length(uint_types)-1, j in i+1:length(uint_types)
        U = uint_types[i] |> Symbol
        I = int_types[i] |> Symbol
        T = uint_types[j] |> Symbol
        N = 2^(j-i)
        @eval begin
            @inline function _to_bits(n::NTuple{$N,S})::$T where {S <: Union{$U,$I}}
                unsafe_load(Ptr{$T}(pointer_from_objref(Ref(n))))
            end
            @inline function _to_bits(n::Union{$I,$U})::$U
                n % $U
            end
            @inline function _convert(n::Integer, ::Type{NTuple{$N,$U}})
                unsafe_load(Ptr{NTuple{$N,$U}}(pointer_from_objref(Ref(n % $T))))
            end
            @inline function _convert(n::NTuple{$N,<:Integer}, ::Type{S})::S where {S<:Integer}
                _to_bits(n) % S
            end
        end
    end
    @inline function _convert(n::Union{Int64,UInt64}, ::Type{NTuple{4,UInt64}})::NTuple{4,UInt64}
        (n % UInt64, zero(UInt64), zero(UInt64), zero(UInt64))
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