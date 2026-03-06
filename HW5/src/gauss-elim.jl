# To calculate x using Gaussian elimination, we need two steps:
#   (1) Forward elimination
#   (2) Backward substitution
# During forward elimination, we check whether the pivot A[k,k] is zero.
# If a zero pivot is encountered, the algorithm throws an error.
# Otherwise, we use backward substitution to solve for x.

function gauss_elimi(A,b)
    size(A,1) == size(A,2) || error("A is not a square matrix!")
    length(b) == size(A,1) || error("Dimension does not match!")
    A_cal = float.(copy(A))
    b_cal = float.(copy(b))
    A_forward, b_forward = forward_elim(A_cal,b_cal)
    x = backward_sub(A_forward,b_forward)
    return x
end

function forward_elim(A,b)
    n = length(b)
    for k in 1:n-1
        if A[k,k]==0.0
            error("Zero pivot !!!")
        end 
        for i in k+1:n
            factor = A[i,k]/A[k,k]
            for j in k:n
                A[i,j] = A[i,j] - factor*A[k,j]
            end
            b[i] = b[i]- factor *b[k]
        end
    end
    return A,b 
end

function backward_sub(A,b)
    n = length(b)
    x= zeros(n)
    for i in n:-1:1
        if A[i,i]==0.0
            error("Zero diagonal!")
        end
        temp_sum = 0.0
        for j in i+1:n
            temp_sum += A[i,j]*x[j]
        end 
        x[i]=(b[i]-temp_sum)/A[i,i]
    end
    return x

end