using LinearAlgebra

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

function forward_cho(A,b)
end