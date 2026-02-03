# Proof of Theorem :


Let $X_{(1)} \le X_{(2)} \le \dots \le X_{(n)}$ be the order statistics of the sample $\{X_1, \dots, X_n\}$. Define $X_{(0)} = -\infty$ and $X_{(n+1)} = \infty$.

The empirical CDF $\hat{F}_X(t)$ is a step function that is constant on the interval $[X_{(i)}, X_{(i+1)})$. We have:
$$
\hat{F}_X(t) = \frac{i}{n} \quad \text{for } t \in [X_{(i)}, X_{(i+1)})
$$
for $i = 0, \dots, n$ (where $\hat{F}_X(t) = 0$ for $t < X_{(1)}$ and $\hat{F}_X(t) = 1$ for $t \ge X_{(n)}$).

The difference function $D(t) = \hat{F}_X(t) - H(t)$ on a specific interval $[X_{(i)}, X_{(i+1)})$.
On this interval, $\hat{F}_X(t)$ is constant (equal to $\frac{i}{n}$).
Since $H(t)$ is an increasing function,
Therefore, $D(t) = \frac{i}{n} - H(t)$ is a monotonically decreasing function on this interval.

Because $D(t)$ is monotonic, the maximum absolute difference $|D(t)|$ on the closure of $[X_{(i)}, X_{(i+1)}]$ must occur at one of the endpoints. i.e :
the supremum over the interval is:
$$
\sup_{t \in [X_{(i)}, X_{(i+1)})} |D(t)| = \max \left( \left| \hat{F}_X(X_{(i)}) - H(X_{(i)}) \right|, \lim_{t \to X_{(i+1)}^-} \left| \hat{F}_X(t) - H(t) \right| \right)
$$, which proved the conclusion.
