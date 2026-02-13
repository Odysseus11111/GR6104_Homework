using Test
include("C:/Users/Odysseus/GR6104_Homework/HW3/src/ks-stat.jl")



@testset "KS Statistics Iterative Version 2 Optimization using parallel method unit tests" verbose=true begin
    
    # 1. Simple Examples            
    @testset "ks_func_parallel: Simple Examples" begin
        @test ks_func_parallel([1, 2], [1, 2]) == 0.0
        @test ks_func_parallel([1, 2], [10, 11]) == 1.0
        x_1 = [1,2,3,4]
        y_1 = [3,4,5,6,7] 
        @test ks_func_parallel(x_1, y_1) == 0.6
        end

    # 2. Corner Cases:
    #I include the single-element arrays and comparison between a single value and a range.
    #And ensures the function handles negative numbers correctly.
    @testset "ks_func_parallel: Corner Cases" begin
        @test ks_func_parallel([1], [1]) == 0

        @test isapprox(ks_func_parallel([10], collect(1:10)), 0.9)

        neg_x = [-1,-2,-3,-4] 
        neg_y = [-1,2,-3,4]
        @test ks_func_parallel(neg_x,neg_y) ==0.5
        end

    # 3. Squashing Bugs 
    #I initially overlooked the edge case where multiple values are exactly equal. 
    #This caused the code to calculate the mean prematurely without including all the duplicate numbers. 
    #The 'Squashing Bugs' test case helped me identify this issue.
    # I fixed it by adding a loop that checks for duplicates and ensures the mean is calculated only 
    #after all identical values (ties) are added to the cumulative sum.
        @testset "Squashing Bugs" begin
            @test ks_func_parallel([1, 2, 2], [1, 2, 2]) == 0.0
            x_int = [1,2]
            y_float = [1.0, 2.0]
            @test ks_func_parallel(x_int, y_float) == 0.0
        end
    end




@testset "KS Statistics Iterative Version 1 using 2-pointer Optimization unit tests" verbose=true begin
    
    # 1. Simple Examples            
    @testset "ks_func_2pt: Simple Examples" begin
        @test ks_func_2pt([1, 2], [1, 2]) == 0.0
        @test ks_func_2pt([1, 2], [10, 11]) == 1.0
        x_1 = [1,2,3,4]
        y_1 = [3,4,5,6,7] 
        @test ks_func_2pt(x_1, y_1) == 0.6
        end

    # 2. Corner Cases:
    #I include the single-element arrays and comparison between a single value and a range.
    #And ensures the function handles negative numbers correctly.
    @testset "ks_func_2pt: Corner Cases" begin
        @test ks_func_2pt([1], [1]) == 0

        @test isapprox(ks_func_2pt([10], collect(1:10)), 0.9)

        neg_x = [-1,-2,-3,-4] 
        neg_y = [-1,2,-3,4]
        @test ks_func_2pt(neg_x,neg_y) ==0.5
        end

    # 3. Squashing Bugs 
    #I initially overlooked the edge case where multiple values are exactly equal. 
    #This caused the code to calculate the mean prematurely without including all the duplicate numbers. 
    #The 'Squashing Bugs' test case helped me identify this issue.
    # I fixed it by adding a loop that checks for duplicates and ensures the mean is calculated only 
    #after all identical values (ties) are added to the cumulative sum.
        @testset "Squashing Bugs" begin
            @test ks_func_2pt([1, 2, 2], [1, 2, 2]) == 0.0
            x_int = [1,2]
            y_float = [1.0, 2.0]
            @test ks_func_2pt(x_int, y_float) == 0.0
        end
    end

@testset "KS Statistics Original Version implementation tests" verbose=true begin
    
    # 1. Simple Examples            
    @testset "ks_func: Simple Examples" begin
        @test ks_func([1, 2], [1, 2]) == 0.0
        @test ks_func([1, 2], [10, 11]) == 1.0
        x_1 = [1,2,3,4]
        y_1 = [3,4,5,6,7] 
        @test ks_func(x_1, y_1) == 0.6
        end

    # 2. Corner Cases:
    #I include the single-element arrays and comparison between a single value and a range.
    #And ensures the function handles negative numbers correctly.
    @testset "ks_func: Corner Cases" begin
        @test ks_func([1], [1]) == 0

        @test isapprox(ks_func([10], collect(1:10)), 0.9)

        neg_x = [-1,-2,-3,-4] 
        neg_y = [-1,2,-3,4]
        @test ks_func(neg_x,neg_y) ==0.5
        end

    # 3. Squashing Bugs 
    #I initially overlooked the edge case where multiple values are exactly equal. 
    #This caused the code to calculate the mean prematurely without including all the duplicate numbers. 
    #The 'Squashing Bugs' test case helped me identify this issue.
    # I fixed it by adding a loop that checks for duplicates and ensures the mean is calculated only 
    #after all identical values (ties) are added to the cumulative sum.
        @testset "Squashing Bugs" begin
            @test ks_func([1, 2, 2], [1, 2, 2]) == 0.0
            x_int = [1,2]
            y_float = [1.0, 2.0]
            @test ks_func(x_int, y_float) == 0.0
        end
    end
