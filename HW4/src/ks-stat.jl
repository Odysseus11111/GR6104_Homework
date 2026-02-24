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



function calculate_c(m,n,alpha)
    c = sqrt((1/2)*log(2/alpha)*(n+m)/(n*m))
    return c
end