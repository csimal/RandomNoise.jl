
"""
    AbstractNoise

Supertype for random noise functions. T indicates the return type.
"""
abstract type AbstractNoise{T<:Number} end

"""
    noise(n, noise::AbstractNoise)

Compute noise function `noise` at position `n`.
"""
function noise end