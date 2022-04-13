# RandomNoise.jl

[![Build Status](https://github.com/csimal/RandomNoise.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/csimal/RandomNoise.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/csimal/RandomNoise.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/csimal/RandomNoise.jl)

This package provides a minimalist interface for using noise functions to generate pseudo random numbers.

Noise functions, also known as Counter-Based RNGs are another approach to traditional PRNGs, which have several advantages for parallel computation and procedural generation. While this package allows using noise functions as RNGs, it is mostly focused on using them as streams of random values that can be indexed in any order.

