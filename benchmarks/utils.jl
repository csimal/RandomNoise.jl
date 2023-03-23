using RNGTest: wrap, bigcrushTestU01
using BenchmarkTools
using RandomNoise
using Random

function wrap_noise(rng::AbstractNoise{T}) where T
    return wrap(NoiseRNG(rng), T)
end

function bigcrush(rng::AbstractNoise)
    bigcrushTestsU01(wrap_noise(rng))
end

function speed_test(noise::AbstractNoise{T}, n = 100_000_000) where {T}
    a = Vector{T}(undef, n)
    rng = NoiseRNG(noise)
    rand!(rng, a)
    return @benchmark rand!(rng, a)
end