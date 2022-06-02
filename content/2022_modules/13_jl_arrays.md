---
title: Arrays
description: Zoom
colordes: "#e86e0a"
slug: 13_jl_arrays
weight: 13
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



Arrays are mutable and indexable collections of elements.

## Vectors

Unidimensional arrays in Julia are called vectors.

### Vectors of one element

``` julia
[3]
```

    1-element Vector{Int64}:
     3

``` julia
[3.4]
```

    1-element Vector{Float64}:
     3.4

``` julia
["Hello, World!"]
```

    1-element Vector{String}:
     "Hello, World!"

### Vectors of multiple elements

``` julia
[3, 4]
```

    2-element Vector{Int64}:
     3
     4

## Two dimensional arrays

``` julia
[3 4]
```

    1×2 Matrix{Int64}:
     3  4

``` julia
[[1, 3] [1, 2]]
```

    2×2 Matrix{Int64}:
     1  1
     3  2

## Syntax subtleties

These 3 syntaxes are equivalent:

``` julia
[2 4 8]
```

    1×3 Matrix{Int64}:
     2  4  8

``` julia
hcat(2, 4, 8)
```

    1×3 Matrix{Int64}:
     2  4  8

``` julia
cat(2, 4, 8, dims=2)
```

    1×3 Matrix{Int64}:
     2  4  8

These 4 syntaxes are equivalent:

``` julia
[2
 4
 8]
```

    3-element Vector{Int64}:
     2
     4
     8

``` julia
[2; 4; 8]
```

    3-element Vector{Int64}:
     2
     4
     8

``` julia
vcat(2, 4, 8)
```

    3-element Vector{Int64}:
     2
     4
     8

``` julia
cat(2, 4, 8, dims=1)
```

    3-element Vector{Int64}:
     2
     4
     8

Elements separated by semi-colons or end of lines get expanded vertically.<br>
Those separated by commas do not get expanded.<br>
Elements separated by spaces or tabs get expanded horizontally.

{{<exo>}}
Compare the outputs of the following:
{{</exo>}}

``` julia
[1:2; 3:4]
```

    4-element Vector{Int64}:
     1
     2
     3
     4

``` julia
[1:2
 3:4]
```

    4-element Vector{Int64}:
     1
     2
     3
     4

``` julia
[1:2, 3:4]
```

    2-element Vector{UnitRange{Int64}}:
     1:2
     3:4

``` julia
[1:2 3:4]
```

    2×2 Matrix{Int64}:
     1  3
     2  4

## Arrays and types

In Julia, arrays can be heterogeneous:

``` julia
[3, "hello"]
```

    2-element Vector{Any}:
     3
      "hello"

