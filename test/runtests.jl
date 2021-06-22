#!/usr/bin/env julia

using KeyboardDriven
using Test

@time begin
@time @testset "Bytes to key" begin include("test_bytestokey.jl") end
end

