
""" First we define the empirical distribution functions empi_df, which calculates the 
result of the average value of 1[X_i<t] 
"""

function empi_df(val::Vector{Real},t::Real)
    n = length(val)
    count = 0
    for x in n
        if x<=t
            count +=1
        end
    end

    return count/n
end

"""Next, we write a function sort_func which can sort the input from small to large
"""
function sort_func(val::Vector(Real),any_func::Function)
    n = length(val)
    sorted_val = sort(val)
    max_val = 0

    for i in i:n
        x_i = sorted_val[i]
        Fn_t= i/n
        H_val = any_func(x_i)
        diff = abs(Fn_t-H_val)

        if diff > max_val
            max_val = diff
        end
    end
    return max_val
end

