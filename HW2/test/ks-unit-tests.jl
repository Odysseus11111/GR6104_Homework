using Test
include("C:/Users/Odysseus/GR6104_Homework/HW2/src/ks-stat.jl")
H(t) = t
@testset"KS Statistics implementation tests" begin  
        @testset "empi_df function test" begin

        data = [1,2,3,4]
        @test empi_df(data,0) == 0
        @test empi_df(data,5) == 1
        @test empi_df(data,2.5) == 0.5
        @test empi_df(data,2) == 0.5
        end
        @testset "ks_func: Simple Examples" begin
            H = t -> t
            @test ks_func([0.5],H)==0.5
            @test isapprox(ks_func([0.2], H), 0.8; atol=1e-12)
            @test isapprox(ks_func([0.2,0.8], H), 0.3; atol=1e-12)
        end
        
end