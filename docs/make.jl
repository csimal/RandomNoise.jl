using NoiseRNG
using Documenter

DocMeta.setdocmeta!(NoiseRNG, :DocTestSetup, :(using NoiseRNG); recursive=true)

makedocs(;
    modules=[NoiseRNG],
    authors="Cédric Simal, University of Namur",
    repo="https://github.com/csimal/NoiseRNG.jl/blob/{commit}{path}#{line}",
    sitename="NoiseRNG.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://csimal.github.io/NoiseRNG.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/csimal/NoiseRNG.jl",
    devbranch="main",
)
