using Revise
using Test
using LinearAlgebra
includet("../src/graphical-greedy.jl")
includet("../src/linear-greedy.jl")
@testset "Unit Test for greedy algorithm" begin
    @testset "Simple Case" begin
        #Unit Test for graphical_greedy function
        weighted_edge_list = [1 2 3;2 3 6;1 3 5]
        graph_simple_opt,graph_simple_val = graphical_greedy(weighted_edge_list)
        @test graph_simple_val =9
        @test size(graph_simple_opt,1)==2
        #Unit Test for linear_greedy function, as required is the question,
        # we test our linear matroid codde by using a uniform matroid example with 
        # distinct weights
        weighted_vec_list = [1 0 10;0 1 8;1 1 6]
        lin_opt,lin_val =linear_greedy(weighted_edge_list_match)
        @test lin_val==18
        @test size(lin_opt==2)
    end
    @testset "Matching Answer" begin
    # We try a simple example to show that graphical matroids can be represented
    # as linear matroids. We use a graph, it contains 3 verteces,[1,2,3]
    # And three edges e1=(1,2) e2 = (2,3), e3=(1,3)  
    #So we can write them as ve1 = (1,-1,0) ve2=(0,1,-1), ve3 =(1,0,-1) They 
    # are linearly dependent
    weighted_edge_list_match = [1 2 10;2 3 8;1 3 5]


    @test match_result_graph= graphical_greedy(weighted_edge_list_match)
    weighted_vec_list_match = [1 -1 0;0 1 -1;1 0 -1]
    match_result_linear =linear_greedy(weighted_vec_list_match)
    @test isapprox(match_result_graph[1],match_result_linear[1],atol=1e-8)
    @test isapprox(match_result_graph[2],match_result_linear[2],atol=1e-8)
    end

    @testset "Boundary Case" begin
        #Unit Test for graphical_greedy function
        # We consider the case when there is no edge in a graph
        weighted_edge_list_bd = []
        @test result_graphical_bd = graphical_greedy(weighted_edge_list_bd)
        #Unit Test for linear_greedy function
        weighted_vec_list =[1 2 10]
        @test result_linear_bd = linear_greedy(weighted_vec_list)
    end
    @testset "Corner Case" begin
        #Unit Test for graphical_greedy function
            # We consider the case when there is a closed cycle in a graph
            weighted_edge_list_cycle= [1 1 10]
            @test result_graphical_cycle = graphical_greedy(weighted_edge_list_cycle)
        #Unit Test for linear_greedy function
            weighted_vec_list_corner = [1 2 5;2 1 10]
            @test result_linear_cycle =linear_greedy(weighted_vec_list_corner)
    end
    @testset "Bug Catch" begin
        #Unit Test for graphical_greedy function

        #Unit Test for linear_greedy function
    end   
end