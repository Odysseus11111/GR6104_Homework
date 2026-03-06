using Test
using LinearAlgebra
using Revise

includet("../src/cholesky-factors.jl")

@testset verbose=true "Cholesky Unit Test" begin
    # We perform unit test first on choley_fac(A)
    @testset "choley_fac" begin
        @testset "Simple Case" begin
            A= [4 12 -16; 12 37 -43; -16 -43 98]
            L_target= [2 0 0; 6 1 0; -8 5 3]
            @test isapprox(choley_fac(A), L_target, atol=1e-10)
        end
        @testset "Boundary Case" begin
            # A is a 1x1 matrix
            A=reshape([9.0], 1, 1)
            @test isapprox(choley_fac(A), reshape([3.0], 1, 1), atol=1e-10)
            # A is an identity matrix
            A_id=[1 0; 0 1]
            @test isapprox(choley_fac(A_id), A_id, atol=1e-10)
        end
        @testset "Corner Case" begin
            # A contains extrem values
            A_ext= [1e12 0.0; 0.0 1e-6]
            L_ext= [1e6 0.0; 0.0 1e-3]
            @test isapprox(choley_fac(A_ext), L_ext, atol=1e-10)
        end
        @testset "Bug Catch" begin
            # A is a non-symmetric matrix
            A= [1.0 2.0; 3.0 4.0]
            @test_throws ErrorException choley_fac(A)
            # A contains negative eigenvals
            A= [1.0 2.0; 2.0 1.0] 
            @test_throws ErrorException choley_fac(A)
        end
    end

    # 2.Unit test on cholesky_solve(L, b)
    @testset "cholesky_solve" begin
        @testset "Simple Case" begin
            # Let L = [2 0; 1 3]，A = [4 2; 2 10]
            # If x = [1; 2]，b = [8; 22]
            L=[2 0; 1 3]
            b=[8; 22]
            x=[1; 2]
            @test isapprox(cholesky_solve(L, b), x, atol=1e-10)
        end
        @testset "Boundary Case" begin
            # 1x1 
            L=reshape([2.0], 1, 1)
            b=[8.0] 
            @test isapprox(cholesky_solve(L, b), [2.0], atol=1e-10)
        end
        @testset "Corner Case" begin
            L_mix=[2.5 0.0; -1.5 2.0]
            b_mix=[-10.5; 5.5]
            x_calc = cholesky_solve(L_mix, b_mix)
            # If LL^T * x =b
            A_mix=L_mix * L_mix'
            @test isapprox(A_mix * x_calc, b_mix, atol=1e-10)
        end
        @testset "Bug Catch" begin
            # Check Dimension of L when it does not match
            # Check BoundsError
            L_dim=[1.0 0.0; 0.0 1.0]
            b_dim=[1.0; 2.0; 3.0]
            @test_throws BoundsError cholesky_solve(L_dim, b_dim)
        end
    end

    # 3.Unit test on low_rank(L, v)
    @testset "low_rank" begin
        @testset "Simple Case" begin
            L_old=[2 0; 1 3]
            v=[1;2]
            A=L_old*L_old'+ v*v'
            L_new=low_rank(L_old, v)
            # If LL^T=A
            @test isapprox(L_new * L_new',A,atol=1e-10)
            #If L_new be Lower triangle or not
            @test L_new[1, 2] == 0.0
        end
        @testset "Boundary Case" begin
            L_b = [3 0; 2 4]
            v_zero = [0; 0]
            @test isapprox(low_rank(L_b, v_zero), L_b, atol=1e-10)
        end
        @testset "Corner Case" begin
            L_c = [5.0 0.0 0.0; -2.1 3.2 0.0; 1.5 -0.5 2.8]
            v_neg = [-1e4; -0.005; -3.14]
            target_Ac = L_c * L_c' + v_neg * v_neg'
            L_new_c = low_rank(L_c, v_neg)
            @test isapprox(L_new_c * L_new_c', target_Ac)
        end
        @testset "Bug Catch" begin
            L_orig = [2.0 0.0; 1.0 3.0]
            v_orig = [1.0; 2.0]
            L_test = copy(L_orig)
            v_test = copy(v_orig)
            _ = low_rank(L_test, v_test)
            @test L_test == L_orig
            @test v_test == v_orig
        end
    end

end