
"""
    HashNoise

A noise function using Base.hash
"""
struct HashNoise <: AbstractNoise
    seed::UInt
end

HashNoise() = HashNoise(UInt(0))

function noise(n, h::HashNoise)
    Base.hash(n, h.seed)
end