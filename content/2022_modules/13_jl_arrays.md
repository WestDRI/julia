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

Elements separated by semi-colons or end of line get expanded vertically. Those separated by commas do not get expanded. Elements separated by spaces or tabs get expanded horizontally.

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

## Initializing arrays

Here are a few of the functions initializing arrays:

``` julia
rand(2, 3, 4)
```

    2×3×4 Array{Float64, 3}:
    [:, :, 1] =
     0.798047  0.496548  0.236837
     0.668231  0.109772  0.903741

    [:, :, 2] =
     0.65958    0.740433  0.131257
     0.0576897  0.766578  0.710548

    [:, :, 3] =
     0.934939  0.219563  0.363393
     0.105168  0.323677  0.0644256

    [:, :, 4] =
     0.963333  0.279537  0.243513
     0.731795  0.456465  0.754355

``` julia
rand(Int64, 2, 3, 4)
```

    2×3×4 Array{Int64, 3}:
    [:, :, 1] =
     -5877684800836648487  -8004892433994089835   1569062311890483209
      6746795739727460269   -390670006413537477  -7588162193144172996

    [:, :, 2] =
     -8045145312760491744   3898316157625349679  7143617639483134893
      7654763728111701016  -2626889611392855788  7794551181658274315

    [:, :, 3] =
     -4028612176419923140  5000708450664997944  -4666281487633278287
     -9092379100401401553  6642748728533427738   2973413358574734622

    [:, :, 4] =
      6206262993944991558  -1018925241949506705   1781064374107573695
     -5690545416867372913   3114699551660702936  -8369210866128032461

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

As in other mathematically oriented languages such as R, Julia starts indexing at `1`. <br>
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

## Comprehensions

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
