

# 2.1 Create Data Write a function to generate covariates X that are in isotropic position
using LinearAlgebra
using Statistics

function iso_func(n,d)
    H = randn(n,d)
    F = eigen((1/n)*H'*H)
    W = F.vectors * diagm(1 ./ sqrt.(F.values)) * F.vectors'
    X = H*W
    return X 
end

#2.2 Implementation on Jackknife Estimator:
# (a) Leave One Out Function 
function leave_out_func(X,Y,i)
    n,d = size(X)
    @assert length(Y) ==n
    @assert 1 <= i <= n "Index i out of bounds"
        X_out = X[[1:i-1;i+1:n],:]
        Y_out = Y[[1:i-1;i+1:n]]
    return X_out, Y_out
end

# Calculate the leave_one_out OLS estimate beta_i
function ols_est_func(X,Y,i)
    X_out,Y_out = leave_out_func(X,Y,i)
    beta_i = (X_out' * X_out)\(X_out' * Y_out)

    return beta_i
end


# 2. Calculate A hat, i.e. the covariance 
#Here we set parallel = false and include a parallel condition here, this is because 
#overall we have two nested Multi-threaded code in our code,
#if we have two nested Multi-threaded part, the overall performance will be reduced.

function covar_func(X,Y;parallel = false)
    n,d = size(X)
    betas = zeros(d,n)
    if parallel
        Threads.@threads for i in 1:n
            betas[:,i] = ols_est_func(X,Y,i)
        end
    else 
        for i in 1:n
            betas[:,i] = ols_est_func(X,Y,i)
        end
    end
    
    beta_avg = vec(mean(betas,dims =2))
    A_sum = zeros(d,d)
    for i in 1:n
        A = (betas[:,i]-beta_avg)*(betas[:,i]-beta_avg)'
        A_sum += A
    end
    A = (1/(n-1)) * A_sum
    
    return A
end

# 3. Error
function error_jk(X,beta_true,sigma,r)

    n,d = size(X)
    @assert length(beta_true) == d
    error_ini = zeros(r)   
    covar_true = (sigma^2/n) * Matrix(I, d, d)

    Threads.@threads for i in 1:r
        noise = sigma * randn(n)
        Y = X * beta_true + noise
        covar_jk = covar_func(X,Y)
        norm_diff = opnorm(covar_jk - covar_true)
        error_ini[i] = norm_diff
    end
    return n*mean(error_ini)
end

