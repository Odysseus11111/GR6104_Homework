using Test
include("C:/Users/Odysseus/GR6104_Homework/HW2/src/ks-stat.jl")
@testset "KS Statistics implementation tests" verbose=true begin
    
    # 1. Simple Examples            
    @testset "ks_func: Simple Examples" begin
        @test ks_func([1, 2], [1, 2]) == 0.0
        @test ks_func([1, 2], [10, 11]) == 1.0
        x_1 = [1,2,3,4]
        y_1 = [3,4,5,6,7] 
        @test ks_func(x_1, y_1) == 0.6
        end

    # 2. Corner Cases
    @testset "ks_func: Corner Cases" begin
        @test ks_func([1], [1]) == 0

        @test isapprox(ks_func([10], collect(1:10)), 0.9)

        neg_x = [-1,-2,-3,-4] 
        neg_y = [-1,2,-3,4]
        @test ks_func(neg_x,neg_y) ==0.5

    end
    # 3. Squashing Bugs
    @testset "Squashing Bugs" begin
        @test ks_func([1, 2, 2], [1, 2, 2]) == 0.0
        x_int = [1,2]
        y_float = [1.0, 2.0]
        @test ks_func(x_int, y_float) == 0.0
    end
end