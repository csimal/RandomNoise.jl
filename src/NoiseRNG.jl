module NoiseRNG

import Random: AbstractRNG, rand

include("noise/AbstractNoise.jl")
include("noise/squirrel5.jl")
include("noise/hash.jl")

export AbstractNoise
export SquirrelNoise5, HashNoise

include("noise_rng.jl")

export NoiseRNG

end
