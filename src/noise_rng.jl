import Random
import Random: AbstractRNG, rand, UInt52, rng_native_52

# NB. copied from https://github.com/JuliaRandom/RandomNumbers.jl/blob/master/src/common.jl
const BitTypes = Union{Bool, UInt8, UInt16, UInt32, UInt64, UInt128, Int8, Int16, Int32, Int64, Int128}

"""
    NoiseRNG{N,T} <: AbstractRNG where {N,T<:AbstractNoise{N}}

Wrapper type to use a noise function as a rng for use in `rand()`.

## Fields
* `noise::T` : the noise function.
* `counter::N = zero(N)` : a counter indicating where the sequence of generated numbers is currently at.


## Examples
```jldoctest
julia> rng = NoiseRNG(SquirrelNoise5())
NoiseRNG{UInt32, SquirrelNoise5}(SquirrelNoise5(0x00000000), 0x00000000)

julia> rand(rng)
0.08778560161590576
````
"""
mutable struct NoiseRNG{N,T} <: AbstractRNG where {N,T<:AbstractNoise{N}}
    noise::T
    counter::N
end

NoiseRNG(noise::AbstractNoise{N}) where {N} = NoiseRNG(noise, zero(N))

Base.:(==)(rng1::NoiseRNG{N,T}, rng2::NoiseRNG{N,T}) where {N,T} = (rng1.noise == rng2.noise) && (rng1.counter == rng2.counter)

Base.copy(rng::NoiseRNG) = NoiseRNG(rng.noise,rng.counter)

function Base.copy!(dst::NoiseRNG{N,T}, src::NoiseRNG{N,T}) where {N,T}
    dst.noise = src.noise
    dst.counter = src.counter
    dst
end

@inline function rand(rng::NoiseRNG{N,T}, ::Type{N}) where {N<:BitTypes,T<:AbstractNoise{N}}
    rng.counter += one(T)
    noise(rng.counter-1, rng.noise)
end


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
    noise_convert(rand(rng, UInt64), Float64)
end

@inline function rand(rng::NoiseRNG{N,T}, ::Type{Float64}=Float64) where {N<:Union{UInt8,UInt16,UInt32}, T}
    noise_convert(rand(rng, N), Float64)
end