This is possible because all elements of an array, no matter of what types, will always sit below the `Any` type in the [type hierarchy](https://westgrid-julia.netlify.app/2022_modules/10_jl_types/#julia-types-a-hierarchical-tree).

## Initializing arrays

Below are examples of some of the functions initializing arrays:

``` julia
rand(2, 3, 4)
```

    2×3×4 Array{Float64, 3}:
    [:, :, 1] =
     0.287968  0.460719  0.153366
     0.280913  0.539013  0.00871208

    [:, :, 2] =
     0.265209  0.655567  0.537502
     0.26706   0.674964  0.861944

    [:, :, 3] =
     0.953564  0.907631   0.828447
     0.515199  0.0105021  0.695217

    [:, :, 4] =
     0.583481  0.84174    0.970322
     0.152088  0.0482478  0.560455

``` julia
rand(Int64, 2, 3, 4)
```

    2×3×4 Array{Int64, 3}:
    [:, :, 1] =
     283631121498974884  5523893714833594940  -766547241876310447
     193907474732102996   117640300918070571  2207880073658713015

    [:, :, 2] =
     5448671591094212079  -6818252937298802646  -6593535695756447601
     5644809475266060301  -8052566091470393472   -894025445933767430

    [:, :, 3] =
     -4704833441856952965  -7395983219772785088   7078606437917951545
     -3634511620742085399  -2898846961850744754  -5207663753325904582

    [:, :, 4] =
     -3498469619188751973  8296251293241855904  9094565288786527968
      -825154316697021437  6105724017006134850  3820314553677873025

``` julia
zeros(Int64, 2, 5)
```

    2×5 Matrix{Int64}:
     0  0  0  0  0
     0  0  0  0  0

``` julia
ones(2, 5)
```

    2×5 Matrix{Float64}:
     1.0  1.0  1.0  1.0  1.0
     1.0  1.0  1.0  1.0  1.0

``` julia
reshape([1, 2, 4, 2], (2, 2))
```

    2×2 Matrix{Int64}:
     1  4
     2  2

``` julia
fill("test", (2, 2))
```

    2×2 Matrix{String}:
     "test"  "test"
     "test"  "test"

## Indexing

As in other mathematically oriented languages such as R, Julia starts indexing at `1`.

Indexing is done with square brackets:

``` julia
a = [1 2; 3 4]
```

    2×2 Matrix{Int64}:
     1  2
     3  4

``` julia
a[1, 1]
```

    1

``` julia
a[1, :]
```

    2-element Vector{Int64}:
     1
     2

``` julia
a[:, 1]
```

    2-element Vector{Int64}:
     1
     3

{{<exo>}}
Index the element on the 3<sup>rd</sup> row and 2<sup>nd</sup> column of {{<c>}}b{{</c>}}:
{{</exo>}}

``` julia
b = ["wrong" "wrong" "wrong"; "wrong" "wrong" "wrong"; "wrong" "you got it" "wrong"]
```

    3×3 Matrix{String}:
     "wrong"  "wrong"       "wrong"
     "wrong"  "wrong"       "wrong"
     "wrong"  "you got it"  "wrong"

As in Python, by default, arrays are passed by sharing:

``` julia
a = [1, 2, 3];
a[1] = 0;
a
```

    3-element Vector{Int64}:
     0
     2
     3

This prevents the unwanted copying of arrays.

## Broadcasting

To apply a function to each element of a collection rather than to the collection as a whole, Julia uses broadcasting.

``` julia
a = [-3, 2, -5]
```

    3-element Vector{Int64}:
     -3
      2
     -5

``` julia
abs(a)
```

    LoadError: MethodError: no method matching abs(::Vector{Int64})
    [0mClosest candidates are:
    [0m  abs([91m::Unsigned[39m) at /usr/share/julia/base/int.jl:179
    [0m  abs([91m::Signed[39m) at /usr/share/julia/base/int.jl:180
    [0m  abs([91m::Complex[39m) at /usr/share/julia/base/complex.jl:277
    [0m  ...

This doesn't work because the function `abs` only applies to single elements.

By broadcasting `abs`, you apply it to each element of `a`:

``` julia
broadcast(abs, a)
```

    3-element Vector{Int64}:
     3
     2
     5

The dot notation is equivalent:

``` julia
abs.(a)
```

    3-element Vector{Int64}:
     3
     2
     5

It can also be applied to the pipe, to unary and binary operators, etc.

``` julia
a .|> abs
```

    3-element Vector{Int64}:
     3
     2
     5

{{<exo>}}
Try to understand the difference between the following 2 expressions:
{{</exo>}}

``` julia
abs.(a) == a .|> abs
```

    true

``` julia
abs.(a) .== a .|> abs
```

    3-element BitVector:
     1
     1
     1

{{<notes>}}
Hint: 0/1 are a short-form notations for false/true in arrays of booleans.
{{</notes>}}

## Comprehensions

Julia has an array comprehension syntax similar to Python's:

``` julia
[ 3i + j for i=1:10, j=3 ]
```

    10-element Vector{Int64}:
      6
      9
     12
     15
     18
     21
     24
     27
     30
     33

## Comments & questions
