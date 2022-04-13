module RandomNoise

include("noise/AbstractNoise.jl")

export AbstractNoise
export noise

include("noise/squirrel5.jl")
include("noise/hash.jl")

export SquirrelNoise5, HashNoise

include("utils/pairing_functions.jl")
#include("noise_functions.jl")

#export NoiseFunction

include("noise_rng.jl")

export NoiseRNG

# Optional wrappers around Random123's CBRNGs.
using Requires

function __init__()
    @require Random123="74087812-796a-5b5d-8853-05524746bad3" include("random123.jl")
end

end
