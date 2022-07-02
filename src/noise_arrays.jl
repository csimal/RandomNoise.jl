using Base: oneto

import Base: axes, size, getindex, setindex!, IndexStyle, show, ==

"""
    NoiseArray{T,N,R,F,Axes} where {
        R <: AbstractNoise,
        Axes <: Tuple{Vararg{AbstractUnitRange,N}}
    }

An `N`-dimensional read only array of random values
"""
struct NoiseArray{T,N,R,F,Axes} <: AbstractArray{T,N} where {
    R <: AbstractNoise,
    Axes <: Tuple{Vararg{AbstractUnitRange,N}}
    }
    noise::R
    transform::F
    axes::Axes
end

function NoiseArray{T,N,R,F}(rng::R, transform::F, sz::Axes) where Axes<:Tuple{Vararg{AbstractUnitRange,N}} where {T,N,R,F}
    NoiseArray{T,N,R,F,Axes}(rng, transform, sz)
end

function NoiseArray{T}(rng::R, transform::F, sz::Vararg{Integer,N}) where {R<:AbstractNoise,T,N,F}
    NoiseArray{T,N,R,F}(rng, transform, oneto.(sz))
end

function NoiseArray{T}(rng::R, transform::F, sz::SZ) where {R<:AbstractNoise,SZ<:Tuple{Vararg{Integer,N}}} where {T,N,F}
    NoiseArray{T,N,R,F}(rng, transform, oneto.(sz))
end

function NoiseArray(rng::R, transform::F, sz::Vararg{Integer,N}) where {R<:AbstractNoise} where {N,F}
    T = typeof(transform(noise(1,rng)))
    NoiseArray{T,N,R,F}(rng, transform, oneto.(sz))
end

function NoiseArray(rng::R, transform::F, sz::SZ) where {R<:AbstractNoise,SZ<:Tuple{Vararg{Integer,N}}} where {N,F}
    T = typeof(transform(noise(1,rng)))
    NoiseArray{T,N,R,F}(rng, transform, oneto.(sz))
end



@inline Base.axes(A::NoiseArray) = A.axes
@inline Base.size(A::NoiseArray, d::Integer) = length(A.axes[d])
@inline Base.size(A::NoiseArray{<:Any,N}) where {N} = length.(A.axes)

IndexStyle(::Type{<:NoiseArray}) = IndexLinear()

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{T}, i::Integer) where T
    @boundscheck checkbounds(A,i)
    convert(T, (A.transform(noise(i,A.noise))))
end

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{T,N,R,NoiseConvert{T}}, i::Integer) where {T,N,R}
    @boundscheck checkbounds(A,i)
    noise_convert(noise(i, A.noise), T)
end

@inline function setindex!(::NoiseArray{T,N}, v, k) where {T,N}
    throw(ArgumentError("Cannot setindex! for a NoiseArray"))
end
