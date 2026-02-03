using Random
using Statistics
using Plots

# =========================================================================
# 1. 引入你的代码
# 确保路径正确，指向你 src 文件夹里的文件
# =========================================================================
include("C:/Users/Odysseus/GR6104_Homework/HW2/src/ks-stat.jl") # 修改为你的实际文件名


# 定义理论 CDF (Uniform[0,1])
H(t) = t 

# =========================================================================
# 2. 定义 Monte Carlo 模拟函数
# =========================================================================
function run_monte_carlo_simulation(n_values, num_trials)
    mean_ks_stats = Float64[]
    
    for n in n_values
        ks_values = Float64[]
        for _ in 1:num_trials
            # 生成符合 H(t) 的数据 (Uniform 0-1)
            data = rand(n)
            
            # 计算 KS 统计量
            stat = ks_func(data, H)
            push!(ks_values, stat)
        end
        # 记录该 n 下的平均 KS 统计量
        push!(mean_ks_stats, mean(ks_values))
    end
    
    return mean_ks_stats
end

# =========================================================================
# 3. 执行测试 (验证 Convergence Rate)
# =========================================================================
Random.seed!(1234) # 设置随机种子以复现结果

# 设定不同的样本量 n (指数增长)
n_range = [100, 200, 400, 800, 1600, 3200]
trials = 500 # 每个 n 模拟 500 次

println("开始运行 Monte Carlo 模拟...")
# 注意：这里调用的是上面定义的函数
mean_stats = run_monte_carlo_simulation(n_range, trials)

# =========================================================================
# 4. 可视化结果 (不使用 LaTeXStrings)
# =========================================================================
# 理论上，KS ~ 1/sqrt(n)，两边取对数: log(KS) ~ -0.5 * log(n) + C

p = plot(log10.(n_range), log10.(mean_stats), 
    label = "Simulated Mean KS",
    marker = :circle,
    xlabel = "log10(n)",                # 改成了普通字符串
    ylabel = "log10(Mean KS Statistic)", # 改成了普通字符串
    title = "Convergence Rate Test (Option 1)",
    lw = 2
)

# 添加参考线：斜率为 -0.5 的直线
# y = -0.5x + b (通过第一个点对齐截距)
intercept = log10(mean_stats[1]) - (-0.5 * log10(n_range[1]))
ref_line = -0.5 .* log10.(n_range) .+ intercept

plot!(p, log10.(n_range), ref_line, 
    label = "Theoretical Rate O(1/sqrt(n)) (Slope = -0.5)", # 改成了普通字符串
    linestyle = :dash, 
    color = :red
)

display(p)

# =========================================================================
# 5. 验证备择假设 (数据分布不匹配的情况)
# =========================================================================
println("\n验证错误分布的情况...")
# 生成 x^2 分布的数据，但用 Uniform(x) 去检验
wrong_data_mean = mean([ks_func(rand(1000).^2, H) for _ in 1:100]) 
println("当分布不匹配时 (n=1000)，Mean KS = $wrong_data_mean (应该远离 0)")