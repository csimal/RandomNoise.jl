
"""
    AbstractNoise{T<:Integer}

Supertype for random noise functions. T indicates the return type.
"""
abstract type AbstractNoise{T<:Integer} end

"""
    noise(n, noise::AbstractNoise)

Compute noise function `noise` at position `n`.

## Examples
```jldoctest
julia> sqn = SquirrelNoise5()
SquirrelNoise5(0x00000000)

julia> noise(5, sqn)
0x933e65af
```
"""
function noise(n, nf::AbstractNoise{T}) where T
    noise(n % T, nf)
end
