
"""
    SquirrelNoise5

The SquirrelNoise5 32 bits random noise function, originally by Squirrel Eiserloh.

See http://eiserloh.net/noise/SquirrelNoise5.hpp for the original C++ code.

## Fields
* `seed::UInt32 = 0` seed of the noise function.

## Examples
```jldoctest
julia> noise(0,SquirrelNoise5())
0x16791e00

julia> noise(1,SquirrelNoise5())
0xc895cb1d

julia> noise(0,SquirrelNoise5(32))
0x9ef5c661
```
"""
struct SquirrelNoise5 <: AbstractNoise{UInt32}
    seed::UInt32
    SquirrelNoise5(n) = new(n % UInt32)
end

SquirrelNoise5() = SquirrelNoise5(UInt32(0))

Base.:(==)(sqn1::SquirrelNoise5, sqn2::SquirrelNoise5) = sqn1.seed == sqn2.seed

const SQ5_BIT_NOISE1 = 0xd2a80a3f
const SQ5_BIT_NOISE2 = 0xa884f197
const SQ5_BIT_NOISE3 = 0x6C736F4B
const SQ5_BIT_NOISE4 = 0xB79F3ABB
const SQ5_BIT_NOISE5 = 0x1b56c4f5

@inline function noise(n::UInt32, s::SquirrelNoise5)
    # NB. ⊻ == bitwise xor (\xor<TAB> to get the symbol)
    mangledbits = n
    mangledbits *= SQ5_BIT_NOISE1
    mangledbits += s.seed
    mangledbits ⊻= (mangledbits >> 9)
    mangledbits += SQ5_BIT_NOISE2
    mangledbits ⊻= (mangledbits >> 11)
    mangledbits *= SQ5_BIT_NOISE3
    mangledbits ⊻= (mangledbits >> 13)
    mangledbits += SQ5_BIT_NOISE4
    mangledbits ⊻= (mangledbits >> 15)
    mangledbits *= SQ5_BIT_NOISE5
    mangledbits ⊻= (mangledbits >> 17)

    return mangledbits
end