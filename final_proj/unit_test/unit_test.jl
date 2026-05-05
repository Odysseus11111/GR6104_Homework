# We perform unit test on CRP, BCRP, uni_port_func and simplex_grid_md

using Test
using LinearAlgebra
using Revise
includet("../src.jl")

@testset verbose = true "Unit Test for Universal portfolio algorithm" begin
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
        # The daily growth factor Day 1= 0.5*0.5 + 0.5*2.0 = 1.25
        # The daily growth factor Day 2= 0.5*2.0 + 0.5*0.5 = 1.25
        # Final total wealth = 1.25^2=1.5625
            @test isapprox(wealth[1],1.0; atol=1e-8)
            @test isapprox(wealth[2],1.25; atol=1e-8)
            @test isapprox(wealth[3],1.5625; atol=1e-8)
        end
        @testset "CRP Corner Case" begin
            # We test the case when all wealth are invested in one assets
            prices = [1.0 1.0;
                    2.0 1.0;
                    4.0 1.0]
            b_1= [1.0,0.0]
            b_2= [0.0,1.0]
            wealth_1 = crp_func(prices,b_1)
            wealth_2 = crp_func(prices,b_2)
            #  Asset 1 grows from 1 to 4
            @test isapprox(wealth_1[end],4.0;atol=1e-8) #so the final wealth should be 4.
            # Asset 2 remains unchanged
            @test isapprox(wealth_2[end],1.0;atol=1e-8) #the final wealth should remain unchanged
        @testset "CRP Boundary Case" begin
            # We consider the case when there is only one observation. There is 
            # no trading happens. S0= 1
            prices_only_one = [1.0 2.0 3.0]
            b=[1/3,1/3,1/3]
            wealth = crp_func(prices_only_one,b)
            @test length(wealth)==1 # Since there is only one row of prices, the wealth trajectory should = S0.
            @test isapprox(wealth[1],1.0;atol=1e-8)
            asset_only_one = [1.0;2.0;4.0]
        end
        @testset "CRP Bug Catch" begin
            # We test that the wealth should always be positive
                prices = [1.0 1.0;
                            1.2 0.8;
                            1.5 1.0]
                b = [0.6, 0.4]
                wealth = crp_func(prices, b)
                @test all(x ->x>0, wealth)
            # Final wealth should be:
            # Day 2 growth= 0.6*1.2+0.4*0.8/1= 1.04
            # Day 3 growth= 0.6*(1.5/1.2)+0.4*(1/0.8)= 1.25
            # Final wealth= 1.04 * 1.25= 1.30
                @test isapprox(wealth[end], 1.30; atol=1e-8)
        end
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
        @testset "BCRP corner case" begin
        # Asset 1 keeps increasing, asset 2 stays constant, best CRP should invest all in Asset 1.
        prices = [1.0 1.0;
        2.0 1.0;
        4.0 1.0]
        eta = 0.1
        best_b,best_final_wealth,best_wealth_set= bcrp_func_md(prices,eta)
        # BCRP should choose 100% in Asset 1 and 0% in Asset 2.
        @test isapprox(best_b[1], 1.0; atol=1e-8)
        @test isapprox(best_b[2], 0.0; atol=1e-8)
        @test isapprox(best_final_wealth,4.0;atol=1e-8)
        @test isapprox(best_wealth_set[end],best_final_wealth;atol=1e-8)
        end
        @testset "BCRP boundary case" begin
        # We only consider one asset in boundary case here
        prices_one_asset = reshape([1.0,2.0,4.0],3,1)
        eta = 0.1
        best_b,best_final_wealth,best_wealth_set= bcrp_func_md(prices_one_asset, eta)
        @test length(best_b)== 1
        @test isapprox(best_b[1],1.0;atol=1e-8)
        @test isapprox(best_final_wealth,4.0;atol=1e-8)
    end
    @testset "BCRP bug catch" begin
    # We check whether BCRP finds a valid best portfolio.
                prices = [1.0 1.0 1.0;
                        1.2 0.9 1.1;
                        1.1 1.0 1.3;
                        1.4 0.8 1.2]
                eta = 0.1
    # The final wealth should be equal to the last value of the wealth path.
    best_b,best_final_wealth,best_wealth_set= bcrp_func_md(prices, eta)
    @test isapprox(best_final_wealth, best_wealth_set[end]; atol=1e-8)
    @test isapprox(sum(best_b),1.0; atol=1e-8) # Summation must be = 1 & each be greater than 0 
    @test all(x->x>= -1e-8,best_b)
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
        @testset "Simplex Grid corner case" begin
        # The corner case we consider here is when m = 3, three portfolios are:
        # [1,0,0], [0,1,0], and [0,0,1]
            grid = simplex_grid_md(3, 0.5)
            corners= [
            [1.0,0.0,0.0],
            [0.0,1.0,0.0],
            [0.0,0.0,1.0]]
            for c in corners # Check each portfolio is in the grid
                @test any(g->all(isapprox.(g,c;atol=1e-8)),grid)
            end
        end
        @testset "Simplex Grid boundary case" begin
        # We consider the boundary case when there is only one asset [1.0] in it.
            grid= simplex_grid_md(1,0.1)
            @test length(grid) == 1
            @test isapprox(grid[1][1],1.0;atol=1e-8)
        end
        @testset "Simplex Grid bug catch case" begin
            # Suppose we consider m=3 eta=0.1
            grid = simplex_grid_md(3, 0.1)
            # Each portfolio should have 3 weights.
            @test all(length(b) == 3 for b in grid)
            # Each portfolio should sum to 1
            @test all(isapprox(sum(b),1.0;atol=1e-8) for b in grid)
            # Each weight should be >=0
            @test all(all(x -> x >= -1e-8, b) for b in grid)
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
        @testset "uni_port_func corner case" begin
            # We check that the UP will produce positive wealth
            # in the increasing example
            prices = [1.0 1.0;
                    2.0 1.0;
                    4.0 1.0]
            eta = 0.1
            # up_wealth store wealth trajectory of Universal portfolio
            # S_grid stores the final wealth of each portfolio
            up_wealth,b_weights,S_grid=uni_port_func(prices,eta)
            @test all(x->x>0,up_wealth)
            @test up_wealth[end]>=1.0-1e-8
        end
        @testset "uni_port_func boundary case" begin
            # We test the case when there is only one asset
            # We expect the UP must invest 100% in this asset
                price_only_one= reshape([1.0, 2.0, 4.0], 3, 1)
                eta = 0.1
                up_wealth,b_weights,S_grid=uni_port_func(price_only_one,eta)
                @test isapprox(up_wealth[end],4.0,atol=1e-8)
                @test all(isapprox.(b_weights[:,1],1.0;atol=1e-8))
        end
        @testset "uni_port_func bug catching case" begin
                prices = [1.0 1.0 1.0;
                        1.2 0.9 1.1;
                        1.1 1.0 1.3;
                        1.4 0.8 1.2]
                eta = 0.1
                up_wealth, b_weights, S_grid = uni_port_func(prices, eta)
                n, m = size(prices)
            # The total wealth trajectory should be n.
            @test length(up_wealth) == n
            # The up wealth should always be positive.
            @test all(x ->x > 0, up_wealth)
            # Summation of the portfolio weight should be 1.
            @test all(isapprox(sum(b_weights[t,:]),1.0;atol=1e-8) for t in 1:n)
        end
    end
end