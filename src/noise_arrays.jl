using Base: OneTo

import Base: axes, size, getindex, setindex!, IndexStyle, show, ==

"""
    NoiseArray{T,N,R,F,Axes} where {
        Axes <: Tuple{Vararg{AbstractUnitRange,N}}
    }

An `N`-dimensional read only array of random values
"""
struct NoiseArray{T,N,R,F,Axes} <: AbstractArray{T,N} where {
    Axes <: Tuple{Vararg{AbstractUnitRange,N}}
    }
    noise::R
    transform::F
    axes::Axes
end

function NoiseArray{T,N,R,F}(rng::R, transform::F, sz::Axes) where Axes<:Tuple{Vararg{AbstractUnitRange,N}} where {T,N,R,F}
    NoiseArray{T,N,R,F,Axes}(rng, transform, sz)
end

function NoiseArray{T}(rng::R, transform::F, sz::Vararg{Integer,N}) where {T,N,R,F}
    NoiseArray{T,N,R,F}(rng, transform, OneTo.(sz))
end

function NoiseArray{T}(rng::R, transform::F, sz::SZ) where {SZ<:Tuple{Vararg{Integer,N}}} where {T,N,R,F}
    NoiseArray{T,N,R,F}(rng, transform, OneTo.(sz))
end

function NoiseArray(rng, transform::F, sz...) where {F}
    T = typeof(transform(noise(1,rng)))
    NoiseArray{T}(rng, transform, sz...)
end

function NoiseArray(rng, transform::NoiseUniform{T}, sz...) where {T}
    NoiseArray{T}(rng, transform, sz...)
end


@inline Base.axes(A::NoiseArray) = A.axes
@inline Base.size(A::NoiseArray, d::Integer) = length(A.axes[d])
@inline Base.size(A::NoiseArray{<:Any,N}) where {N} = length.(A.axes)

IndexStyle(::Type{<:NoiseArray}) = IndexLinear()

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{T}, i::Integer) where T
    @boundscheck checkbounds(A,i)
    noise_getindex(A.noise, A.transform, i, T)
end

@inline function setindex!(::NoiseArray{T,N}, v, k) where {T,N}
    throw(ArgumentError("Cannot setindex! for a NoiseArray"))
end
