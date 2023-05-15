module DistributionsExt

using RandomNoise
using RandomNoise: noise_convert
import RandomNoise: NoiseMap, noise_getindex
isdefined(Base, :get_extension) ? (using Distributions) : (using ..Distributions)

"""
    NoiseMap(rng::AbstractNoise, d::UnivariateDistribution, dim::Integer)

Return a `NoiseMap` of dimension `dim` whose elements are samples from the univariate distribution `d`.

# Examples
```jldoctest
julia> using RandomNoise, Distributions

julia> nm1 = NoiseMap(SquirrelNoise5(), Bernoulli(0.5), 1)
NoiseMap{Bool, 1, SquirrelNoise5, Bernoulli{Float64}}(SquirrelNoise5(0x00000000), Bernoulli{Float64}(p=0.5))

julia> nm1.(1:10)
10-element BitVector:
 0
 0
 0
 0
 0
 0
 0
 1
 1
 0

julia> nm2 = NoiseMap(sqn, Poisson(5), 1)
NoiseMap{Int64, 1, SquirrelNoise5, Poisson{Float64}}(SquirrelNoise5(0x00000000), Poisson{Float64}(λ=5.0))

julia> nm2.(1:10)
10-element Vector{Int64}:
 7
 6
 5
 6
 5
 6
 6
 4
 1
 8

```
"""
function NoiseMap(rng::R, d::Distributions.UnivariateDistribution, N::Integer = 1) where {R}
    T = eltype(d)
    NoiseMap{T,N,R,typeof(d)}(rng, d)
end

@inline noise_getindex(rng::AbstractNoise, d::Distributions.UnivariateDistribution, i) = Distributions.quantile(d, noise_convert(noise(i,rng), Float64))

# override to guarantee Bool output type
@inline noise_getindex(rng::AbstractNoise, d::Distributions.Bernoulli, i) = isless(noise_convert(noise(i,rng), Float64), d.p)

end # module