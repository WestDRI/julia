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

The `include` function sources a Julia script (in a REPL session or in another script):

``` julia
include("file.jl")
```

The code contained in `file.jl` is thus run non interactively.

## Running code from the command line

You can run scripts by passing them to the `julia` command on the command line:

``` shell
$ julia script.jl
```

{{<notes>}}
Note that this code is run in a terminal, not in Julia, as is indicated by the \$ prompt.
{{</notes>}}

You can also evaluate single expressions in Julia from the command line by using the flag `-e`:

``` shell
$ julia -e 'println(2 + 3)'
```

    5

### Passing arguments

#### To the julia command itself

If you want to pass arguments to the `julia` command itself, you need to add them before the script or the Julia expression.

{{<ex>}}
Example:
{{</ex>}}

``` shell
$ julia -O script.jl
```

#### To the script/Julia expression

To pass arguments to the script (or Julia expression if you use `-e`), you add them after the script or expression:

``` shell
$ julia script.jl arg1 arg2 arg3
```

`arg1`, `arg2`, `arg3` will be passed in the global constant `ARGS` and interpreted as arguments to the script.

{{<ex>}}
Example passing arguments to an expression:
{{</ex>}}

``` shell
$ julia -e 'for x in ARGS; println(x); end' 2 3
```

    2
    3

#### To both

To pass arguments both to the `julia` command and to the script/expression, you need to add the `--` delimiter before the script/expression:

``` shell
$ julia [switches] -- [programfile] [args...]
```

{{<ex>}}
Example:
{{</ex>}}

``` shell
$ julia -O -- script.jl arg1 arg2
```

## Comments & questions
