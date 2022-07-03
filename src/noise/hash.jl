
"""
    HashNoise

A 64 bits noise function using `Base.hash`.

This noise function depends on the implementation of `Base.hash` in the standard Julia library, so it may change depending on your Julia version. Don't use it if you want to guarrantee reproducibility accross Julia versions.

## Fields
`seed:UInt` seed of the noise function. Note that the constructor uses the hash of its argument to get the seed.

## Examples
```jldoctest
julia> noise(5, HashNoise())
0x63862ec0c596c950

julia> hn = HashNoise(42)
HashNoise(0x0f3db82f1e7b6f7a)

julia> noise(5, hn)
0x9d3bec003a77da92
```
"""
struct HashNoise <: AbstractNoise{UInt}
    seed::UInt
    HashNoise(seed) = new(hash(seed))
end

Base.:(==)(hn1::HashNoise, hn2::HashNoise) = hn1.seed == hn2.seed

HashNoise() = HashNoise(UInt(0))

@inline noise(n::UInt, h::HashNoise) = hash_noise(n, h.seed)

@inline function hash_noise(n::UInt, seed::UInt)
    Base.hash(n, seed)
end