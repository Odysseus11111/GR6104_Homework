# Question 1 
1. Hardware: CPU : Intel(R) Core(TM) Ultra 7 155H, and the number of physical cores that is has is 16.


# Question 2. Discussion

(a) How does the error behave as $n$ grows?

As $n$ increases from 100 to 500, the expectation covariance error steadily grows but exhibits a concave shape. This behavior reflects that the covariance estimation stabilizes and the error relative to the true covariance converges.

(b) How long does your code take to run? How does the running time depend on the sample size $n$?

On my machine, the elapsed time per sample size grows from tens of seconds for small to over 300 seconds when n=500.
The running time exhibits a quadratic relationship with the sample size $n$ ($\mathcal{O}(n^2)$).But noted that there is a noticeable jump around $n=300$. This might be due toe the system/performance effects. 
This quadratic behavior occurs because of the mechanics of the Jackknife method. For a dataset of $n$, the algorithm leaves one observation out and recalculates OLS estimate $n$ separate times. Since computing a single OLS estimate involves matrix operations time $\mathcal{O}(n \cdot d^2)$, repeating this process $n$ times leads to an overall computational complexity that scales with $n^2$.

(c) Rough estimate for the sample size $n_{max}$ requiring 2 hours:

From the local plot, computing $n = 500$ took approximately 335 seconds. Thus, the constant is: $$c = \frac{335}{500^2} = 0.00134$$
    
The total time $T_{total}$ for 10 evenly spaced points is:
$$T_{total} = \sum_{i=1}^{10} c \cdot \left(i \cdot \frac{n_{max}}{10}\right)^2 = c \cdot \frac{n_{max}^2}{100} \sum_{i=1}^{10} i^2$$
    
Given that $\sum_{i=1}^{10} i^2 = 385$, the total time simplifies to:
$$T_{total} = 3.85 \cdot c \cdot n_{max}^2$$
    
Setting the target total time to 2 hours (7,200 seconds):

$$
n_{max} \approx 1181
$$ 

Therefore we set $n_{\max} = 1200$.



# Question 3. 
(a) How does the error behave as $n$ grows?

As $n$ grows, the expectation covariance error steadily increases but at a decelerating rate. It approaches near 1.0. This behavior demonstrates the statistical consistency of the Jackknife estimator. 

(b) How long does the code take to run? How does runtime depend on $n$?

On the HPC cluster, the entire script (from $n=100$ to $n=1200$) takes approximately 5 minutes to run in total. The text output log indicates that the final and largest simulation step ($n=1200$) took roughly 50 seconds to 
complete.
The running time of the simulation depends quadratically on the sample size. This relationship is illustrated in the plot, which forms a parabolic curve. This aligns with the algorithmic complexity of the Jackknife estimator: because the algorithm performs $n$ leave-one-out OLS estimations for each of the $r$ Monte Carlo simulations, the computational cost scales at $\mathcal{O}(n^2)$.

(c) Compare the cluster plots to the plots generated on your machine. Explain differences.

When comparing the local plots ($n_{max}=500$) with the cluster plots ($n_{max}=1200$), there are two major differences：

(1)In the local plot, the sample size only goes up to $n=500$. And the expectation covariance error is still in a relatively steep climbing phase. However, in the cluster's error plot, we can clearly observe the curve flattening out, which provides strong empirical evidence of the estimator's statistical consistency over large sample sizes.
(2) While both time plots correctly exhibit the $\mathcal{O}(n^2)$ parabolic shape, their Y-axis scales are vastly different due to hardware capabilities. On the local machine, computing the final iteration of $n=500$ took over 330 seconds. However, the cluster computed $n=1200$ in just 80 seconds. Given the $\mathcal{O}(n^2)$ complexity, This demonstrates how the 50 HPC cores successfully distributed the heavy leave-one-out loops.