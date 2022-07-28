module RandomNoise

include("noise/AbstractNoise.jl")

export AbstractNoise
export noise

include("noise/squirrel5.jl")
include("noise/murmur3.jl")

export SquirrelNoise5, SquirrelNoise5x2, Murmur3Noise

include("utils/pairing_functions.jl")
include("noise_maps.jl")

export NoiseMap

include("utils/convert.jl")
include("noise_rng.jl")

export NoiseRNG

include("utils/transforms.jl")
export NoiseUniform

using Requires

function __init__()
    # Optional wrappers around Random123's CBRNGs.
    @require Random123="74087812-796a-5b5d-8853-05524746bad3" include("random123.jl")
    
    # Optional support for Distributions
    @require Distributions="31c24e10-a181-5473-b8eb-7969acd0382f" include("distributions.jl")
end

end
