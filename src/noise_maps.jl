import Base: getindex

"""
    NoiseMap{T,N,R,F}

An `N`-dimensional infinite stream of random values.

# Fields
- `noise` an noise function used to generate the base stream of random numbers
- `transform` a function that is applied to the output of the noise function to obtain the result

Transforms can be
- Arbitrary functions
- An instance of `NoiseUniform`, in which case, the values are floating point numbers uniformly distributed in the interval [0,1).
- An instance of `Distributions.UnivariateDistribution`, in which case the values are samples from that distribution.

# Examples
```jldoctest
julia> nm = NoiseMap(sqn)
NoiseMap{UInt32, 1, SquirrelNoise5, typeof(identity)}(SquirrelNoise5(0x00000000), identity)
```
"""
struct NoiseMap{T,N,R<:AbstractNoise,F}
    noise::R
    transform::F
end

NoiseMap{T,N}(rng::R, transform::F) where {T,N,R,F} = NoiseMap{T,N,R,F}(rng, transform)

NoiseMap{T}(rng::R, transform::F, N::Integer = 1) where {T,R,F} = NoiseMap{T,N,R,F}(rng, transform)

function NoiseMap(rng::R, transform::F, N::Integer = 1) where {R,F}
    T = typeof(transform(noise(1, rng)))
    NoiseMap{T,N,R,F}(rng, transform)
end

NoiseMap(rng, dim::Integer = 1) = NoiseMap(rng, identity, dim)

NoiseMap(rng::R, t::NoiseUniform{T}, N::Integer = 1) where {R,T} = NoiseMap{T,N,R,NoiseUniform{T}}(rng, t)

@inline (nm::NoiseMap)(n::Integer) = noise_getindex(nm.noise, nm.transform, n)

@inline (nm::NoiseMap{T,2})(a, b) where T = nm(pairing2(a,b))
@inline (nm::NoiseMap{T,3})(a, b, c) where T = nm(pairing3(a,b,c))
@inline (nm::NoiseMap{T,4})(a, b, c, d) where T = nm(pairing4(a,b,c,d))
@inline (nm::NoiseMap{T,5})(a,b,c,d,e) where T = nm(pairing5(a,b,c,d,e))
@inline (nm::NoiseMap{T,6})(a,b,c,d,e,f) where T = nm(pairing6(a,b,c,d,e,f))
@inline (nm::NoiseMap{T,7})(a,b,c,d,e,f,g) where T = nm(pairing7(a,b,c,d,e,f,g))
@inline (nm::NoiseMap{T,8})(a,b,c,d,e,f,g,h) where T = nm(pairing8(a,b,c,d,e,f,g,h))

@inline (nm::NoiseMap)(idx::Tuple{Vararg{Integer,N}}) where N = nm(idx...)

@inline (nm::NoiseMap)(idx...) = nm(pairing(idx...))

@inline getindex(nm::NoiseMap, idx...) = nm(idx...)