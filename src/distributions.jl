

@inline noise_getindex(rng, d::Distributions.UnivariateDistribution, i) = Distributions.quantile(d, noise_convert(noise(i,rng), Float64))

@inline noise_getindex(rng, d::Distributions.Bernoulli, i) = isless(noise_convert(noise(i,rng), Float64), d.p)