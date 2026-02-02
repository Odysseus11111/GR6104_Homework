using LinearAlgebra
using Random
using Statistics

function ridge_regression(X,Y,y)
    beta =(X'*X + y*I) \ (X' *Y)
    n,d = size(X)
    return beta
end

function generate_data(n,beta,sigma,Sigma)
    d = length(beta)
    x_i = MvNormal(zero(d), Sigma * Sigma')
    X =rand(x_i,n)'
    eps =rand(Normal(0,sigma),n)
    Y= X* beta+eps
    return X,Y
end

