# GR6104 Final Project: Universal Portfolio Algorithm

This file contains the code for my GR6104 final project. It focuses on the implementation and empirical evaluation of Cover's Universal Portfolio Algorithm.

##Overview

In this project, I implement the following functions :

1. Constant Rebalanced Portfolio (CRP)
    The wealth trajectory of a fixed constant rebalanced portfolio.
2. Best Constant Rebalanced Portfolio in hindsight (BCRP), Buy-and-Hold strategy
    The best constant rebalanced portfolio in hindsight
3. Simplex Function - 2 dimentions & m dimentions
4. Universal Portfolio Algorithm
    A discretized approximation of Cover's Universal Portfolio Algorithm using a finite grid over the simplex

UPA is not a good choice in real life investment, due to its computational limitation. And I will use this chance to better understand why is so. See the computational cost of a grid-based implementation.

## Apart from above, I also do: 

1. **Stock data download**  
   Downloads real stock price data from Yahoo Finance using `yfinance`.

2. **Unit tests**  
   Tests the CRP, BCRP, simplex grid, and uiversal portfolio function.

3. **Runtime analysis**  
   The expected runtime:
   \[
   O(TKm).
   \]

   We run three sets of experiments to learn the computational complexity of the implementation since its theoretical runtime depends on three variables:
   - \(T\): number of trading days
   - \(K\): number of grid portfolios
   - \(m\): number of assets

4. **Error plots**  
   Plots for log regret, and the result of finer grid.

5. **Moderately large stock experiment**  
   Applies our algorithm to a larger real stock data set by increasing the number of stocks and/or the time horizon.




## Result

The main computational limitation of this algorithm is the rapid growth of simplex grid size, which makes things difficult when we increase number of assets m.