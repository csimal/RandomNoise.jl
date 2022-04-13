
struct NoiseFunction{N,T,D}
    noise::T
end

(nf::NoiseFunction{N,T,1})(n) = noise(n,nf)

