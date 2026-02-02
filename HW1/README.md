Homework 1 content

Part I: Setting Up Your Workflow

In the first part of the assignment, you will create a GitHub repository which you will use throughout
this course. Here are the requirements for the repository:
• (3 pts) The GitHub repository should be made “Private”, not “Public”.
• (2 pts) The repository should be initialized from scratch, i.e. do not fork any existing repository.
• (5 pts) The repository should have the following structure:
1. A README.md file which describes the purpose of the repository. Use correct Markdown
syntax with a header and body.
2. Each homework assignment should have a directory titled HWX, where X is the number of
the homework.
• (5 pts) After your initial commit, modify your README.md file in some way and push a second
commit with the message new and improved README.
• (5 pts) Add a .gitignore file which ignores all files within any subdirectory titled .ipynb_checkpoints
(Hint: you may want to do Part II and then return to this part)
• (5 pts) Invite Ting and Chris to the
repository


Part II: Ridge Regression (25 points)

In the second part of the assignment, you will create a simple Jupyter notebook where you demonstrate
the bias-variance trade-off in ridge regression. The purpose is to test drive the workflow that
you will be using in this class.
Everything in this part of the homework must appear in your HW1 subdirectory. In addition,
you should be committing changes to your GitHub repository regularly.
• (10 pts) Create a julia file titled ridge-regression.jl which contains
1. Ridge Regression: A function that returns the ridge regression estimate ˆ βridge, given
responses Y , covariates X, and ridge penalty γ.
2. Generate Data: A function that creates data. It takes as input n, β, σ, and Σ ∈ Rd×d
and returns samples covariates x1 . . . xn ∼ N(0,Σ2) and responses yi = ⟨xi, β⟩+ϵi where
ϵ1 . . . ϵn ∼ N(0, σ2) stored as an n-by-d matrix X and a vector Y .
3. Monte Carlo: A function that takes as input m and all the inputs to generate data (n,
β, σ, Σ) and then uses m Monte Carlo samples to estimate the bias and variance of the
ridge regression estimator under this distribution.
You are not permitted to use any external libraries other than those we saw in the tutorial,
i.e. you must code up ridge regression yourself. You should use the Revise.jl package so
that you can edit ridge-regression.jl while working inside your notebook.
• (15 pts) Create a Jupyter notebook titled hw1-workflow.ipynb. The notebook should contain
2
1. (5 pts) A simple sanity check to see that the ridge regression function is working.
2. (10 pts) A plot which shows the bias / variance trade-off for the choice of ridge penalty
γ. The x axis should contain the ridge penalty and you should plot (1) squared bias, (2)
variance, (3) mean squared error all in distinct colors.
You should iterate on your choice of n, β, σ, Σ, and m until you find your plot above to be
convincing. I suggest that you use a covariance matrix Σ which is low rank.

