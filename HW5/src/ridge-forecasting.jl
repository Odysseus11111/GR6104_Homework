using LinearAlgebra
include("gauss-elim.jl")
include("cholesky-factors.jl")

# 1. Naive Implementation
function naive_ridge(X, Y, gamma)
    T,d=size(X)
    length(Y) == T || error("Dimension mismatch")
    gamma > 0 || error("gamma must be >0")
    Y_hat=zeros(T)
    I_d=Matrix{Float64}(I, d, d) 
    for t in 1:T
        x_t=X[t, :]
        if t==1
            beta_t=zeros(d)
        else
            X_prev=X[1:t-1, :]
            Y_prev=Y[1:t-1]
            b_t=X_prev'*Y_prev
            A_t=X_prev'*X_prev+gamma*I_d
            beta_t = gauss_elimi(A_t, b_t)
        end
        Y_hat[t] = dot(x_t, beta_t)
    end

    return Y_hat

end

# 2.Fast Implementation
function fast_ridge(X, Y, gamma)
    T,d=size(X)
    length(Y) == T || error("Dimension mismatch")
    gamma > 0 || error("gamma must be >0")
    Y_hat=zeros(T)
    L=sqrt(gamma)*Matrix{Float64}(I, d, d)
    b=zeros(d)

    for t in 1:T
        x_t=X[t, :]
        if t > 1
            x_prev=X[t-1, :]
            y_prev=Y[t-1]
            b+= x_prev * y_prev
            L=low_rank(L, x_prev)
        end
        beta_t=cholesky_solve(L, b)
        Y_hat[t]=dot(x_t, beta_t)
    end
    
    return Y_hat

end