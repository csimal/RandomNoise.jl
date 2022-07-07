
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

@inline noise(n::UInt32, s::SquirrelNoise5) = squirrel_noise(n, s.seed)

@inline function squirrel_noise(n::UInt32, seed::UInt32)
    # NB. ⊻ == bitwise xor (\xor<TAB> to get the symbol)
    mangledbits = n
    mangledbits *= SQ5_BIT_NOISE1
    mangledbits += seed
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

"""
    SquirrelNoise5x2 <: AbstractNoise{UInt64}

A 64 bits noise function made by stacking two `SquirrelNoise5()` together.

## Fields
* `seed1::UInt32 = 0` the first seed
* `seed2::UInt32 = 1` the second seed

When constructing an instance with both seeds equal, a `DomainError` will be raised.
"""
struct SquirrelNoise5x2 <: AbstractNoise{UInt64}
    seed1::UInt32
    seed2::UInt32
    function SquirrelNoise5x2(m,n)
        if m == n
            throw(DomainError((m,n),"Constructing an instance of SquirrelNoise5x2 with identical seeds ($m). This will harm the quality of the numbers generated."))
        end
        new(m % UInt32,n % UInt32)
    end
end

SquirrelNoise5x2() = SquirrelNoise5x2(UInt32(0),UInt32(1))

@inline function noise(n::UInt64, sqnx2::SquirrelNoise5x2)
    # TODO use something else than Base.hash for reproducibility
    n = Base.hash(n) # scramble the bits to avoid problems with high bits not changing much
    r1 = squirrel_noise((n) % UInt32, sqnx2.seed1)
    r2 = squirrel_noise((n >> 32) % UInt32, sqnx2.seed2)
    UInt64(r1 << 32) + UInt64(r2)
end