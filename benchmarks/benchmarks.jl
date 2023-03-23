using Random
using RNGTest
using BenchmarkTools

function pipe_output(f, str_out, str_err)
    redirect_stdio(stdout="$(str_out).txt", stderr="$(str_err).txt") do
        f()
    end
end

str_(test, name) = "$(test)_$name"
str_(test, name, seed) = "$(test)_$(name)_seed=$seed"

function smallcrush(rng, name)
    redirect_stdio(stdout="./BigCrushTestU01_$(name).txt", stderr="stderr_$(name).txt") do
        RNGTest.smallcrushTestU01(rng)
    end
end

function bigcrush(rng, name)
    redirect_stdio(stdout="./BigCrushTestU01_$(name).txt", stderr="stderr_$(name).txt") do
        RNGTest.bigcrushTestU01(rng)
    end
end

function speed_benchmark(rng, name)
    
end
