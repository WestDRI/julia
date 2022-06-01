---
title: Macros
description: Zoom
colordes: "#e86e0a"
slug: 12_jl_macros
weight: 12
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



## Metaprogramming

{{<emphasis>}}
Julia code is itself data and can be manipulated by the language while it is running
{{</emphasis>}}

## Metaprogramming

-   Large influence from {{<a "https://en.wikipedia.org/wiki/Lisp\_(programming_language)" "Lisp">}}
-   Since Julia is entirely written in Julia, it is particularly well suited for metaprogramming

## Parsing and evaluating

Let's start with something simple:

``` julia
2 + 3
```

    5

How is this run internally?

## Parsing and evaluating

The string `"2 + 3"` gets parsed into an expression:

``` julia
Meta.parse("2 + 3")
```

    :(2 + 3)

Then that expression gets evaluated:

``` julia
eval(Meta.parse("2 + 3"))
```

    5

## Macros

They resemble functions and just like functions, they accept as input a tuple of arguments.

**BUT** macros return an expression which is compiled directly rather than requiring a runtime `eval` call.

So they execute *before* the rest of the code is run.

Macro's names are preceded by `@` (e.g. `@time`).

## Macros

Julia comes with many macros and you can create your own with:

``` julia
macro <name>()
    <body>
end
```

## Stylistic conventions

As with functions, Julia suggests to use lower case, without underscores, as macro names.

## Comments & questions
