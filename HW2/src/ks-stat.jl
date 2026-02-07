"""We write a function ks_func which can calculate the KS statistic, the function
should receive input from samples X_i's and samples Y_i's.
"""
function ks_func(X::AbstractVector,Y::AbstractVector)
    n = length(X)
    m =length(Y)
    labeled_x =[(val,x_val) for val in X]
    labeled_y =[(val,y_val) for val in y]
    combined_val = vcat(labeled_x,labeled_y)
    sort!(combined_val,by =p->p[1])

    cdf_x = 0.0
    cdf_y =0.0
    max_diff =0.0

    for (val,source) in combined_val
        if source == labeled_x
            cdf_x += 1/n
        else
            cdf_y += 1/m
        end
        current_diff = abs(cdf_x-cdf_y)

        if current_diff > max_diff
            max_diff = combined_val
        end
    end
    return max_diff
end
