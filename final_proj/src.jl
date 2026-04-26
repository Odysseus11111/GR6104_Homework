
#First we implement the CRP function, specifically, we need to implement when given a fixed portfolio b
# we need to rebalance the portfolio each day back to this b, and what is the total wealth S_T(b).

#We have two inputs, suppose we have m assets, on day T+1, the price can be written
# by prices matrix P. Let portfolio b be a vector that contains m component, b belongs to simplex
# The output is wealth S_T(b)

using LinearAlgebra
function crp_func(prices:: Matrix{Float64},b::Vector{Float64})
    n,m = size(prices)
    wealth = ones(n)
    for i in 2:n
        x_t = prices[i,:]./prices[i-1,:] # xt is the relative price return
        wealth[i] = wealth[i-1] *dot(b,x_t) 
    end
    return wealth
end

# Implementation on 2-dimentional simplex
function simplex_grid_2d(eta::Float64)
    grid = Vector{Vector{Float64}}()
    for b1 in 0.0:eta:1.0
        b2 =1.0-b1
        push!(grid,[b1,b2])
    end
    return grid
end
# When m = 3,4... , we can use multiple for loops to implement it, so it's natural
# to use the recursive function to extend the simplex function to m dimentional space

# We use chosen_weights to indicate the weights that have been assigned
# left_weights to indicate the remaining weights
# num_left to be the number of assets that still need to be assigned
function simplex_grid_md(m::Int,eta::Float64)
    grid_md = Vector{Vector{Float64}}()
    function recursive_func(chosen_weights::Vector{Float64},left_weights::Float64,num_left::Int)
        if num_left==1
            push!(grid_md,vcat(chosen_weights,left_weights))
            return
        else
            for k in 0.0:eta:left_weights 
        # Recursive step.
            recursive_func(vcat(chosen_weights,k), left_weights-k,num_left-1)
            end
        end
    end
    recursive_func(Float64[], 1.0, m)
    return grid_md
end

function bcrp_func_md(prices::Matrix{Float64},eta::Float64)
    n,m=size(prices)
    grid_md = simplex_grid_md(m,eta)
    # Initialization
    best_final_wealth = 0.0
    best_b = Float64[]
    best_wealth_set = Float64[]
    for b in grid_md
        wealth_set = crp_func(prices,b)
        final_wealth = wealth_set[end]
        if final_wealth > best_final_wealth
            best_b=b
            best_final_wealth =final_wealth
            best_wealth_set = wealth_set
        end
    end
    return best_b,best_final_wealth,best_wealth_set
end

# We implement the univeral portfolio algorithm
function uni_port_func(prices::Matrix{Float64},eta::Float64)
    n,m=size(prices)
    grid = simplex_grid_md(m,eta)
    num = length(grid)
    S_grid = ones(num)
    up_wealth=ones(n)
    b_weights=zeros(Float64,n,m)
    b_weights[1, :] .= 1.0 ./ m
    for t = 2:n
        x_t = prices[t,:]./prices[t-1,:]
        b_t = zeros(Float64,m)
        total_S = sum(S_grid)
        alpha = S_grid ./total_S
        for j in 1:num
            b_t .+=alpha[j].*grid[j]
        end
        up_wealth[t]=up_wealth[t-1]*dot(b_t,x_t)
        for j in 1:num
            S_grid[j]=S_grid[j]*dot(grid[j],x_t)
        end
        b_weights[t, :] = b_t
    end
    return up_wealth,b_weights,S_grid
end
        
# 