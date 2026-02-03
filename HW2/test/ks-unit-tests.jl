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
        @test isapprox(ks_func(uniform_data, H), 0.1; atol=1e-12)
    end
    # 3. Squashing Bugs, I have made the one-sided logic error 
        # Calculating distance only at the step top value |i/n - H(x)|
        # while neglecting the step bottom value |(i-1)/n - H(x)|
        #If we forgot to consider the other side, the function incorrectly returns 0.1.
    @testset "Squashing Bugs" begin
        H(t) = t
        one_sided_val = [0.9]
        @test isapprox(ks_func(one_sided_val, H), 0.9;atol=1e-12)
    end
end