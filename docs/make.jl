using Documenter, ErrorfreeArithmetic

makedocs(
    modules = [ErrorfreeArithmetic],
    sitename = "ErrorfreeArithmetic",
    authors = "Jeffrey A. Sarnoff and other contributors",
    source="src",
    clean=false,
    strict=!("strict=false" in ARGS),
    doctest=("doctest=only" in ARGS) ? :only : true,
    format=Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        prettyurls=!("local" in ARGS),
        highlights=["yaml"],
        ansicolor=true,
    ),
    pages=[
        "Home" => "index.md",
        "Overview" => "overview.md",
        "Introduction" => Any[
            "Floating-Point Arithmetic"=>"intro/arithmetic.md",
            "Accuracy and Precision"=>"intro/accuracy_precision.md",
            "Extending Precision Accurately"=>"intro/extending_precision.md",
            "A Guide to Function Names"=>"intro/naming.md",
        ],
        "API" => Any[
            "add" => "api/addition.md",
            "subtract" => "api/subtraction.md",
            "multiplication" => "api/multiply.md",
            "division" => "api/divide.md",
            "fused multiply-add" => "api/fma.md",
            "other functions" => "api/others",
        ],
        "References" => "references.md",
    ]
)

#=
Deploy docs to Github pages.
=#
Documenter.deploydocs(
    branch = "gh-pages",
    target = "build",
    deps = nothing,
    make = nothing,
    repo = "github.com/JeffreySarnoff/ErrorfreeArithmetic.jl.git",
)

