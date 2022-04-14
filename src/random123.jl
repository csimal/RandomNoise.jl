using Random123
import Random123: AbstractR123

function noise(n, rng::AbstractR123)
    set_counter!(rng, n)
    Random123._value(rng)
end
