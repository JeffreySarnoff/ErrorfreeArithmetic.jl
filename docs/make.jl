using Documenter, ErrorfreeArithmetic

makedocs(
    modules = [ErrorfreeArithmetic],
    format = :html,
    sitename = "ErrorfreeArithmetic",
    pages = [
        "Package" => "index.md",
        "Errorfree Arithmetic" => "intro.md",
        "Basic usage" => "usage.md"
    ]
)

deploydocs(
    repo   = "github.com/JeffreySarnoff/ErrorfreeArithmetic.jl.git",
    target = "build"
)
