using Test
using LinearAlgebra
using Revise

includet("../src/src.jl")

# Finite difference gradient for checking gradient_func
function finite_diff_grad(f, theta; h=1e-8)
    d = length(theta)
    g = zeros(d)
    for j in 1:d
        e = zeros(d)
        e[j] =1
        g[j] =(f(theta + h*e) - f(theta - h*e))/(2h)
    end
    return g
end

@testset "Optimization Unit Tests" verbose=true begin
    X = [1.0  0.0;1.0  1.0;1.0 2.0;1.0  3.0]
    y = [0.0, 0.0, 1.0, 1.0]
    alpha = 0.3
    beta = 0.7
    @testset "link_func" begin
        @testset "simple case" begin
            # Check value at zero.
            @test isapprox(link_func(0), 0.5; atol=1e-12)
        end
        @testset "corner case" begin
            # Check output between 0 and 1.
            @test (0 < link_func(-1.0)) && (link_func(-1.0) < 1)
        end
        @testset "boundary case" begin
            # Check extreme input
            @test isapprox(link_func(1000), 1.0; atol=1e-12)
        end
        @testset "bug catch" begin
            # Check symmetry identity.
            @test isapprox(link_func(2) + link_func(-2), 1.0; atol=1e-12)
        end
    end
    @testset "predict_prob" begin
        @testset "simple case" begin
            # Check zero theta gives all p=0.5
            theta = [0.0, 0.0]
            p = predict_prob(theta, X)
            @test length(p) == size(X, 1)
            @test all(isapprox.(p, 0.5; atol=1e-12))
        end
        @testset "corner case" begin
            # Check probabilities are valid for general theta.
            theta = [0.5, -0.5]
            p = predict_prob(theta, X)
            @test all((0 .< p) .& (p .< 1))
        end
        @testset "boundary case" begin
            # Check single-row input.
            X_one = reshape([1.0, 2.0], 1, 2)
            theta = [1.0, 1.0]
            p = predict_prob(theta, X_one)
            @test length(p) == 1
        end
        @testset "bug catch" begin
            # Check against manual computation.
            theta = [0.3, -0.2]
            p = predict_prob(theta, X)
            @test isapprox(p[2], link_func(dot(X[2, :], theta)); atol=1e-12)
        end
    end
    @testset "f_func" begin
        @testset "simple case" begin
            # Check log-likelihood at theta = 0.
            theta = [0.0, 0.0]
            expected = length(y) * log(0.5)
            @test isapprox(f_func(theta, X, y), expected; atol=1e-12)
        end
        @testset "corner case" begin
            # Check function value is finite.
            theta = [0.5, -0.5]
            @test isfinite(f_func(theta, X, y))
        end
        @testset "boundary case" begin
            # Check larger theta still gives finite value.
            theta = [3.0, -1.0]
            @test isfinite(f_func(theta, X, y))
        end
        @testset "bug catch" begin
            # Check direct formula agrees with implementation.
            theta = [0.2, -0.1]
            val = 0.0
            for i in 1:length(y)
                p = link_func(dot(X[i, :], theta))
                val += y[i]*log(p)+(1 - y[i])*log(1 - p)
            end
            @test isapprox(f_func(theta, X, y), val; atol=1e-8)
        end
    end
    @testset "gradient_func" begin
        @testset "simple case" begin
            # Check closed-form gradient at theta = 0.
            theta = [0.0, 0.0]
            expected = X' * (y .- 0.5)
            @test isapprox(gradient_func(theta, X, y), expected,atol=1e-8)
        end
        @testset "corner case" begin
            # Check gradient size is correct.
            theta = [0.2, -0.3]
            g = gradient_func(theta, X, y)
            @test length(g) == size(X, 2)
        end
        @testset "boundary case" begin
            # Check gradient remains finite for larger theta.
            theta = [3.0, -2.0]
            g = gradient_func(theta, X, y)
            @test all(isfinite.(g))
        end
        @testset "bug catch" begin
            # Check analytical gradient with finite differences.
            theta = [0.4, -0.2]
            fθ = θ -> f_func(θ, X, y)
            g_fd = finite_diff_grad(fθ, theta)
            g = gradient_func(theta, X, y)
            @test isapprox(g,g_fd,atol=1e-5)
        end
    end
    @testset "hessian_func" begin
        @testset "simple case" begin
            # Check Hessian formula at theta = 0.
            theta = [0.0, 0.0]
            H = hessian_func(X, theta)
            expected = -(X' * (0.25I) * X)
            @test isapprox(H,Matrix(expected),atol=1e-8)
        end
        @testset "corner case" begin
            # Check Hessian is symmetric.
            theta = [0.2, -0.3]
            H = hessian_func(X, theta)
            @test isapprox(H,H,atol=1e-8)
        end
        @testset "boundary case" begin
            # Check Hessian is finite for larger theta.
            theta = [2.0, -1.0]
            H = hessian_func(X, theta)
            @test all(isfinite.(H))
        end
        @testset "bug catch" begin
            # Check Hessian is negative semidefinite.
            theta = [0.1, -0.2]
            H = hessian_func(X, theta)
            eigs = eigvals(Symmetric(H))
            @test maximum(eigs)<=1e-8
        end
    end
    @testset "newton_dir" begin
        @testset "simple case" begin
            # Check Newton direction solves H*d = -g.
            theta = [0.1, -0.2]
            d_newton = newton_dir(X, theta, y)
            H = hessian_func(X, theta)
            g = gradient_func(theta, X, y)
            @test isapprox(H * d_newton,-g,atol=1e-8)
        end
        @testset "corner case" begin
            # Check Newton direction size is correct.
            theta = [0.0, 0.0]
            d_newton = newton_dir(X, theta, y)
            @test length(d_newton) == size(X, 2)
        end
        @testset "boundary case" begin
            # Check Newton direction remains finite.
            theta = [2.0, -1.0]
            d_newton = newton_dir(X, theta, y)
            @test all(isfinite.(d_newton))
        end
        @testset "bug catch" begin
            # Check Newton direction is an ascent direction.
            theta = [0.2, -0.1]
            d_newton = newton_dir(X, theta, y)
            g = gradient_func(theta, X, y)
            @test dot(g, d_newton) > 0
        end
    end
    @testset "backtracking_ascent" begin
        @testset "simple case" begin
            # Check returned step size is valid.
            theta = [0.0, 0.0]
            d = gradient_func(theta, X, y)
            eta = backtracking_ascent(theta, d, X, y, alpha, beta)
            @test (0 < eta) && (eta <= 1)
        end
        @testset "corner case" begin
            # Check line search works for Newton direction.
            theta = [0.2, -0.1]
            d = newton_dir(X, theta, y)
            eta = backtracking_ascent(theta, d, X, y, alpha, beta)
            @test (0 < eta) && (eta <= 1)
        end
        @testset "boundary case" begin
            # Check very small direction still works.
            theta = [0.0, 0.0]
            d = 1e-8 * gradient_func(theta, X, y)
            eta = backtracking_ascent(theta, d, X, y, alpha, beta)
            @test (0 < eta) && (eta <= 1)
        end
        @testset "bug catch" begin
            # Check condition holds.
            theta = [0.1, -0.2]
            d = gradient_func(theta, X, y)
            eta = backtracking_ascent(theta, d, X, y, alpha, beta)
            lhs = f_func(theta + eta * d, X, y)
            rhs = f_func(theta, X, y) + alpha * eta * dot(gradient_func(theta, X, y), d)
            @test lhs >= rhs - 1e-12
        end
    end

    @testset "gradient_ascent" begin
        @testset "simple case" begin
            # Check output sizes.
            T_max = 50
            theta, f_vals, etas, times = gradient_ascent(y, X, T_max, alpha, beta)
            @test length(theta) == size(X, 2)
            @test length(f_vals) == T_max + 1
            @test length(etas) == T_max
            @test length(times) == T_max
        end
        @testset "corner case" begin
            # Check zero iterations returns initial state.
            theta, f_vals, etas, times = gradient_ascent(y, X, 0, alpha, beta)
            @test isapprox(theta,zeros(size(X, 2)),atol = 1e-8)
            @test length(f_vals) == 1
            @test length(etas) == 0
        end
        @testset "boundary case" begin
            # Check one step improves objective.
            theta, f_vals, etas, times = gradient_ascent(y, X, 1, alpha, beta)
            @test f_vals[2] >= f_vals[1] - 1e-8
        end
        @testset "bug catch" begin
            # Check objective is nondecreasing.
            theta, f_vals, etas, times = gradient_ascent(y, X, 5, alpha, beta)
            @test all(diff(f_vals) .>= -1e-8)
        end
    end
    @testset "newton_ascent" begin
        @testset "simple case" begin
            # Check output sizes.
            T_max = 50
            theta, f_vals, etas, times = newton_ascent(y, X, T_max, alpha, beta)
            @test length(theta) == size(X, 2)
            @test length(f_vals) == T_max + 1
            @test length(etas) == T_max
            @test length(times) == T_max
        end
        @testset "corner case" begin
            # Check zero iterations returns initial state.
            theta, f_vals, etas, times = newton_ascent(y, X, 0, alpha, beta)
            @test isapprox(theta,zeros(size(X, 2)))
            @test length(f_vals) == 1
            @test length(etas) == 0
        end
        @testset "boundary case" begin
            # Check one Newton step improves objective.
            theta, f_vals, etas, times = newton_ascent(y, X, 1, alpha, beta)
            @test f_vals[2] >= f_vals[1] - 1e-8
        end
        @testset "bug catch" begin
            # Check objective is nondecreasing.
            theta, f_vals, etas, times = newton_ascent(y, X, 5, alpha, beta)
            @test all(diff(f_vals) .>= -1e-8)
        end
    end
end