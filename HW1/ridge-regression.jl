using LinearAlgebra
using Random
using Statistics
using Distributions
using Plots

function ridge_regression(X,Y,y)
    n,d = size(X)
    beta = (X'*X + y*I) \ (X'*Y)
    return beta
end

function generate_data(n,beta,sigma,Sigma)
    d = length(beta)
    x_i = MvNormal(zeros(d), Sigma)
    X = Matrix(rand(x_i, n)')
    eps =rand(Normal(0,sigma),n)
    Y= X* beta+eps
    return X,Y
end

function mc_ridge(m,n,beta,sigma,Sigma,y) 
    d = length(beta)
    B=Matrix(undef,d,m)

    for i in 1:m
        X,Y= generate_data(n,beta,sigma,Sigma)
        B[:,i] = ridge_regression(X,Y,y)
    end

    mean_beta_fit = mean(B, dims=2)
    bias = vec(mean_beta_fit) - beta
    var_fit = vec(var(B, dims=2))
    return bias, var_fit
end
