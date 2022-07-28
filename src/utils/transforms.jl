
@inline function noise_getindex(rng, transform, i::Integer, ::Type{T}) where T
    convert(T, transform(noise(i, rng)))
end

@inline noise_getindex(rng, transform, i::Integer) = transform(noise(i, rng))

"""
    NoiseUniform{T}

The generic transform for converting the default output of noise functions to uniformly distributed values of type `T`.

For floating point numbers, the values are uniformly distributed in the interval [0,1).
"""
struct NoiseUniform{T} end

@inline noise_getindex(rng, ::NoiseUniform{T}, i::Integer) where T = noise_convert(noise(i,rng), T)

@inline noise_getindex(rng, t::NoiseUniform{T}, i::Integer, ::Type{T}) where T = noise_getindex(rng, t, i)