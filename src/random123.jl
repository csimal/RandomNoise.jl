
function noise(n, rng::Random123.AbstractR123)
    Random123.set_counter!(rng, n)
    Random123._value(rng)
end
