using Revise
using Test
using LinearAlgebra
includet("../src/graphical-greedy.jl")
includet("../src/linear-greedy.jl")
@testset verbose=true "Unit Test for greedy algorithm" begin
    @testset "Simple Case" begin
        #Unit Test for graphical_greedy function
        weighted_edge_list = [1.0 2.0 3.0;2.0 3.0 6.0;1.0 3.0 5.0]
        graph_simple_opt,graph_simple_val = graphical_greedy(weighted_edge_list)
        @test graph_simple_val ==11.0
        @test size(graph_simple_opt,1)==2.0
        #Unit Test for linear_greedy function, as required is the question,
        # we test our linear matroid codde by using a uniform matroid example with 
        # distinct weights
        weighted_vec_list = [1.0 0.0 10.0;0.0 1.0 8.0;1.0 1.0 6.0]
        lin_opt,lin_val =linear_greedy(weighted_vec_list)
        @test lin_val==18.0
        @test size(lin_opt,1)==2.0
    end
    @testset "Matching Answer" begin
    # We try a simple example to show that graphical matroids can be represented
    # as linear matroids. We use a graph, it contains 3 verteces,[1,2,3]
    # And three edges e1=(1,2) e2 = (2,3), e3=(1,3)  
    #So we can write them as ve1 = (1,-1,0) ve2=(0,1,-1), ve3 =(1,0,-1) They 
    # are linearly dependent
    weighted_edge_list_match = [1.0 2.0 10.0;2.0 3.0 8.0;1.0 3.0 5.0]
    match_result_graph= graphical_greedy(weighted_edge_list_match)
    weighted_vec_list_match = [1.0 -1.0 0.0 10.0; 0.0 1.0 -1.0 8.0; 1.0 0.0 -1.0 5.0]
    match_result_linear =linear_greedy(weighted_vec_list_match)
    @test match_result_graph[2]==match_result_linear[2]
    @test size(match_result_graph[1],1) ==size(match_result_linear[1],1)
    end

    @testset "Boundary Case" begin
        #Unit Test for graphical_greedy function
        # We consider the case when there is no edge in a graph
        weighted_edge_list_bd =  zeros(0, 3)
        result_graphical_bd = graphical_greedy(weighted_edge_list_bd)
        @test size(result_graphical_bd[1],1)==0.0
        @test result_graphical_bd[2]==0.0
        #Unit Test for linear_greedy function
        weighted_vec_list =[1.0 2.0 10.0]
        result_linear_bd = linear_greedy(weighted_vec_list)
        @test size(result_linear_bd[1],1)==1.0
        @test result_linear_bd[2]==10.0
    end
    @testset "Corner Case" begin
        #Unit Test for graphical_greedy function
            # We consider the case when there is a closed cycle in a graph
            weighted_edge_list_cycle= [1.0 2.0 10.0;2.0 3.0 9.0;1.0 3.0 8.0]
            result_graphical_cycle = graphical_greedy(weighted_edge_list_cycle)
            @test size(result_graphical_cycle[1], 1) == 2.0
            @test result_graphical_cycle[2]==19.0
        #Unit Test for linear_greedy function
            weighted_vec_list_corner = [1.0 0.0 10.0;0.0 1.0 8.0;1.0 1.0 7.0]
            result_linear_cycle =linear_greedy(weighted_vec_list_corner)
            @test size(result_linear_cycle[1],1)==2.0
            @test result_linear_cycle[2]==18.0
    end
    @testset "Bug Catch" begin
        # Bug catch for graphical_greedy function
        weighted_edge_list_bug = [1.0 2.0 10.0; 2.0 2.0 100.0; 2.0 3.0 5.0]
        bug_graph_opt, bug_graph_val = graphical_greedy(weighted_edge_list_bug)
        # The algorithm should choose the edges which have weight 10 and 5
        @test bug_graph_val == 15.0
        #  Bug catch for linear_greedy function
        weighted_vec_list_bug = [1.0 0.0 10.0; 2.0 0.0 100.0; 0.0 1.0 5.0]
        bug_lin_opt, bug_lin_val = linear_greedy(weighted_vec_list_bug)
        # The algorithm should choose vector 2 which has weight 100 at first
        # Then choose vector 3, which has weight equal to 5
        @test size(bug_lin_opt, 1) == 2.0
        @test bug_lin_val == 105.0
    end  
end