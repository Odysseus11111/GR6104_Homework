
# To calculate x using gauss elimination method, we need two steps:
#   (1) Forward elimination
#   (2) Backward backward substitution
# First, we look at the value in diagonal of A after forward elimination, 
# if A[k,k] == 0 then output error, if it doesn't go wrong, we pass A to 
# do backward substitution.

function gauss_elimi(A,b)
    A_cal = float.(copy(A))
    b_cal = float.(copy(b))
    A_forward, b_forward = forward_elim(A_cal,b_cal)
    n = length(b)
    for k in 1:n
        if A_forward[k,k] ==0.0
        error("Error! No such x exists")
        end
    end
        x = backward_sub(A_forward,b_forward)
    return x
end

function forward_elim(A,b)
    n = length(b)
    for k in 1:n-1
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
        temp_sum = 0.0
        for j in i+1:n
            temp_sum += A[i,j]*x[j]
        end 
        x[i]=(b[i]-temp_sum)/A[i,i]
    end
    return x

end