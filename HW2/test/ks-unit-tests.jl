using Test
include("C:/Users/Odysseus/GR6104_Homework/HW2/src/ks-stat.jl")
@testset"KS Statistics implementation tests" begin
"""
Consider the uniform cdf and define H(t) = t, we first test for the empi_df Function 
which is FX(t), let's consider when t is less than any of them, greater than any
of them, in the middle or exactly equal to some value in the data.  
"""
    data = [1,2,3,4]
    @testset empi_df(data,0) == 0
    @testset empi_df(data,5) == 1
    @testset empi_df(data,2.5) == 0.5
    @testset empi_df(data,2) == 0.5

end