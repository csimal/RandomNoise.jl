using Random123: get_key

"""
    ThreefryNoise{N,T,R} <: AbstractNoise{NTuple{N,T}}

A noise function based on the Threefry family of CBRNGs.

This is a wrapper around [`Threefry2x`](@ref) and [`Threefry4x`](@ref) from [`Random123`](@ref), except it guarrantees immutability.
"""
struct ThreefryNoise{N,T,R} <: AbstractNoise{NTuple{N,T}}
    key::NTuple{N,T}
end

ThreefryNoise(tf::Threefry2x{T,R}) where {T,R} = ThreefryNoise{2,T,R}(get_key(tf))
ThreefryNoise(tf::Threefry4x{T,R}) where {T,R} = ThreefryNoise{4,T,R}(get_key(tf))

@inline function noise(n::NTuple{N,T}, tf::ThreefryNoise{N,T,R}) where {N,T,R}
    threefry(tf.key, n, Val(R))
end


"""
    PhiloxNoise{N,T,R,K} <: AbstractNoise{NTuple{N,T}}

A noise function based on the Philox family of CBRNGs.

This is a wrapper around [`Philox2x`](@ref) and [`Philox4x`](@ref) from [`Random123`](@ref), except it guarrantees immutability.This is a wrapper around 
"""
struct PhiloxNoise{N,T,R,K} <: AbstractNoise{NTuple{N,T}}
    key::K
end

PhiloxNoise(ph::Philox2x{T,R}) where {T,R} = let k = get_key(ph)
    PhiloxNoise{2,T,R, typeof(k)}(k)
end 
PhiloxNoise(ph::Philox4x{T,R}) where {T,R} = let k = get_key(ph)
    PhiloxNoise{4,T,R, typeof(k)}(k)
end 

@inline function noise(n::NTuple{N,T}, ph::PhiloxNoise{N,T,R}) where {N,T,R}
    philox(ph.key, n, Val(R))
end


@static if Random123.R123_USE_AESNI

    """
        AESNINoise <: AbstractNoise{UInt128}

    A wrapper around the [`AESNI1x`](@ref) and [`AESNI4x`](@ref) CRNGs from [`Random123`](@ref).

    Unlike the RNG variants, this noise function always outputs `UInt128`s
    """
    struct AESNINoise <: AbstractNoise{UInt128}
        key::NTuple{11,UInt128}
    end

    AESNINoise(a::Union{AESNI1x,AESNI4x}) = AESNINoise(get_key(a))

    @inline noise(n::UInt128, r::AESNINoise) = aesni(r.key, (n,))[1]

    """
        ARSNoise{R} <: AbstractNoise{UInt128}

    A wrapper around the [`ARS1x`](@ref) and [`ARS4x`](@ref) CRNGs from [`Random123`](@ref).
    """
    struct ARSNoise{N,R,T} <: AbstractNoise{NTuple{N,T}}
        key::Tuple{UInt128}
    end

    ARSNoise(a::ARS1x{R}) where R = ARSNoise{1,R,UInt128}(get_key(a))

    ARSNoise(a::ARS4x{R}) where R = ARSNoise{4,R,UInt32}(get_key(a))

    @inline noise(n::NTuple{N,T}, r::ARSNoise{N,R,T}) where {N,R,T} = ars(r.key, n, Val(R))

end