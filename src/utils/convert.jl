

"""
    noise_convert(r::Integer, ::Type{AbstractFloat})

Convert an integer to a floating point number in [0,1).

This is intended to use with random number generators, so the output is uniformly distributed over [0,1).
"""
function noise_convert end

function noise_convert(r::N, ::Type{Float64}) where {N<:Union{UInt8,UInt16,UInt32}}
    r * exp2(-sizeof(N) << 3)
end

# NB. copied from https://github.com/JuliaLang/julia/blob/701468127a335d130e968a8a180021e4287abf3f/stdlib/Random/src/Xoshiro.jl#L204-L211

function noise_convert(r::UInt16, ::Type{Float16})
    Float16(Float32(r >>> 5) * Float32(0x1.0p-11))
end

function noise_convert(r::UInt32, ::Type{Float32})
    Float32(r >>> 8) * Float32(0x1.0p-24)
end

function noise_convert(r::UInt64, ::Type{Float64})  
    Float64(r >>> 11) * 0x1.0p-53
end