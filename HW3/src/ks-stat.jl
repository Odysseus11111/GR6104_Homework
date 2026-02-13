"""We combined the ks_func_parallel, ks_func_2pt function together with ks_func, which further improve performance. The new function
also receive input from samples X_i's and samples Y_i's.
"""


# Implementation for the alternatives parallel function 
function ks_func_parallel(X::AbstractVector, Y::AbstractVector)
    # We spawn a task to sort Y on a separate thread
    y_task = Threads.@spawn sort(Y)
    sx =sort(X)
    sy = fetch(y_task)::Vector{eltype(Y)} #Wait for Y to finish the sorting and fetch the result
    i =1
    j =1
    cdf_x =0
    cdf_y =0
    n = length(sx)
    m = length(sy)
    max_diff= 0

    while i<=n || j<=m 
        if i>n
            current_val = sy[j]
        elseif j>m
            current_val = sx[i]
        else 
            current_val = min(sx[i],sy[j])
        end
    

        while i <=n && sx[i]== current_val #??current_val_x == sort_x[i]
            cdf_x +=1/n
            i+=1
        end

        while j <=m && sy[j]== current_val
            cdf_y +=1/m
            j+=1
        end

        curr_diff = abs(cdf_x-cdf_y)
        if curr_diff > max_diff
            max_diff =curr_diff
        end

    end

    return max_diff
end

# Implementation for the alternatives two-pointer function 


function ks_func_2pt(X::AbstractVector,Y::AbstractVector)

    max_diff= 0
    cdf_x = 0
    cdf_y = 0
    n = length(X)
    m = length(Y)
    sort_x = sort(X)
    sort_y =sort(Y)
    i=1
    j=1

    while i<=n || j<=m 
        if i>n
            current_val = sort_y[j]
        elseif j>m
            current_val = sort_x[i]
        else 
            current_val = min(sort_x[i],sort_y[j])
        end
    

        while i <=n && sort_x[i]== current_val #??current_val_x == sort_x[i]
            cdf_x +=1/n
            i+=1
        end

        while j <=m && sort_y[j]== current_val
            cdf_y +=1/m
            j+=1
        end

        curr_diff = abs(cdf_x-cdf_y)
        if curr_diff > max_diff
            max_diff =curr_diff
        end

    end

    return max_diff

end        

#Original Function from HW2
function ks_func(X::AbstractVector,Y::AbstractVector)
    n = length(X)
    m =length(Y)
    labeled_x =[(val,"x_val") for val in X]
    labeled_y =[(val,"y_val") for val in Y]
    combined_val = vcat(labeled_x,labeled_y)
    sort!(combined_val,by =p->p[1])

    cdf_x = 0.0
    cdf_y =0.0
    max_diff =0.0

    total_num = length(combined_val)

    for (i, (val,source)) in enumerate(combined_val)
        if source == "x_val"
            cdf_x += 1/n
        else
            cdf_y += 1/m
        end

        if i < total_num && combined_val[i+1][1] ==val
            continue
        end 

        current_diff = abs(cdf_x-cdf_y)

        if current_diff > max_diff
            max_diff = current_diff
        end
    end

    return max_diff
end
