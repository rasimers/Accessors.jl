module TestDelete
using Test
using Accessors

@testset "test delete" begin
    @test delete( (a=1, b=2, c=3), @optic(_.a) ) == (b=2, c=3)
    @test delete( (a=1, b=2, c=3), @optic(_.xxxx) ) == (a=1, b=2, c=3)
    @test delete( (a=1, b=(c=2, d=3)), @optic(_.b.c) ) == (a=1, b=(d=3,))
    @test delete( (1,2,3), @optic(last(_)) ) == (1, 2)
    let A = [1,2,3]
        @test delete(A, @optic(_[2])) == [1, 3]
        @test_throws BoundsError delete(A, @optic(_[10]))
        @test delete(A, @optic(_[end])) == [1, 2]
        @test A == [1, 2, 3]  # not changed
    end
    let A = Dict("a" => 1, "b" => 2, "c" => 3)
        @test delete(A, @optic(_["a"])) == Dict("b" => 2, "c" => 3)
        @test delete(A, @optic(_["xxxx"])) == A  # follows Base.delete! behavior
        @test A == Dict("a" => 1, "b" => 2, "c" => 3)  # not changed
    end
    @test delete( (a=1, b=(2, 3, 4)), @optic(first(_.b)) ) == (a=1, b=(3, 4))
    @test delete( "path/to/file", @optic(basename(_)) ) == "path/to"
    @test delete( "path/to/file", @optic(dirname(_)) ) == "file"
end

end