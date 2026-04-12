using Revise
using LinearAlgebra
includet("../src/graphical-greedy.jl")

@test "Unit Test for greedy algorithm" begin
    @testset "Simple Case" begin
        #Unit Test for graphical_greedy function
        weighted_edge_list = [1 2 3;4 5 6;2 3 5]
        return graphical_greedy(weighted_edge_list)
        #Unit Test for linear_greedy function, as required is the question,
        # we test our linear matroid codde by using a uniform matroid example with 
        # distinct weights
        weighted_vec_list = [1 2 3 5;2 3 5 6;3 4 6 7;4 5 6 8]
        return linear_greedy(weighted_vec_list)
    end
    @testset "Matching Answer" begin
    # We try a simple example to show that graphical matroids can be represented
    # as linear matroids. We use a graph, it contains 3 verteces,[1,2,3]
    # And three edges e1=(1,2) e2 = (2,3), e3=(1,3)  
    #So we can write them as ve1 = (1,-1,0) ve2=(0,1,-1), ve3 =(1,0,-1) They 
    # are linearly dependent
    weighted_edge_list_match = [1 2;2 3;1 3]
    match_result_graph= graphical_greedy(weighted_edge_list_match)
    return match_result_graph
    weighted_vec_list_match = [1 -1 0;0 1 -1;1 0 -1]
    match_result_linear =linear_greedy(weighted_vec_list_match)
    return match_result_linear
    isapprox(match_result_graph[0],match_result_linear[0],atol=1e8)
    isapprox(match_result_graph[1],match_result_linear[1],atol=1e8)
    end
    @testset "Uniform Matroid" begin
        
    end
    @testset "Boundary Case" begin
        #Unit Test for graphical_greedy function
        # We select

        #Unit Test for linear_greedy function
        
    end
    @testset "Corner Case" begin
        #Unit Test for graphical_greedy function

        #Unit Test for linear_greedy function
    end
    @testset "Bug Catch" begin
        #Unit Test for graphical_greedy function

        #Unit Test for linear_greedy function
    end   
end