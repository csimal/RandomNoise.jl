using Random123: get_key

"""
    ThreefryNoise{N,T,R} <: AbstractNoise{NTuple{N,T}}

A noise function based on the Threefry family of CBRNGs.

This is a wrapper around [`Threefry2x`](@ref) and [`Threefry4x`](@ref) from [`Random123`](@ref), except it guarrantees immutability.

## Examples
```jldoctest
julia> tf = Threefry2x()
Threefry2x{UInt64, 20}(0x2e5a37d3f55d93a2, 0xb2eabf28f8527ba2, 0x7c000c9ca153ea29, 0xe5cc75bfdad28187, 0x0000000000000000, 0x0000000000000000, 0)

julia> tfn = ThreefryNoise(tf)
ThreefryNoise{2, UInt64, 20}((0x7c000c9ca153ea29, 0xe5cc75bfdad28187))

julia> noise(1, tfn)
(0xfdef457ec97615d8, 0x9813921752436c1c)
```
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

This is a wrapper around [`Philox2x`](@ref) and [`Philox4x`](@ref) from [`Random123`](@ref), except it guarrantees immutability.

## Examples
```jldoctest
julia> ph = Philox2x()
Philox2x{UInt64, 10}(0x4d6efe7f510f82b6, 0xd79c03fecfefaf49, 0x429f6e3e1bf363f1, 0x0000000000000000, 0x0000000000000000, 0)

julia> phn = PhiloxNoise(ph)
PhiloxNoise{2, UInt64, 10, Tuple{UInt64}}((0x429f6e3e1bf363f1,))

julia> noise(1, phn)
(0x968ebada8eb2b209, 0xd0669e24b96570df)
```
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

    Unlike the RNG variants, this noise function always outputs `UInt128`s.

    ## Examples
    ```jldoctest
    julia> aesni = AESNI1x()
    ...

    julia> an = AESNINoise(aesni)
    AESNINoise((0xcf9fea1bd8f46e10d09b5d0b2f964de2, 0x47ec4f648873a57f5087cb6f801c9664, 0x5ca479961b4836f2933b938dc3bc58e2, 0x8721cdb9db85b42fc0cd82dd53f61150, 0x998817ae1ea9da17c52c6e3805e1ece5, 0xa3028b843a8a9c2a2423463de10f2805, 0x03ae0e8ba0ac850f9a261925be055f18, 0xba5a2952b9f427d91958a2d6837ebbf3, 0x997ca98b232680d99ad2a700838a05d6, 0x9eec9b4c079032c724b6b21ebe64151e, 0x2aa5c0a9b4495be5b3d96922976fdb3c))

    julia> noise(1, an)
    0x323c251c4b24a822810f49c50f6d9116
    ```
    """
    struct AESNINoise <: AbstractNoise{UInt128}
        key::NTuple{11,UInt128}
    end

    AESNINoise(a::Union{AESNI1x,AESNI4x}) = AESNINoise(get_key(a))

    @inline noise(n::UInt128, r::AESNINoise) = aesni(r.key, (n,))[1]

    """
        ARSNoise{R} <: AbstractNoise{UInt128}

    A wrapper around the [`ARS1x`](@ref) and [`ARS4x`](@ref) CRNGs from [`Random123`](@ref).

    ## Examples
    ```jldoctest
    julia> ars = ARS1x()
    ARS1x{7}((VecElement{UInt64}(0x0589cb79dfcb3d8e), VecElement{UInt64}(0x5a9b6b4946d5cc90)), (VecElement{UInt64}(0x0000000000000000), VecElement{UInt64}(0x0000000000000000)), (VecElement{UInt64}(0x83db393c26127302), VecElement{UInt64}(0xc39b0808d6985d5e)))

    julia> arsn = ARSNoise(ars)
    ARSNoise{1, 7, UInt128}((0xc39b0808d6985d5e83db393c26127302,))

    julia> noise(1, arsn)
    (0x32a70590bb9d50acb18a3c61f2c7fc92,)
    ```
    """
    struct ARSNoise{N,R,T} <: AbstractNoise{NTuple{N,T}}
        key::Tuple{UInt128}
    end

    ARSNoise(a::ARS1x{R}) where R = ARSNoise{1,R,UInt128}(get_key(a))

    ARSNoise(a::ARS4x{R}) where R = ARSNoise{4,R,UInt32}(get_key(a))

    @inline noise(n::NTuple{N,T}, r::ARSNoise{N,R,T}) where {N,R,T} = _convert(ars(r.key, tuple(_to_bits(n)), Val(R))[1], NTuple{N,T})
    @inline noise(n::Integer, r::ARSNoise{N,R,T}) where {N,R,T} = _convert(ars(r.key, tuple(n % UInt128), Val(R))[1], NTuple{N,T})

end