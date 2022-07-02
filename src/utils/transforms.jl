
"""
    NoiseUniform{T}

The generic transform for converting the default output of noise functions to uniformly distributed values of type `T`.

For floating point numbers, the values are uniformly distributed in the interval [0,1).
"""
struct NoiseUniform{T} end
