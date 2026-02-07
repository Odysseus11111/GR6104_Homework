using Test
include("C:/Users/Odysseus/GR6104_Homework/HW2/src/ks-stat.jl")
@testset "KS Statistics implementation tests" verbose=true begin
    
    # 1. Simple Examples            
    @testset "ks_func: Simple Examples" begin
            x_1= [1,2]
            y_1= [1,2]
            @test ks_func(x_1,y_1) == 0.0

            x_2 = [1,2,3]
            y_2 = [4,5,6]
            @test ks_func(x_2,y_2) == 1

            x_3 = [1,2,3,4]
            x_4 = [3,4,5,6,7] 
            @test ks_func(x_3,x_4) ==0.5

        end

    # 2. Corner Cases
    @testset "ks_func: Corner Cases" begin

        @test ks_func([1,1,1],[1,1,1]) == 10

        @test ks_func([1],[1]) == 0

        @test ks_func([10],[1,2,3,4,5,6,7,8,9,10]) == 1

        neg_x = [-1,-2,-3,-4] 
        neg_y = [-1,2,-3,4]
        @test ks_func(neg_x,neg_y) ==0.75

    end
        
end