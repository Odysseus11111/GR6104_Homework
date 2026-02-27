using Revise
using Statistics
using Plots
using Random

Threads.nthreads()
includet("../src/jackknife.jl")


r =5000
sigma = 1
d =20
ns= collect(round.(Int,range(100,500,length=10))) 

exp_error_ini = zeros(length(ns))
time_records = zeros(length(ns))
beta_true = ones(d)

for (i,n) in enumerate(ns)
    X = iso_func(n, d)
    time_records[i] = @elapsed begin
        exp_error_ini[i]  = error_jk(X,beta_true,sigma,r)
    end
    println("n =$n; Covariance Error:$(round(exp_error_ini[i],digits = 4)); Time_records:$(round(time_records[i],digits=2))s")
end

p1 = plot(ns,exp_error_ini,
    xlabel = "Sample Size n:",
    ylabel = "Expectation Covariance Error Plot",
    title = "Expectation Covariance Error Plot with n",
    marker =:circle,
    color =:blue
)

p2= plot(ns, time_records,
    xlabel = "Sample Size n",
    ylabel = "Elapsed Time (seconds)",
    title = "Simulation Time vs Sample Size n",
    marker = :circle,
    color = :red,  
    linewidth = 2,
)

final_plot =plot(p1,p2,layout=(1,2))
display(final_plot)

max_num = maximum(ns)
mkpath("HW4/fig")
savefig(final_plot, "HW4/fig/error_time_plots_n$(max_num).png")

