---
title: Non interactive execution
description: Zoom
colordes: "#e86e0a"
slug: 16_jl_non_interactive
weight: 16
execute:
  error: true
format: hugo
jupyter: julia-1.7
---



## Sourcing a file

Julia scripts have a `.jl` extension.

`include()` sources a Julia script (in a REPL session or in another script):

``` julia
include("file.jl")
```

## Running code non-interactively

You can run scripts by passing them to the `julia` command on the command line:

``` shell
$ julia script.jl
```

You can evaluate single expressions in Julia from the command line by using the flag `-e`:

``` shell
$ julia -e 'println(2 + 3)'
```

    5

### Passing arguments

#### To the julia command itself

If you want to pass arguments to the `julia` command itself, you need to add them before the script of Julia expression. If you also want to first and use the `--` delimiter to

#### To the script/Julia expression

To pass argument to the script (or Julia expression if you use `-e`), you simply add them at the end of the command line expression:

``` shell
$ julia script.jl arg1 arg2 arg3
```

`arg1`, `arg2`, `arg3` will be passed in the global constant `ARGS` and interpreted as arguments to the script.

This is the same with single Julia expressions:

``` shell
julia -e 'for x in ARGS; println(x); end' 2 3
```

    2
    3

## Summary of the Julia command

In short, here is the way to run the `julia` command:

``` shell
julia [switches] -- [programfile] [args...]
```

## Comments & questions
