# 1.4(a) Plot Typo I Error 
using Plots
include("ks-stat.jl")

alpha = 0.05 
r = 5000
ns= collect(round.(Int,range(200,10000,length=20))) 
n = ns
ys_serial = serial_func.(n,n,alpha,r)
ys_parallel = parallel_func.(n,n,alpha,r)
p1 = plot(ns,ys_serial,
    label = "Serial Function",
    xlabel = "Sample Size n:",
    ylabel = "Type I Error",
    title = "Type I Error Plot",
    marker =:circle
)
plot!(p1,ns,ys_parallel,
    label = "Parallel Function",
    xlabel = "Sample Size n:",
    ylabel = "Type I Error",
    title = "Type I Error Plot",
    marker =:circle
)
hline!([alpha],linestyle = :dash,label = "Nominal alpha $alpha")


#1.4(b) Plot Elapsed Time
ns = collect(round.(Int,range(200,10000,length=20)))
alpha =0.05
r = 5000
time_serial=zeros(length(ns))
time_parallel = zeros(length(ns))
serial_func(100,100,alpha,r)
parallel_func(100,100,alpha,r)
for (i,n) in enumerate(ns)
    time_serial[i] = @elapsed serial_func(n,n,alpha,r)
    time_parallel[i] = @elapsed parallel_func(n,n,alpha,r)
    println("Number Samples: $n \t Serial Elapsed Time: $(time_serial[i]) \t Parallel Elapsed Time: $(time_parallel[i])")
end 
p2 = plot(ns,time_serial,
    xlabel = "The Sample Size",
    ylabel = "The amount of elapsed time",
    label = "Elapsed Time of Serial Function",
    title = "Plot Elapsed Time",
    marker =:circle
)
plot!(p2,ns,time_parallel,
    label = "Elapsed Time of Parallel Function",
    title = "Plot Elapsed Time",
    marker =:dot
)
display(p1)
display(p2)

savefig(p1, joinpath(@__DIR__, "../fig/type1_error_plot.png"))
savefig(p2, joinpath(@__DIR__, "../fig/elapsed_time_plot.png"))