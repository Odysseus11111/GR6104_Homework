# GR6104 Final Project: Universal Portfolio Algorithm

This file contains the code for my GR6104 final project. It focuses on the implementation and empirical evaluation of Cover's Universal Portfolio Algorithm.

## Structure

### `dataset/`
Contains the data and data-preparation notebook.

- `findata.ipynb`: downloads/prepares stock data.
- `prices_4stocks.csv`: 4-stock price data.
- `prices_6stocks_20years.csv`: 6-stock, 20-year price data.

### `notebooks/`
Contains experiment notebooks and generated results.

- `experiment1.ipynb`–`experiment4.ipynb`: main experiments.
- `grid_refinement_results.csv`: results for grid refinement.
- `time_horizon_results.csv`: results for time horizon analysis.
- `wealth_trajectories.png`: example wealth trajectory plot.
- `plot/`: experiment plots.
- `error_time_plot/`: runtime and error plots.

### `src/`
Contains the main Julia implementation.

- `src.jl`: CRP, BCRP, simplex grid, and Universal Portfolio functions.

### `unit_test/`
Contains unit tests.

- `unit_test.jl`: tests for the main functions.
- `test_result.txt`: saved unit test output.

# Overview

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
   Downloads real stock price data from Yahoo Finance using `YFinance`.

2. **Unit tests**  
   Tests the CRP, BCRP, simplex grid, and uiversal portfolio function.

3. **Replication of Cover's paper**  
   Reproduced key examples from Cover's original paper to verify the implementation and better understand the algorithm.

4. **Runtime analysis**  
   The expected runtime of the grid-based implementation is

   \[
   O(TKm).
   \]

   Here:
   - \(T\) is the number of trading days,
   - \(K\) is the number of grid portfolios,
   - \(m\) is the number of assets.

   I ran several experiments to study the computational complexity of the implementation. Specifically, I fixed \(T\) and \(m\) while changing \(K\) in Experiment 3, and fixed \(K\) and \(m\) while changing \(T\) in Experiment 4.

5. **Moderately large stock experiment**  
   Applies our algorithm to a larger real stock data set by increasing the number of stocks and/or the time horizon. (We use increase the stock data from 1 year to 20 years)

## Result

The main computational limitation of this algorithm is the rapid growth of simplex grid size, which makes things difficult when we increase number of assets m.