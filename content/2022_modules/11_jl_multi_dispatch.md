---
title: Multiple dispatch
description: Zoom
colordes: "#e86e0a"
slug: 11_jl_multi_dispatch
weight: 11
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



## Concepts

### Dynamic dispatch

Functions can be polymorphic (multiple versions exist with the same name).

Dynamic dispatch is the process of selecting one version of a function at run time.

#### Single dispatch

The choice of version is based on a single object.

This is typical of object-oriented languages such as Python, C++, Java, Smalltalk, etc.

#### Multiple dispatch

The choice of version is based on the combination of all operands and their types.

This the case of Lisp and Julia.

In Julia, the versions of a function are called **methods**.

## Methods

Julia uses {{<a "https://en.wikipedia.org/wiki/Multiple_dispatch" "multiple dispatch:">}} functions can have several methods. When that is the case, the method applied depends on the types of all the arguments passed to the function (rather than only the first argument as is common in other languages).

``` julia
methods(+)
```

You can see that `+` has 208 methods!

Methods can be added to existing functions.

{{<exo>}}
Try to understand the following example:
{{</exo>}}

``` julia
abssum(x::Int64, y::Int64) = abs(x + y)
```

    abssum (generic function with 2 methods)

``` julia
abssum(x::Float64, y::Float64) = abs(x + y)
```

    abssum (generic function with 2 methods)

``` julia
abssum(2, 4)
```

    6

``` julia
abssum(2.0, 4.0)
```

    6.0

``` julia
abssum(2, 4.0)
```

    LoadError: MethodError: no method matching abssum(::Int64, ::Float64)
    [0mClosest candidates are:
    [0m  abssum(::Int64, [91m::Int64[39m) at In[9]:1
    [0m  abssum([91m::Float64[39m, ::Float64) at In[10]:1

{{<exo>}}
What could you do if you wanted the last expression to work?
{{</exo>}}

## Examples

## Comments & questions
