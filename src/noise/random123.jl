using Random123: get_key


struct ThreefryNoise{N,T,R} <: AbstractNoise{NTuple{N,T}}
    key::NTuple{N,T}
end

ThreefryNoise(tf::Threefry2x{T,R}) where {T,R} = ThreefryNoise{2,T,R}(get_key(tf))
ThreefryNoise(tf::Threefry4x{T,R}) where {T,R} = ThreefryNoise{4,T,R}(get_key(tf))

@inline function noise(n::NTuple{N,T}, tf::ThreefryNoise{N,T,R}) where {N,T,R}
    threefry(tf.key, n, Val(R))
end



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
    struct AESNINoise <: AbstractNoise{UInt128}
        key::NTuple{11,UInt128}
    end

    AESNINoise(a::Union{AESNI1x,AESNI4x}) = AESNINoise(get_key(a))

    @inline noise(n::UInt128, r::AESNINoise) = aesni(r.key, (n,))[1]

    struct ARSNoise{R} <: AbstractNoise{UInt128}
        key::Tuple{UInt128}
    end

    ARSNoise(a::Union{ARS1x{R},ARS4x{R}}) where R = ARSNoise{R}(get_key(a))

    @inline noise(n::UInt128, r::ARSNoise{R}) where R = ars(r.key, (n,), Val(R))[1]

end