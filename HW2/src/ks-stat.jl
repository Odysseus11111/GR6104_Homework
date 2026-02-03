
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