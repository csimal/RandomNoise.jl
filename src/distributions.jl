import Base: getindex

function NoiseArray(rng, d::Distributions.UnivariateDistribution, sz...)
    T = typeof(Distributions.quantile(d,0.5))
    NoiseArray{T}(rng, d, sz...)
end

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{T,N,R,F}, i::Integer) where {F<:Distributions.UnivariateDistribution} where {T,N,R}
    @boundscheck checkbounds(A,i)
    Distributions.quantile(A.transform, noise_convert(noise(i, A.noise), Float64))
end

# Override for Bernoulli because quantile(Bernoulli) returns Float64 instead of Bool

NoiseArray(rng, d::Distributions.Bernoulli, sz...) = NoiseArray{Bool}(rng, d, sz...)

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{Bool,N,R,F}, i::Integer) where {N,R,F<:Distributions.Bernoulli}
    @boundscheck checkbounds(A,i)
    isless(noise_convert(noise(i, A.noise), Float64), A.transform.p)
end