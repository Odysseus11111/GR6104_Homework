"""We write a function ks_func which can calculate the KS statistic, the function
should receive input from samples X_i's and samples Y_i's.
"""
function ks_func(X::AbstractVector,Y::AbstractVector)
    n = length(X)
    m =length(Y)
    labeled_x =[(val,x_val) for val in X]
    labeled_y =[(val,y_val) for val in y]
    combined_val = vcat(labeled_x,labeled_y)
    sorted_val = sort(val)
    max_val = 0.0

end
