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

include("utils/convert.jl")
include("noise_rng.jl")

export NoiseRNG

include("utils/transforms.jl")
include("noise_arrays.jl")
export NoiseUniform
export NoiseArray

# Optional wrappers around Random123's CBRNGs.
using Requires

function __init__()
    @require Random123="74087812-796a-5b5d-8853-05524746bad3" include("random123.jl")
    
    @require Distributions="31c24e10-a181-5473-b8eb-7969acd0382f" include("distributions.jl")
end

end
