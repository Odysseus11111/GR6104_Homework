
#First we implement the CRP function, specifically, we need to implement when given a fixed portfolio b
# we need to rebalance the portfolio each day back to this b, and what is the total wealth S_T(b).

#We have two inputs, prices x and portfolio b, and the output is wealth S_T(b)
using LinearAlgebra
function crp_func(prices:: Matrix{Float64},b::Vector{Float64})
    n,m = size(prices)
    wealth = ones(n)
    for i in 2:n
        x_t = prices[i,:]./prices[i-1,:]
        wealth[i] = wealth[i-1] *dot(b,x_t) 
    end
    return wealth
end