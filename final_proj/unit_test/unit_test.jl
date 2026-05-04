# We perform unit test on CRP, BCRP, uni_port_func and simplex_grid_md

using Test
using LinearAlgebra
using Revise
includet("../src.jl")

@testset "Unit Test for Universal portfolio algorithm" begin
    @testset "CRP Function Tests" begin
        @testset "CRP Simple Case" begin
        # we use an example to illustrate this simple case , suppose we have 2 assets and
        # we consider 3 days
            prices =[1.0 1.0;
                0.5 2.0;
                1.0 1.0]
        # x1 = P1/P0= (0.5,2.0); x2=P2/P1 = (2.0,0.5)
            b= [0.5,0.5]
            wealth = crp_func(prices,b)
        # The daily growth factor Day 1 = 0.5*0.5 + 0.5*2.0 = 1.25
        # The daily growth factor Day 2 = 0.5*2.0 + 0.5*0.5 = 1.25
        # Final total wealth = 1.25^2=1.5625
            @test isapprox(wealth[1],1.0; atol=1e-8)
            @test isapprox(wealth[2],1.25; atol=1e-8)
            @test isapprox(wealth[3],1.5625; atol=1e-8)
        end
    end
    @testset "BCRP Function Tests" begin
        @testset "BCRP simple case" begin
            #We check whether BCRP final wealth be larger or equal to equal-weight CRP
            # We use the same example in CRP simple case
            prices = [1.0 1.0;
                0.5 2.0;
                1.0 1.0]
            eta =0.1
            #Here best_b is the best crp found on grid; and best_final_wealth is the
            # final wealth achieved by this best portfolio
            # best_wealth_set is the total wealth trajectory of the best [portfolio]
            best_b,best_final_wealth,best_wealth_set = bcrp_func_md(prices,eta)
            equal_b= [0.5,0.5]
            equal_wealth= crp_func(prices,equal_b)
            @test (best_final_wealth +1e-8)>=equal_wealth[end] # Since we allow small floating-point error

        end
    end
    @testset "Simplex Grid Function Tests" begin
        @testset "Simplx Grid simple case" begin
            # Suppose we have 2 assets. b1+b2=1, eta=0.5,
            #  b1 can only have 0，0.5，1 
            m = 2
            eta =0.5
            grid = simplex_grid_md(m,eta)
            true_grid = [
            [0.0, 1.0],
            [0.5, 0.5],
            [1.0, 0.0]]
            @test length(grid)==3
        end
    end
    @testset "uni_port_func Tests" begin
        @testset "UP simple case" begin
            prices = [1.0 1.0;
            0.5 2.0;
            1.0 1.0]
            eta=0.1
            # up_wealth will store the Universal portfolio wealth trajectory
            # b_weights store the portfolio weights at each step 
            # S_grid will store the final total wealth of each grid portfolio
            up_wealth, b_weights, S_grid =uni_port_func(prices, eta)
            n,m=size(prices)
            @test length(up_wealth)==n
            @test isapprox(up_wealth[1],1.0;atol=1e-8) #Check S_0 = 1
        end
    end
end