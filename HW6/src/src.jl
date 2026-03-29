# Code Implementation for Gradient Descent Method
#Since f is concave and we maximize the log-likelihood, the implementation 
#uses gradient ascent with backtracking.


using LinearAlgebra 

function link_func(y)
     return 1/(1+exp(-y))
end

function predict_prob(theta::Vector{Float64}, X::Matrix{Float64})
    n = size(X, 1)
    y_hat = zeros(n)
    for i in 1:n
        y_hat[i] = link_func(dot(@view X[i, :], theta))
    end
    return y_hat
end

function gradient_func(theta::Vector{Float64},X::Matrix{Float64},y::Vector{Float64})
    y_hat = predict_prob(theta,X)
    return X' *(y-y_hat)
end


function f_func(theta::Vector{Float64},X::Matrix{Float64},y::Vector{Float64})
    n =length(y)
    val = 0.0
    for i in 1:n
        xi = @view X[i,:]
        p = link_func(dot(xi,theta))
        val += y[i]*log(p) + (1-y[i])*log(1-p)
    end
    return val
end
function backtracking_ascent(theta::Vector{Float64},d::Vector{Float64},X::Matrix{Float64},y::Vector{Float64},alpha::Float64,beta::Float64)
    eta = 1.0
    f_theta = f_func(theta, X, y)
    g_theta = gradient_func(theta, X, y)

    while f_func(theta + eta * d, X, y) < f_theta + alpha * eta * dot(g_theta, d)
        eta *= beta
    end
    return eta
end
function gradient_ascent(y::Vector{Float64}, X::Matrix{Float64}, T_max::Int, alpha::Float64, beta::Float64)
    _,d = size(X)
    theta = zeros(d)
    f_vals =zeros(T_max +1)
    etas = zeros(T_max)
    times = zeros(T_max)
    f_vals[1] = f_func(theta, X, y)

    for t in 1:T_max
        elapsed = @elapsed begin
            g = gradient_func(theta,X,y)
            eta = backtracking_ascent(theta, g, X, y, alpha, beta)
            theta = theta + eta*g
            etas[t] =eta
            f_vals[t+1] = f_func(theta,X,y)
        end
        times[t] = elapsed
    end
    return theta,f_vals,etas,times
end

# Dampened Newton’s Method
#that implements backtracking to select a step size.

function hessian_func(X::Matrix{Float64}, theta::Vector{Float64})
    y_hat = predict_prob(theta, X)
    W =Diagonal(y_hat .*(1 .-y_hat))
    return -(X' * W * X)
end

function newton_dir(X::Matrix{Float64},theta::Vector{Float64},y::Vector{Float64})
    H = hessian_func(X,theta)
    g =gradient_func(theta,X,y)
    return -(H\g)
end 

function newton_ascent(y::Vector{Float64}, X::Matrix{Float64}, T_max::Int, alpha::Float64, beta::Float64)
    _,d = size(X)
    theta = zeros(d)
    f_vals =zeros(T_max +1)
    etas = zeros(T_max)
    times = zeros(T_max)
    f_vals[1] = f_func(theta, X, y)

    for t in 1:T_max
        elapsed = @elapsed begin
            d_newton =newton_dir(X,theta,y)
            eta = backtracking_ascent(theta, d_newton, X, y, alpha, beta)
            theta = theta + eta*d_newton
            etas[t] =eta
            f_vals[t+1] = f_func(theta,X,y)
        end
        times[t] = elapsed
    end
    return theta,f_vals,etas,times
end
