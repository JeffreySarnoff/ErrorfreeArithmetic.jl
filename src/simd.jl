const Float32x2 = NTuple{2, Base.VecElement{Float32}}
const Float64x2 = NTuple{2, Base.VecElement{Float64}}
const Float32x4 = NTuple{4, Base.VecElement{Float32}}
const Float64x4 = NTuple{4, Base.VecElement{Float64}}
const Float32x8 = NTuple{8, Base.VecElement{Float32}}

for (T,N,C) in ((:Float32x2, :2, :float), (:Float32x4, :4, :float), (:Float32x8, :8, :float),  
                (:Float64x2, :2, :double), (:Float64x4, :4, :double))
    thecall = :("%res = fneg <$(N) x $(C) > %0\n ret <$(N) x $(C)> %res")        
    fn = """function Base.:-(x::$(T))
            Base.llvmcall($(thecall), $(T), Tuple{$(T)}, x)
            end"""
    @eval Meta.parse($fn)
end

for (T,N,C) in ((:Float32x2, :2, :float), (:Float32x4, :4, :float), (:Float32x8, :8, :float),  
                (:Float64x2, :2, :double), (:Float64x4, :4, :double))
    thecall = :("%res = fadd <$(N) x $(C) > %0\n ret <$(N) x $(C)> %res")        
    fn = """function Base.:+(x::$(T), y::$(T))
            Base.llvmcall($(thecall), $(T), Tuple{$(T), $(T)}, x, y)
            end"""
    println(fn)
    @eval Meta.parse($fn)
end


function Base.:-(x::Float32x2)
    Base.llvmcall("""
        %res = fneg <2 x float> %0
        ret <2 x float> %res
        """, Float32x2, Tuple{Float32x2}, x)
end

function Base.:-(x::Float32x4)
    Base.llvmcall("""
        %res = fneg <4 x float> %0
        ret <4 x float> %res
        """, Float32x4, Tuple{Float32x4}, x)
end

function Base.:-(x::Float64x2)
    Base.llvmcall("""
        %res = fneg <2 x double> %0
        ret <2 x double> %res
        """, Float64x4, Tuple{Float64x2}, x)
end

function Base.:-(x::Float64x4)
    Base.llvmcall("""
        %res = fneg <4 x double> %0
        ret <4 x double> %res
        """, Float64x4, Tuple{Float64x4}, x)
end
