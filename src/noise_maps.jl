import Base: getindex

"""
    NoiseMap{T,N,R,F}

An `N`-dimensional infinite stream of random values.

This works exactly like `NoiseArray` but has no bounds.
"""
struct NoiseMap{T,N,R,F}
    noise::R
    transform::F
end

NoiseMap{T,N}(rng::R, transform::F) where {T,N,R,F} = NoiseMap{T,N,R,F}(rng, transform)

NoiseMap{T}(rng::R, transform::F, N::Integer) where {T,R,F} = NoiseMap{T,N,R,F}(rng, transform)

function NoiseMap(rng::R, transform::F, dim::Integer) where {R,F}
    T = typeof(transform(noise(1, rng)))
    NoiseMap{T,dim,R,F}(rng, transform)
end

NoiseMap(rng, dim::Integer) = NoiseMap(rng, identity, dim)

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