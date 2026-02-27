using Revise
using Random
Threads.nthreads()

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
        while i <=n && sort_x[i]== current_val #Not current_val_x == sort_x[i]
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

# calculate_c
function calculate_c(m,n,alpha)
    Random.seed!(123)
    c = sqrt((1/2)*log(2/alpha)*(n+m)/(n*m))
    return c
end

#This a serial function which estimates Pr(S > c(α))\
function serial_func(m,n,alpha,r)
    Random.seed!(123)
    c_val = calculate_c(m,n,alpha)
    count = 0
    for _ in 1:r
        X = randn(m)
        Y = randn(n)
        ks = ks_func_2pt(X,Y)

        if ks > c_val
            count +=1
        end
    end
    return count/r
end

n=1000
m=1000
alpha = 0.05
r = 1000
result = serial_func(m,n,alpha,r)
println("Estimated Type I Error: ",result)

#This is a parallel function that estimates Pr(S > c(α))
#Avoid race condition

function parallel_func(m,n,alpha,r)
    Random.seed!(123)
    c_val = calculate_c(m,n,alpha)
    chunk_size =cld(r,Threads.nthreads())
    chunk = Iterators.partition(1:r,chunk_size)
    tasks = map(chunk) do chunk
        Threads.@spawn begin
            count  = 0
            for _ in chunk 
                X = randn(m)
                Y = randn(n)
                ks = ks_func_2pt(X,Y)
                if ks > c_val
                    count +=1
                end
            end
        return count
        end
    end
    chunks = sum(fetch.(tasks))
    total_sum = chunks/r
    return total_sum
end

