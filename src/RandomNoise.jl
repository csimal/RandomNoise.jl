module RandomNoise

import Random: AbstractRNG, rand

include("noise/AbstractNoise.jl")

export AbstractNoise

include("noise/squirrel5.jl")
include("noise/hash.jl")

export SquirrelNoise5, HashNoise

include("noise_rng.jl")

export NoiseRNG

end
