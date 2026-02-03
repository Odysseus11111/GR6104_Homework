using Test
include("C:/Users/Odysseus/GR6104_Homework/HW2/src/ks-stat.jl")

@testset"KS Statistics implementation tests" begin  
    # 1. Simple Examples    
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
    # 2. Corner Cases, we consider the case 1: Unsorted input, case 2, Duplicate input 
            # and case 3 all the values are identical, case 4: the data performs uniform distribution
    @testset "Corner Cases" begin
        @test isapprox(ks_func([0.8, 0.2], H), 0.3; atol=1e-12)
        @test ks_func([0.5, 0.5], H) == 0.5
        @test ks_func([0.5, 0.5, 0.5], H) == 0.5
        uniform_data = [0.1, 0.3, 0.5, 0.7, 0.9]
        @test isapprox(ks_func(perfect_data, uniform_cdf), 0.1; atol=1e-12)
    end
    # 3. Squashing Bugs, we make sure that the input array is not mutated


        
end