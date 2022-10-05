makedocs(
    modules = [ErrorfreeArithmetic],
    format = :html,
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
            "Function Naming"=>"intro/naming.md",
        ],
        "API" => Any[
            "add" => "api/addition.md",
            "subtract" => "api/subtraction.md",
            "multiply" => "api/multiply.md",
            "divide" => "api/divide.md",
            "fma" => "api/fma.md",
            "others" => "api/others",
        ],
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

