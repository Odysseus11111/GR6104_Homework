# We do the unit test, and check for simle, corner, boundary and bug catching.

# 1.Simple case : We let A = [2 1; 1 3] b = [5;5] the answer is [2 1]

# 2.Boundary case： We use 1*1 matrix, and let A = identity matrix and see whether
# it works normally

# 3. Corner case: We let A to be contained extreme values , and use a matrix A that
# contains negative numbers and float to check

# 4. Bug Catch: We let the input A to be a singular matrix [1 2;2 4], b =[3; 6]
# And see whether we got the error; And we check whether the A and b would be 
# changed after we manipulate them using backward and forward functions.
using Test
using Revise
includet("../src/gauss-elim.jl")

@testset verbose=true "Unit Test" begin
    @testset "Simple Case" begin
        A = [2 1; 1 3]
        b = [5;5]
        x = [2;1]
        result = gauss_elimi(A,b)
        @test isapprox(x,result,atol = 1e-10)
    end
    @testset "Boundary Case" begin
        # A = 1*1 matrix
        A = ones(1, 1)
        b = [2]
        x = [2]
        result = gauss_elimi(A,b)
        @test isapprox(x,result,atol = 1e-10)
        # A =[1 0;0 1] identity matrix
        A =[1 0;0 1] 
        b = [2;3]
        x =[2;3]
        result = gauss_elimi(A,b)
        @test isapprox(x,result,atol = 1e-10)
    end
    @testset "Corner Case" begin
        A = [1e12 1.0 2.0; 1.0 1.0 0.0; 1.0 1.0 1.0]
        b = [1e12; 1.0; 3.0] 
        x = [1.0; 0.0; 2.0] 
        result = gauss_elimi(A,b)
        @test isapprox(x,result,atol = 1e-10)
        #use a matrix A that contains negative numbers and float 
        A = [2.5 -1.0 4.0;-3.0 1.5 2.0;1.0 2.0 -1.5]
        b = [10.5; 2.5; 10.0]
        x =[3.0;5.0;2.0]
        result = gauss_elimi(A,b)
        @test isapprox(x,result,atol = 1e-10)
    end
    @testset "Bug Catch" begin
        # Let A to be a singular matrix [1 2;2 4]
        A =[1 2;2 4]
        b =[3; 6]
        @test_throws ErrorException gauss_elimi(A, b)
        # Check whether A and b would be changed
        A_original = [2.0 1.0; 1.0 3.0]
        b_original = [5.0; 5.0]
        A_test = copy(A_original)
        b_test = copy(b_original)
        
        _ = gauss_elimi(A_test, b_test) 
        @test A_test == A_original
        @test b_test == b_original
    end
end
