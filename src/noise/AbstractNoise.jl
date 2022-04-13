
"""
    AbstractNoise

Supertype for random noise functions. T indicates the return type.
"""
abstract type AbstractNoise{T<:Integer} end

"""
    noise(n, noise::AbstractNoise)

Compute noise function `noise` at position `n`.
"""
function noise(n, nf::AbstractNoise{T}) where T
    noise(n % T, nf)
end
