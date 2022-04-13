import Random
import Random: AbstractRNG, rand, UInt52, rng_native_52

mutable struct NoiseRNG{N,T} <: AbstractRNG where {N,T<:AbstractNoise{N}}
    noise::T
    counter::N
end

NoiseRNG(noise::AbstractNoise{N}) where {N} = NoiseRNG(noise, zero(N))

@inline function rand(rng::NoiseRNG{N,T}, ::Type{N}) where {N<:BitTypes,T<:AbstractNoise{N}}
    rng.counter += 1
    noise(rng.counter-1, rng.noise)
end

# NB. copied from https://github.com/JuliaRandom/RandomNumbers.jl/blob/master/src/common.jl
const BitTypes = Union{Bool, UInt8, UInt16, UInt32, UInt64, UInt128, Int8, Int16, Int32, Int64, Int128}

rng_native_52(::NoiseRNG) = UInt64
rand(rng::NoiseRNG, ::Random.SamplerType{T}) where {T<:BitTypes} = rand(rng,T)

@inline function rand(rng::NoiseRNG{N1,T}, ::Type{N2}) where {N1<:BitTypes, N2<:BitTypes,T}
    s1 = sizeof(N1)
    s2 = sizeof(N2)
    t = rand(rng,N1) % N2
    s1 > s2 && return t
    for i in 2:(s2 ÷ s1)
        t |= (rand(rng, N1) % N2) << ((s1 << 3) * (i-1))
    end
    t
end

@inline function rand(rng::NoiseRNG{N,T}, ::Type{Float64}=Float64) where {N<:Union{UInt64,UInt128},T}
    reinterpret(Float64, Base.exponent_one(Float64) | rand(rng, UInt52())) - 1.0
end

@inline function rand(rng::NoiseRNG{N,T}, ::Type{Float64}=Float64) where {N<:Union{UInt8,UInt16,UInt32}, T}
    rand(rng, N) * exp2(-sizeof(N) << 3)
end