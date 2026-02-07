# Proof: 

### 
We want to prove that:

$$\sup_{t \in \mathbb{R}} | \hat{F}_X(t) - \hat{H}_Y(t) | = \max_{t \in \mathcal{X}} | \hat{F}_X(t) - \hat{H}_Y(t) |$$

The combined data set be $\mathcal{X} = \{X_1, \dots, X_n, Y_1, \dots, Y_m\}$.
Let $Z_1 \le Z_2 \le \dots \le Z_r$ be the sorted order of all points in $\mathcal{X}$, the total size is $r = n + m$.

Define the difference function:

$$D(t) = | \hat{F}_X(t) - \hat{H}_Y(t) |$$

The definitions of the empirical CDFs:

$$\hat{F}_X(t) = \frac{1}{n} \sum_{i=1}^n \mathbb{1}[X_i \le t], \quad \hat{H}_Y(t) = \frac{1}{m} \sum_{i=1}^m \mathbb{1}[Y_i \le t]$$

### Boundary Cases Analysis

**Case 1:($t \ge Z_r$)**

Consider the interval $[Z_r, \infty)$.
Since $Z_r$ is the maximum of all data points, for any $t \ge Z_r$, we have $t \ge X_i$ for all $i$ and $t \ge Y_j$ for all $j$.
Therefore, the indicator functions are all equal to 1:

$$\hat{F}_X(t) = 1 \quad \text{and} \quad \hat{H}_Y(t) = 1$$

Thus, the difference is:

$$D(t) = |1 - 1| = 0 \quad \text{for } t \in [Z_r, \infty)$$

**Case 2: Left Tail ($t < Z_1$)**

Consider the interval $(-\infty, Z_1)$.
Since $Z_1$ is the minimum, for any $t < Z_1$, we have $t < X_i$ and $t < Y_j$ for all the points.
Therefore, the indicator functions are all equal to 0:

$$\hat{F}_X(t) = 0 \quad \text{and} \quad \hat{H}_Y(t) = 0$$

Therefore the difference is:

$$D(t) = |0 - 0| = 0 \quad \text{for } t \in (-\infty, Z_1)$$

**Case 3: Data in between**

Consider an arbitrary interval $I_i = [Z_i, Z_{i+1})$ for $1 \le i < r$.
For any $t$ such that $Z_i \le t < Z_{i+1}$, no new points appear strictly between $Z_i$ and $Z_{i+1}$. Therefore, the set of data points less than or equal to $t$ is exactly equal to the data points less than or equal to $Z_i$.
Therefore,

$$\hat{F}_X(t) = \hat{F}_X(Z_i) \quad \text{(let this be constant } C_1)$$
$$\hat{H}_Y(t) = \hat{H}_Y(Z_i) \quad \text{(let this be constant } C_2)$$

The difference function $D(t)$ is also constant:

$$\forall t \in [Z_i, Z_{i+1}), \quad D(t) = |C_1 - C_2| = | \hat{F}_X(Z_i) - \hat{H}_Y(Z_i) | = D(Z_i)$$


We can decompose the real line $\mathbb{R}$ into the partition defined by the sorted points $Z$:

$$\sup_{t \in \mathbb{R}} D(t) = \max \left( \sup_{t < Z_1} D(t), \quad \max_{1 \le i < r} \left( \sup_{t \in [Z_i, Z_{i+1})} D(t) \right), \quad \sup_{t \ge Z_r} D(t) \right)$$

By:

* $\sup_{t < Z_1} D(t) = 0$
* $\sup_{t \ge Z_r} D(t) = 0$
* $\sup_{t \in [Z_i, Z_{i+1})} D(t) = D(Z_i)$ (Since it is constant on the interval)

We can have:

$$\sup_{t \in \mathbb{R}} | \hat{F}_X(t) - \hat{H}_Y(t) | = \max_{i=1, \dots, r} | \hat{F}_X(Z_i) - \hat{H}_Y(Z_i) |$$

Since $\{Z_1, \dots, Z_r\}$ is exactly the set $\mathcal{X}$, the theorem is proven:

$$\sup_{t \in \mathbb{R}} | \hat{F}_X(t) - \hat{H}_Y(t) | = \max_{t \in \mathcal{X}} | \hat{F}_X(t) - \hat{H}_Y(t) | \quad \square$$