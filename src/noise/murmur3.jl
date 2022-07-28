
"""
    Murmur3Noise

A 32-bit noise function based on the Murmur3 hash function.

## Fields
* `seed::UInt32 = 0`

## Examples
```jldoctest
julia> m3n = Murmur3Noise()
Murmur3Noise(0x00000000)

julia> noise(0, m3n)
0x2362f9de

julia> noise(1, m3n)
0xfbf1402a
```

```jldoctest
julia> m3n = Murmur3Noise(42)
Murmur3Noise(0x0000002a)

julia> noise(0, m3n)
0x379fae8f

julia> noise(1, m3n)
0xdea578e3
```
"""
struct Murmur3Noise <: AbstractNoise{UInt32}
    seed::UInt32
    Murmur3Noise(n) = new(n % UInt32)
end

Murmur3Noise() = Murmur3Noise(UInt32(0))

noise(n::UInt32, mn::Murmur3Noise) = murmur3_noise(n, mn.seed)

const MURMUR3_BITS_1 = 0xcc9e2d51
const MURMUR3_BITS_2 = 0x1b873593
const MURMUR3_BITS_3 = 0xe6546b64
const MURMUR3_BITS_4 = 0x85ebca6b
const MURMUR3_BITS_5 = 0xc2b2ae35

function murmur3_scramble(k::UInt32)
    k *= MURMUR3_BITS_1
    k = (k << 15) | (k >> 17)
    k *= MURMUR3_BITS_2
    return k
end

function murmur3_noise(n::UInt32, seed::UInt32)
    h::UInt32 = seed
    h ⊻= murmur3_scramble(n)
    h = (h << 13) | (h >> 19)
    h = h * UInt32(5) + MURMUR3_BITS_3

    h ⊻= UInt32(4) # We're only hashing a single UInt32, so 4 bytes
    h ⊻= (h >> 16)
    h *= MURMUR3_BITS_4
    h ⊻= (h >> 13)
    h *= MURMUR3_BITS_5
    h ⊻= (h >> 16)
    return h
end