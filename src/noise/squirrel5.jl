
"""
    SquirrelNoise5

The SquirrelNoise5 32 bits random noise function, originally by Squirrel Eiserloh.

See http://eiserloh.net/noise/SquirrelNoise5.hpp for the original C++ code.
"""
struct SquirrelNoise5 <: AbstractNoise
    seed::UInt32
end

SquirrelNoise5() = SquirrelNoise5(UInt32(0))

function noise(n::UInt32, s::SquirrelNoise5)
    SQ5_BIT_NOISE1::UInt32 = 0xd2a80a3f
    SQ5_BIT_NOISE2::UInt32 = 0xa884f197
    SQ5_BIT_NOISE3::UInt32 = 0x6C736F4B
    SQ5_BIT_NOISE4::UInt32 = 0xB79F3ABB
    SQ5_BIT_NOISE5::UInt32 = 0x1b56c4f5

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