
""" First we define the empirical distribution functions empi_df, which calculates the 
result of the average value of 1[X_i<=t] 
"""
function empi_df(val::Vector,t::Real)
    n = length(val)
    count = 0
    for x in val
        if x<=t
            count +=1
        end
    end

    return count/n
end
"""Next, we write a function ks_func which can calculate the KS statistic.
This function sorts the input `val` and computes the maximum distance 
between the empircial CDF F and the theoretical CDF H
"""
function ks_func(val::Vector,func::Function)
    n = length(val)
    sorted_val = sort(val)
    max_val = 0.0
    

    for i in 1:n
        x_i = sorted_val[i]
        H_val = func(x_i)
        max_val = max(max_val, abs(i/n-H_val),abs((i-1)/n-H_val))
    end
    return max_val
end

