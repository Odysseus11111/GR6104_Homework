using LinearAlgebra

#1. Construct Factorization
function choley_fac(A)
    # Check whether A is positive definite matrix
    if !(issymmetric(A) && all(eigvals(A).>0))
        error("The matrix A is not positive definite!")
    else 
        n = size(A,1)
        L = zeros(n,n)
        for j=1:n
            diag_sums = 0.0
            for k =1:j-1
                diag_sums += L[j,k]^2
            end
            L[j,j] = sqrt(A[j,j] -diag_sums)
            for i =j+1:n
                all_sums = 0.0
                for k = 1:j-1
                    all_sums += L[i,k]*L[j,k]
                end
                L[i,j] = (1/L[j,j])*(A[i,j] -all_sums)
            end
        end
    end
    return L
end

# 2. Linear System Solve
function forward_cho(L,b)
    n = length(b)
    y= zeros(n)
    for i in 1:n
        temp_sum = 0.0
        for j in 1:i-1
            temp_sum += L[i,j]*y[j]
        end 
        y[i]=(b[i]-temp_sum)/L[i,i]
    end
    return y
end


function backward_cho(U,y)
    n = length(y)
    x= zeros(n)
    for i in n:-1:1
        temp_sum = 0.0
        for j in i+1:n
            temp_sum += U[i,j]*x[j]
        end 
        x[i]=(y[i]-temp_sum)/U[i,i]
    end
    return x
end

# Combine the forward and backward cholesky method to get x
function cholesky_solve(L,b)
    y = forward_cho(L,b)
    x = backward_cho(L',y)
    return x
end

# 3.Low Rank Update
function low_rank(L, v)
    L_new = float.(copy(L))
    v_curr = float.(copy(v)) 
    n = size(L_new, 1)
    for j in 1:n
        r = sqrt(L_new[j,j]^2+ v_curr[j]^2)
        co = L_new[j,j]/r
        si = v_curr[j]/r
        L_new[j,j] = r
        for i in (j+1):n
            L_orig = L_new[i,j]
            v_orig = v_curr[i]
# Do the rotation
            L_new[i,j] = co*L_orig + si*v_orig
            v_curr[i]  = co*v_orig -si*L_orig
        end
    end

    return L_new
    
end