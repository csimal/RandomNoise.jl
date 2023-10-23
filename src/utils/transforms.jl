
@inline function noise_getindex(rng::AbstractNoise, transform, i, ::Type{T}) where T
    convert(T, transform(noise(i, rng)))
end

@inline noise_getindex(rng::AbstractNoise, transform, i) = transform(noise(i, rng))

"""
    NoiseUniform{T}

The generic transform for converting the default output of noise functions to uniformly distributed values of type `T`.

For floating point numbers, the values are uniformly distributed in the interval [0,1).
"""
struct NoiseUniform{T<:AbstractFloat} end

NoiseUniform() = NoiseUniform{Float64}()

@inline (::NoiseUniform{T})(n) where T = noise_convert(n, T)
